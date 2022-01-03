//section Functions in Mata

//..............................................................................
//subsection basics

//slide ------------------------------------------------------------------------
//title functions

/*txt
{pstd}
In said before that in Mata something is either a variable or a function, and we
have talked about variables

{pstd}
A function is a program, for example:
txt*/

//ex
mata:
mata clear
mata set matastrict off

real scalar my_median(string scalar varn)
{
    x = st_data(.,varn, 0)
    _sort(x,1)
    index = ceil(rows(x)/2)
    return(x[index])
}
end

sysuse nlsw88, clear
mata: my_median("tenure")
sum tenure, detail
//endex

/*txt
{pstd}
So we created a function called {cmd:my_median()}

{pstd}
But first we need to specify what kind of thing this function is going to return,
in our case a real scalar (a single number)

{pstd}
Within the parantheses we specify what our function expects as arguments{p_end}
{pmore}First what kind of thing it is, in our case a string scalar{p_end}
{pmore}Second the name it will have inside our function, in our case {it:varn}{p_end}

{pstd}
Whithin the braces we put what the function does, in our case:{p_end}
{pmore}We first loaded the data{p_end}
{pmore}Sorted that variable{p_end}
{pmore}Computed at what point the middle is{p_end}
{pmore}Returned the middle value{p_end}

{pstd}
It is a start, but there are still various problems with this function
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Create a similar function {cmd:my_mean()} which returns the mean (ignoring the 
fact that Mata already has a function {helpb mf_mean:mean()})

//apcodefile my_mean01.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Conditional statements

/*txt
{pstd}
One of the problems with {cmd:my_median()} is that the way I computed the middle 
observation is only valid for an uneven number of observations

{pstd}
So we want to do different computations depending on whether the number of 
observations is even or uneven. 
txt*/

//ex
mata:
mata clear
mata set matastrict off

real scalar my_median(string scalar varn)
{
    x = st_data(.,varn, 0)
    n = rows(x)
    _sort(x,1)
    if (mod(n,2)==1) {
        index = ceil(n/2)
        median = x[index]
    }
    else {
        index = floor(n/2)
        median = x[index]
        index = index + 1
        median = (median + x[index])/2
    }
    return(median)
}
end

sysuse nlsw88, clear
mata: my_median("tenure")
sum tenure, detail
mata: my_median("ttl_exp")
sum ttl_exp, detail
//endex

/*txt
{pstd}
Unlike Stata, in Mata we need parantheses after {helpb [M-2] if:if()}

{pstd}
The condition is between the parantheses

{pstd}
Within the braces is what we do when that condition is met

{pstd}
We can chain conditions with {cmd:else if ()} and finally {cmd:else}

{pstd}
Another thing we might want add to our function is a check if the variable we 
receive is a numeric variable

{pstd}
If that is not true, we should return an error message
txt*/
//ex

mata:
mata clear
mata set matastrict off

real scalar my_median(string scalar varn)
{
    if (st_isnumvar(varn)==0) exit(error(108))
    
    x = st_data(.,varn, 0)
    n = rows(x)
    _sort(x,1)
    if (mod(n,2)==1) {
        index = ceil(n/2)
        median = x[index]
    }
    else {
        index = floor(n/2)
        median = x[index]
        index = index + 1
        median = (median + x[index])/2
    }
    return(median)
}
end

sysuse nlsw88, clear
mata: my_median("tenure")
sum tenure, detail
mata: my_median("ttl_exp")
sum ttl_exp, detail

decode industry, gen(str_ind)
mata: my_median("str_ind")
//endex

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Check if the variable is numeric in your {cmd:my_mean()} function

//apcodefile my_mean02.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title loops

/*txt
{pstd}
What if we want to allow for multiple variables?

{pstd}
We could split up the scalar varn into words (in this case variable names) with
{helpb mf_tokens:tokens()}

{pstd}
The number of columns is the number of variables

{pstd}
We can loop over those
txt*/
//ex
mata:
mata clear
mata set matastrict off

real rowvector my_median(string scalar varn)
{
    varn = tokens(varn)
    k = cols(varn)
    median = J(1,k,.)
    
    for(i=1; i<=k; i++) {
        if (st_isnumvar(varn[i])==0) exit(error(108))   
        x = st_data(.,varn[i], 0)
        n = rows(x)
        _sort(x,1)
        if (mod(n,2)==1) {
            index = ceil(n/2)
            median[i] = x[index]
        }
        else {
            index = floor(n/2)
            median[i] = x[index]
            index = index + 1
            median[i] = (median[i] + x[index])/2
        }
    }
    
    return(median)
}
end

sysuse nlsw88, clear
mata: my_median("tenure ttl_exp")
sum tenure ttl_exp, detail
//endex

/*txt
{pstd}
So a loop happens with the {helpb m2_for:for()} functions

{pstd}It expects three arguments:{p_end}
{pmore}The first tells where the loop starts{p_end}
{pmore}The second tells how long the the loop has to continue{p_end}
{pmore}The third tells what happens at the end of each iteration/step{p_end}


{pstd}
An alternative way to loop is with the {helpb m2_while:while()} function
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Change your {cmd:my_mean()} function to allow for multiple variables

//apcodefile my_mean03.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title declare your variables

/*txt
{pstd}
It is good practice to first declare the variables you make in a functions, that 
is, tell Mata what kind of variable it is

{pstd}
This will make your function (a bit) faster

{pstd}
It provides a built in check whether what you create is actually what you think 
it should be.

{pstd}
You can force yourself to declare your variables by setting {cmd:matastrict} to on.
txt*/

//ex
mata:
mata clear
mata set matastrict on

real rowvector my_median(string scalar varn)
{
    real scalar k, i, n, index
    real rowvector median
    real colvector x
    
    varn = tokens(varn)
    k = cols(varn)
    median = J(1,k,.)
    
    for(i=1; i<=k; i++) {
        if (st_isnumvar(varn[i])==0) exit(error(108))   
        x = st_data(.,varn[i], 0)
        n = rows(x)
        _sort(x,1)
        if (mod(n,2)==1) {
            index = ceil(n/2)
            median[i] = x[index]
        }
        else {
            index = floor(n/2)
            median[i] = x[index]
            index = index + 1
            median[i] = (median[i] + x[index])/2
        }
    }
    
    return(median)
}
end

sysuse nlsw88, clear
mata: my_median("tenure ttl_exp")
sum tenure ttl_exp, detail
//endex

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Change your {cmd:my_mean()} function by declaring your variables first

//apcodefile my_mean04.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Make your function part of a Stata program

/*txt
{pstd}
The users of our functions will often want to use our functions from Stata and 
not Mata

{pstd}
So we need a Stata program to interface between the users and our function

{pstd}
Moreover, there are lots of convenient tools in Stata for parcing standard 
syntax and displaying standard output
txt*/

//ex
program drop _all
program define my_median, rclass
    version 16
    syntax varlist(numeric) 
    
    tempname res
    mata: my_median("`varlist'")
    matrix colnames `res' = `varlist'
    matrix rownames `res' = "median"
    matlist `res'
    return matrix median = `res'
end

mata:
mata clear
mata set matastrict on

void my_median(string scalar varn )
{
    real scalar k, i, n, index
    real rowvector median
    real colvector x
    
    varn = tokens(varn)
    k = cols(varn)
    median = J(1,k,.)
    
    for(i=1; i<=k; i++) {
        x = st_data(.,varn[i], 0)
        n = rows(x)
        _sort(x,1)
        if (mod(n,2)==1) {
            index = ceil(n/2)
            median[i] = x[index]
        }
        else {
            index = floor(n/2)
            median[i] = x[index]
            index = index + 1
            median[i] = (median[i] + x[index])/2
        }
    }
    
    st_matrix(st_local("res"),median)
}
end

sysuse nlsw88, clear
my_median tenure ttl_exp
sum tenure ttl_exp, detail
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Create a Stata program for your {cmd:my_mean()} function 

//apcodefile my_mean05.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Turn it into an .ado file
/*txt
{pstd}
Now all we need to do is clean it up and store it as an .ado file

//codefile my_median.ado "The file"
txt*/

//ex
sysuse auto
my_median price mpg
sum price mpg, d
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Make your own .ado file for {cmd:my_mean}

//apcodefile my_mean06.ado "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection Linear regression and instrumental variable regression
//slide ------------------------------------------------------------------------
//title turn our Mata code into a function

/*txt
{pstd}
Lets revist our linear regression 
txt*/

//ex
sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

tempname b V

mata:
X=y=.
st_view(X,.,"grade union ttl_exp tenure south", "touse")
st_view(y,.,"wage", "touse")
XX = cross(X,1, X,1)
Xy = cross(X,1, y,0)
b = invsym(XX)*Xy

N = rows(X)
k = cols(X) + 1
cons = J(N,1,1)
res = y - (X,cons)*b
ess = cross(res,res)
s2 = ess/(N-k)
Var = s2*invsym(XX)

st_matrix(st_local("b"), b')
st_matrix(st_local("V"), Var)
st_local("df_r", strofreal(N-k))
st_local("N", strofreal(N))
end

local xnames `""grade" "union" "ttl_exp" "tenure" "south" "_cons""'
matrix colnames `b' = `xnames'
matrix colnames `V' = `xnames'
matrix rownames `V' = `xnames'
ereturn post `b' `V', dof(`df_r') obs(`N') esample(touse)
ereturn display

reg wage grade union ttl_exp tenure south
//endex

/*txt
{pstd}
To turn this into function we want the name of the dependent independent and 
selection variable to be arguments
txt*/

//ex
sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

tempname b V

mata:
mata clear
mata set matastrict on

void my_regress(string scalar depvar, string scalar indepvars, string scalar select)
{
    transmorphic X, y
    real matrix XX, Xy, Var
    real colvector b, cons, res
    real scalar N, k, ess, s2
    
    X=y=.
    st_view(X,.,indepvars, select)
    st_view(y,.,depvar, select)
    XX = cross(X,1, X,1)
    Xy = cross(X,1, y,0)
    b = invsym(XX)*Xy

    N = rows(X)
    k = cols(X) + 1
    cons = J(N,1,1)
    res = y - (X,cons)*b
    ess = cross(res,res)
    s2 = ess/(N-k)
    Var = s2*invsym(XX)

    st_matrix(st_local("b"), b')
    st_matrix(st_local("V"), Var)
    st_local("df_r", strofreal(N-k))
    st_local("N", strofreal(N))
}
end

mata: my_regress("wage", "grade union ttl_exp tenure south", "touse")
local xnames `""grade" "union" "ttl_exp" "tenure" "south" "_cons""'
matrix colnames `b' = `xnames'
matrix colnames `V' = `xnames'
matrix rownames `V' = `xnames'
ereturn post `b' `V', dof(`df_r') obs(`N') esample(touse)
ereturn display

reg wage grade union ttl_exp tenure south
//endex
//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Do the same for your 2sls model

{pstd}
As arguments we want the dependent variable, the exogenous variable, the endogenous
variables, the instruments, the constant, and the 
selection variable.

{pstd}
To get the variables for the {cmd:X} matrix we need to combine the names of the 
exogenous, endogenous, and the constant

{pstd}
To get the variables for the {cmd:Z} matrix we need to combine the names of the 
exogenous, instruments, and the constant

{pstd}
We can combine string scalars with {cmd:+}, but don't forget to add a 
space
txt*/

//ex
mata:
greetings = "Hello"
who = "world"
greetings + who
greetings + " " + who
end
//endex

/*txt
//apcodefile tsls05.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Turn it into a Stata program

/*txt
{pstd}
Now we can turn it into a Stata program

{pstd}
We can use {helpb mark:marksample} to create our selection variable, this enables
use to allow standard {cmd:if} and {cmd:in} conditions for our program
txt*/

//ex
mata:
mata clear
mata set matastrict on

void my_regress(string scalar depvar, string scalar indepvars, string scalar select)
{
    transmorphic X, y
    real matrix XX, Xy, Var
    real colvector b, cons, res
    real scalar N, k, ess, s2
    
    X=y=.
    st_view(X,.,indepvars, select)
    st_view(y,.,depvar, select)
    XX = cross(X,1, X,1)
    Xy = cross(X,1, y,0)
    b = invsym(XX)*Xy

    N = rows(X)
    k = cols(X) + 1
    cons = J(N,1,1)
    res = y - (X,cons)*b
    ess = cross(res,res)
    s2 = ess/(N-k)
    Var = s2*invsym(XX)

    st_matrix(st_local("b"), b')
    st_matrix(st_local("V"), Var)
    st_local("df_r", strofreal(N-k))
    st_local("N", strofreal(N))
}
end


program drop _all
program define my_regress, eclass
    version 16
    syntax varlist(numeric) [if] [in]
    
    marksample touse
    
    tempname b V
    
    gettoken y x : varlist
    
    mata: my_regress("`y'", "`x'", "`touse'")
    matrix colnames `b' = `x' "_cons"
    matrix colnames `V' = `x' "_cons"
    matrix rownames `V' = `x' "_cons"
    ereturn post `b' `V', dof(`df_r') obs(`N') esample(`touse') depname("`y'")
    ereturn display
end

sysuse nlsw88, clear

my_regress wage grade union ttl_exp tenure south
reg wage grade union ttl_exp tenure south
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Do the same to your 2sls program

{pstd}
The {cmd:syntax} I would use is:

{cmd}
    syntax varlist(numeric) [if] [in], ///
         endog(varlist numeric)        ///
         instruments(varlist numeric)
{txt}

{pstd}
The first variable in varlist is the dependent, and the remaining variables are 
the exogenous variables. 

//apcodefile tsls06.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Turn it into a .ado file

/*txt
{pstd}
As before, all we need to do is clean up, put the Mata code at the bottom of the
file, and save it as an .ado file

//codefile my_regress.ado "the file"
txt*/

//ex
sysuse auto
my_regress price weight length mpg
regress price weight length mpg
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Do the same to your 2sls program

//apcodefile my_2sls07.ado "(solution)"
txt*/

//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection Maximum likelihood: logit and Poisson regression
//slide ------------------------------------------------------------------------
//title Maximum Likelihood

/*txt 
{pstd}
You start with a model, which has parameters, and dataset

{pstd}
Find those parameters that maximize the probability of observing the data 
assuming the model is true

{pstd}
{cmd:Example:} 

{pmore}
We want to know the probability that someone is a member of a trade 
union

{pmore}
Data: N persons and a binary variable {it:union}, which is 1 when the person is
a union member, and 0 when not

{pmore}
The model: There is a fixed probability {it:pi} that a person is a member

{pmore}
The likelihood: If someone is a member, then the probability of seeing such a 
person is {it:pi}

{pmore}
If someone is not a member then the probability of observing that person is 
(1-{it:pi})

{pmore}
Say we observe 3 union members and 2 non-members, then the likelihood is :

{pmore}
L({it:pi}|data) = {it:pi}*{it:pi}*{it:pi}*(1-{it:pi})*(1-{it:pi})

{pmore}
L({it:pi}|data) = Prod({it:pi}^union * (1-{it:pi})^(1-union)

{pmore}
We need to find the value of {it:pi} that maximizes L

{pstd}
It is actually more convenient to maximize the log of the likelihood

{pstd}
Remember:{p_end}
{pmore}ln(a*b) = ln(a) + ln(b){p_end}
{pmore}ln(a^b) = b ln(a){p_end}

{pmore}
ln(L({it:pi}|data)) = ln(Prod({it:pi}^union * (1-{it:pi})^(1-union))

{pmore}
ln(L({it:pi}|data)) = sum(ln({it:pi}^union) + ln((1-{it:pi})^(1-union))

{pmore}
ln(L({it:pi}|data)) = sum(union*ln({it:pi}) + (1-union)*ln(1-{it:pi})

{pstd}
Typically, we don't think there is one probability for everybody, but we are 
interested in how that probability differs depending on explanatory variables

{pstd}
So we replace {it:pi} with a function of of those explanatory variables

{pstd}
A common choice is the logit function:{p_end}
{pmore}xb = b_0 + b_1 x_1 + b_2 x_2 + ...{p_end}
{pmore}{it:pi}= exp(xb)/(1-exp(xb)) = invlogit(xb){p_end}

{pstd}
This is logistic regression
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Maximum Likelihood in Mata
/*txt
{pstd}
In Mata you can use {helpb mf_moptimize:moptimize} to find the maximum likelihood
estimates and its variance covariance matrix

{pstd}
In fact, it is more general than that: it can be used to maximize or minimize any
function, e.g. find gmm estimates. 

{pstd}
Using {cmd:moptimize} is a multi-step process{p_end}
{pmore}1. Create a function that takes parameter values and data and returns the 
log-likelihood value (or gmm, or ...){p_end}
{pmore}2. Initialize, i.e. create an object that stores everything Mata needs for
this problem{p_end}
{pmore}3. Give that object the information it needs, at least the function and 
the data{p_end}
{pmore}4. Let moptimize find the optimum{p_end}
{pmore}5. Display the results{p_end}
{pmore}{p_end}
txt*/

//ex
sysuse auto, clear

mata:
mata clear
mata set matastrict on

// Step 1
void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
}

// Step 2
M = moptimize_init()

// Step 3
moptimize_init_evaluator(M, &logiteval())
moptimize_init_depvar(M, 1, "foreign")
moptimize_init_eq_indepvars(M,1,"price weight") 

// Step 4
moptimize(M)

// Step 5
moptimize_result_display(M)
end

logit foreign price weight
//endex

/*txt
{pstd}
In the evaluator I used {cmd:invlogit(-xb)} instead of {cmd:(1-invlogit(xb))}

{pstd}
The logistic distribution is a symmetric distribution around 0, very much like 
the standard normal distribution.

{pstd}
You may (vaguely) remember that 1-Phi(z) = Phi(z) 

{pmore}
(There was a table at the end
of your Statistics book giving you the CDF for the standard normal distribution, 
and you needed to use that to find the probability that a drawing a value more 
than some {it:z})

{pstd}
Similarly, {cmd:invlogit(-xb)} is the same as {cmd:(1-invlogit(xb))}

{pstd}
However, the former is easier for computers than the latter (precision)

{pstd}
If you want to write a Maximum Likelihood model in Stata/Mata then /*cite gould_etal10 */
is highly recommended. 
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title do it yourself poisson
/*txt
{pstd}
If we assume that the dependent variable is Poisson distributed, then the 
probability of observing a person with {it:y} events is 

{pmore}
({it:mu}^y exp(-{it:mu}))/y!

{pstd}
Where {it:mu} is the mean number of events. In case of a Poisson the {it:lambda} 
is also common

{pstd}
So the probability of observing the data given a value of {it:mu} is

{pmore}
L(y|{it:mu}) = prod(({it:mu}^y exp(-{it:mu}))/y!)

{pstd}
Taking the logarithm:

{pmore}ln(L(y|{it:mu})) = ln(prod(({it:mu}^y exp(-{it:mu}))/y!)){p_end}
{pmore}ln(L(y|{it:mu})) = Sum(ln({it:mu}^y) + ln(exp(-{it:mu})) - ln(y!)){p_end}
{pmore}ln(L(y|{it:mu})) = Sum(y*ln({it:mu}) - {it:mu} - ln(y!)){p_end}

{pstd}
The mean in case of a Poisson distribution is the expected number of events, so 
has to be positive

{pstd}
We can make the mean dependent of explanatory variables and make sure that that 
mean remains positive by using exp(xb)

{pmore}ln(L(y|{it:b})) = Sum(y*ln(exp({cmd:Xb})) - exp({cmd:xb}) - ln(y!)){p_end}
{pmore}ln(L(y|{it:b})) = Sum(y*{cmd:Xb} - exp({cmd:xb}) - ln(y!)){p_end}

{pstd}
Create a Poisson regression in Mata, use the horse.dta dataset, create indicator 
variables for the cavelary units and use those as explanatory varialbes 
(excluding the reference unit) 

//apcodefile my_poisson01.do "(solution)"
txt*/
//file horse.dta
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title include in Stata program
/*txt
{pstd}
We want to use it in a Stata program
txt*/

//ex
sysuse auto, clear
program drop _all

mata:
mata clear
mata set matastrict on

void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
}

void logitwork(string scalar depvar, string scalar indepvars)
{
    transmorphic M
    M = moptimize_init()
    moptimize_init_evaluatortype(M, "lf")
    moptimize_init_evaluator(M, &logiteval())
    moptimize_init_touse(M, st_local("touse"))
    moptimize_init_ndepvars(M,1)
    moptimize_init_depvar(M, 1, depvar)
    moptimize_init_eq_indepvars(M,1,indepvars) 
    moptimize_init_valueid(M, "log likelihood")
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}

end

program define my_logit, eclass
    version 16
    syntax varlist [if] [in]
    
    marksample touse
    
    _rmcoll `varlist' if `touse' , ///
        logit touse(`touse')       // options specific to logit (detect perfect predictions)
    
    local varlist `r(varlist)'
    gettoken y x : varlist
    
    mata logitwork("`y'", "`x'")
end

my_logit foreign price weight
logit foreign price weight

//endex
//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title do it yourself
/*txt
{pstd}
Do the same for your poisson model

//apcodefile my_poisson02.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Allow factor varialbes 
/*txt
{pstd}
It would be helpful to allow Stata's factor variables
txt*/

//ex
sysuse auto, clear
program drop _all

mata:
mata clear
mata set matastrict on

void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
}

void logitwork(string scalar depvar, string scalar indepvars)
{
    transmorphic M
    M = moptimize_init()
    moptimize_init_evaluatortype(M, "lf")
    moptimize_init_evaluator(M, &logiteval())
    moptimize_init_touse(M, st_local("touse"))
    moptimize_init_ndepvars(M,1)
    moptimize_init_depvar(M, 1, depvar)
    moptimize_init_eq_indepvars(M,1,indepvars) 
    moptimize_init_valueid(M, "log likelihood")
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}

end

program define my_logit, eclass
    version 16
    syntax varlist(fv ts) [if] [in]
    
    marksample touse
    
    _rmcoll `varlist' if `touse' , expand ///
        logit touse(`touse')       // options specific to logit (detect perfect predictions)
    
    local varlist `r(varlist)'
    gettoken y x : varlist
    _fv_check_depvar `y'
    
    mata logitwork("`y'", "`x'")
end

sum price
gen byte expensive = price > r(mean) if price < .

my_logit foreign i.expensive weight
logit foreign i.expensive weight 

//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title do it yourself
/*txt
{pstd}
Do the same for your Poisson model

//apcodefile my_poisson03.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Starting values
/*txt
{pstd}
This program can have difficulties converging, or even getting started.

{pstd}
It helps to provide meaningful starting values

{pstd}
In case of logit regression, we know that without covariates the ML-estimate of
the probability is just the mean of the dependent variable, so estimate of the 
constant is ln(mean/(1-mean)), or logit(mean)
txt*/

//ex
sysuse auto, clear
program drop _all

mata:
mata clear
mata set matastrict on

void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
}

void logitwork(string scalar depvar, string scalar indepvars)
{
    transmorphic M
    M = moptimize_init()
    moptimize_init_evaluatortype(M, "lf")
    moptimize_init_evaluator(M, &logiteval())
    moptimize_init_touse(M, st_local("touse"))
    moptimize_init_ndepvars(M,1)
    moptimize_init_depvar(M, 1, depvar)
    moptimize_init_eq_indepvars(M,1,indepvars) 
    moptimize_init_valueid(M, "log likelihood")
    moptimize_init_eq_coefs(M,1,st_matrix("r(b0)"))
    moptimize_init_search(M, "off")
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}

end

program define startval, rclass
    syntax varname [if], k(integer) 
    
    tempname b0
    matrix `b0' = J(1, `k', 0)
    
    marksample touse
    sum `varlist' if `touse', meanonly
    matrix `b0'[1,`k'] = logit(r(mean))
    return matrix b0 = `b0'

end

program define my_logit, eclass
    version 16
    syntax varlist(fv ts) [if] [in]
    
    marksample touse
    
    _rmcoll `varlist' if `touse' , expand ///
        logit touse(`touse')       // options specific to logit (detect perfect predictions)
    
    local varlist `r(varlist)'
    gettoken y x : varlist
    _fv_check_depvar `y'
    
    local k : word count `x'
    local k = `k' + 1 // the constant
    startval `y' if `touse', k(`k') `constant'
    
    mata logitwork("`y'", "`x'")
end

sum price
gen byte expensive = price > r(mean) if price < .

my_logit foreign i.expensive weight
logit foreign i.expensive weight 
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title do it yourself
/*txt
{pstd}
Do the same in your Poisson model

{pstd}
The ML-estimate of the constant when you have no explanatory variables is ln(mean)

//apcodefile my_poisson04.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title allow weights
/*txt
{pstd}
It would be nice to allow weights
txt*/

//ex
program drop _all

mata:
mata clear
mata set matastrict on

void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
}

void logitwork(string scalar depvar, string scalar indepvars)
{
    transmorphic M
    M = moptimize_init()
    moptimize_init_evaluatortype(M, "lf")
    moptimize_init_evaluator(M, &logiteval())
    moptimize_init_touse(M, st_local("touse"))
    moptimize_init_ndepvars(M,1)
    moptimize_init_depvar(M, 1, depvar)
    moptimize_init_eq_indepvars(M,1,indepvars) 
    if (st_local("weight") != "") {
        moptimize_init_weighttype(M, st_local("weight"))
        moptimize_init_weight(M, st_local("exp"))
    }
    moptimize_init_valueid(M, "log likelihood")
    moptimize_init_eq_coefs(M,1,st_matrix("r(b0)"))
    moptimize_init_search(M, "off")
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}

end

program define startval, rclass
    syntax varname [if] [fweight pweight iweight/], k(integer) 
    
    tempname b0
    matrix `b0' = J(1, `k', 0)
    
    if "`weight'" != "" local wgt [`weight' = `exp']
    if "`weight'" == "pweight" local wgt [aweight = `exp']
    marksample touse
    sum `varlist' if `touse' `wgt', meanonly
    matrix `b0'[1,`k'] = logit(r(mean))
    return matrix b0 = `b0'

end

program define my_logit, eclass
    version 16
    syntax varlist(fv ts) [if] [in] [fweight pweight iweight/] 

    if "`weight'" != "" local wgt [`weight' = `exp']
    marksample touse
    
    _rmcoll `varlist' if `touse' `wgt' , expand ///
        logit touse(`touse')       // options specific to logit (detect perfect predictions)
    
    local varlist `r(varlist)'
    gettoken y x : varlist
    _fv_check_depvar `y'
    
    local k : word count `x'
    local k = `k' + 1 // the constant
        
    startval `y' if `touse' `wgt', k(`k') `constant'
    
    mata logitwork("`y'", "`x'")
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title do it yourself
/*txt
{pstd}
Do the same for your Poisson model

//apcodefile my_poisson05.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title Make an ado file
/*txt
{pstd}
Now we can clean our code up, and save it as an .ado file

//codefile my_logit.ado "the cleaned .ado file"
txt*/

//ex
sysuse auto, clear
sum price
gen expensive = price > r(mean) if price < .
my_logit foreign i.expensive weight
logit foreign i.expensive weight 
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title do it yourself
/*txt
{pstd}
Do the same for your Poisson regression

//apcodefile my_poisson06.ado "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection Certification
//slide ------------------------------------------------------------------------
//title Certification script
/*txt
{pstd}
A certification script is just a .do file 

{pstd}
It checks if things you think should be true are actually true.

{pstd}
If you make it public, then that helps build confidence in the quality of your
program. 

{pstd}
At least, you are open about what you have checked and what you have not checked
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title What is in a certification script

/*txt
{pstd}
For estimation commands a minimalist certification script that is quick to write
and can pick up a lot of bugs before you go public would consider:

{pmore}
Often there are special cases of your model, where you know what the solution is.
In our cases, that would be the model without covariates.

{pmore}
You can "manually" implement an {cmd:if} condition by just dropping the unwanted
observations. Adding an {cmd:if} condition and the manual way, should yield the
exact same results

{pmore}
You can "manually" implement {cmd:fweight}s by {helpb expand:expanding} the 
dataset. Adding an {cmd:fweight}s and the manual way, should yield the
exact same results

{pstd}
A more complete certification script would also certify the (Mata) subroutines

{pstd}
You can read more on certification scripts in /*cite gould01 buis14 */ and 
{help cscript}

{pstd}
A basic certification script for the {cmd:my_logit} command is here:

//codefile my_logit_cert.do "certification script"
txt*/
//endslide ---------------------------------------------------------------------

