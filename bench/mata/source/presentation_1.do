//section Basics of mata

//..............................................................................
//subsection How is Mata different from Stata

//slide ------------------------------------------------------------------------
//title What is Mata

/*txt
{pstd}Mata is a programming language, that works well with{p_end}
{pmore}matrices{p_end}
{pmore}strings{p_end}
{pmore}Stata{p_end}

{pstd}Stata reads instructions (commands) one line at the time{p_end}

{pstd}
Mata is compiled, making it faster 
txt*/

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Mata and Stata

/*txt
{pstd}
Stata is high level language, which means that we humans can focus on the big 
picture because a lot of the details have already been preprogrammed.

{pstd}
For example, in Stata we can type {cmd:regress income female educ}, and we 
can think of this as a shorthand for the following conversation between me and 
Stata:

{pmore}{bf:me}:    Hi Stata. I want to run a linear regression today{p_end}
{pmore}{bf:Stata}: Hi Maarten. Great, I know how to do that. What dependent 
variable do you want to use?{p_end}
{pmore}{bf:me}:      income{p_end}
{pmore}{bf:Stata}: OK, I found it. Do you want to use any independent variables?{p_end}
{pmore}{bf:me}:    Yes, female and educ{p_end}
{pmore}{bf:Stata}: Ok, I also found those. Do you want to limit the sample in 
any way? Do you want to use weights? Is there a specific type of standard error
you wish to see?{p_end}
{pmore}{bf:me}:    No, I am good. You can start now.{p_end}
{pmore}{bf:Stata}: OK, here are your results.{p_end}

{pstd}
Mata is a lower level language, which means the humans have more control and it 
often runs faster because less is preprogrammed.

{pstd}
If I try to do the same as above then we are going to have a very long conversation...

{pmore}{bf:me}:    Hi Mata. I want to run a linear regression today{p_end}
{pmore}{bf:Mata}:  Hi Maarten. What is a "linear regression"?{p_end}
{pmore}{bf:me}:    Oh, it is a model where look at the relationship between variables{p_end}
{pmore}{bf:Mata}:  What is a variable?{p_end}
{pmore}{bf:me}:    Oh, it is a column in a matrix{p_end}
{pmore}{bf:Mata}:  I know what that is. Where shall I find that matrix? How shall 
we keep track of these “variables”? I love integers. Names, you say? Are those 
like strings? I have really long strings. Really, however, integers are better.{p_end}
txt*/

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title When to use which
/*txt
{pstd}Stata is better for . . .{p_end}
{pmore}Parsing standard syntax{p_end}
{pmore}Data management{p_end}
{pmore}Scripting existing Stata commands (writing a .do file to do an analysis){p_end}
{pmore}Outputting (usually){p_end}
{pmore}Posting saved results{p_end}

{pstd}Mata is better for . . .{p_end}
{pmore}Parsing non-standard syntax (including files){p_end}
{pmore}Performing matrix operations{p_end}
{pmore}Non-scripting applications{p_end}
{pmore}Outputting (when complicated){p_end}
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title entering and leaving Mata

/*txt
{pstd}You can enter Mata by typing in Stata either {cmd:mata} or {cmd:mata:}{p_end}

{pstd}
You can leave Mata, and enter Stata again, by typing {cmd:end}

{pstd}{cmd:mata} will continue executing till it reaches {cmd:end} even if an 
error occured{p_end}
{pmore}This is helpful when using Mata interactively to try things out{p_end}
{pmore}When trying things out, errors are expected. It is convenient when those 
errors have not other consequences than an error message.{p_end}

{pstd}{cmd:mata:} stops as soon as an error occured and drop you back into Stata.{p_end}
{pmore}This is helpful when programming{p_end} 
{pmore}This makes it easier to find where the bug is{p_end}

{pstd}
Alternatively, you can pass a single line from Stata to Mata by typing {cmd:mata: something_Mata_understands}
txt*/ 

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Try it yourself


/*txt
{pstd}
Enter Mata using {cmd:mata}

{pstd}
Type {cmd:1 + 2}

{pstd}
OK, so if we type an expression which has an answer, that answer is displayed on
screen. In fact, that answer is not stored anywhere.

{pstd}
Type {cmd:a = 1 + 2}

{pstd}
Type {cmd:a}

{pstd}
OK, so with an equal sign we can store answers

{pstd}
Lets make an error: type {cmd:a = b}. We have not defined {cmd:b} yet, so what 
can Mata do other than return an error?

{pstd}
Notice that the command prompt is still {cmd::}, i.e. we are still in Mata

{pstd}
Lets fix the error, type {cmd:b = "Hello"} and {cmd:a = b}

{pstd}
Leave Mata by typing {cmd:end}

{pstd}
We can try one-line execution of Mata commands from Stata: Type {cmd:mata: 1 + 2}

{pstd}
Lets try the same sequence of commands but with {cmd:mata:} instead of 
{cmd:mata}. You can copy the commands below in the .do file editor and run it:

{cmd}
    clear mata
    mata:
    1 + 2
    a = 1 + 2
    a
    a = b
    b = "Hello"
    a = b
    end
{txt}
txt*/
//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title things persist between Mata sessions

/*txt
{pstd}
Things you create in Mata persist between Mata sessions untill you clear Mata or
you close Stata

{pstd}
That is why I added {cmd:clear mata} to the last exercise:{p_end}
{pmore}The purpose was for the first line {cmd:a = b} to result in an error.{p_end} 
{pmore}However, in the previous exercise we successfuly created {cmd:b}, which 
will persist between sessions, so no error would occur.{p_end}
{pmore}To make the desired error occur we needed to explicitly remove it{p_end}
txt*/

//ex
mata:
a = 1
b = 2
end

mata: a

mata:
a + b

mata clear
a
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title variables

/*txt
{pstd}
In Mata something is either a variable or a function

{pstd}
Functions are like programs. We will discuss them later

{pstd}
Anything that is not a function is a variable

{pstd}
The purpose of a variable is to store information

{pstd}
Variables differ depending on what is stored and how it is organized 

{pstd}In Mata a variable can contain either: {p_end}
{pmore}A real number (real){p_end}
{pmore}A complex number (complex){p_end}
{pmore}Text (string){p_end}
{pmore}The address where another object is stored in memory (pointer){p_end}
{pmore}A set of variables tied together under one name (struct){p_end}
{pmore}A set of variables and functions tied together under one name (class){p_end}

{pstd}This information can be organized as a:{p_end}
{pmore}scalar{p_end}
{pmore}rowvector{p_end}
{pmore}colvector{p_end}
{pmore}matrix{p_end}
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title creating variables

/*txt
{pstd}
You create a variable with {cmd:=}
txt*/

//ex
mata:
A = 1 , 2 \
    3 , 4

A    
end
//endex

/*txt
{pstd}
Some functions return things that can be stored as a variable
txt*/

//ex
mata:
A = J(3,3,34)
A

A = I(3,3)
A

A = J(2,1,a)
A
end
//endex

/*txt
{pstd}
You can have matrices with 0 rows or columns or both. This can be helpful 
starting point when you want to successively add collumns or rows to a matrix.

{pmore}
Note: Starting with complete matrix and successively changing the content of rows
and columns is a lot quicker than changing the number of rows and columns of a 
matrix. 
txt*/

//ex
mata:
A = J(2,0,.)

A = A , (2 \ 3)
A
end
//endex

/*txt
{pstd}
You can chain assignments, which can be an easy way to initialize multiple variables
txt*/

//ex
mata:
a = b = 2
a
b
end
//endex

/*txt
{pstd}
You can be more fancy with that
txt*/

//ex
mata:
fraction = 2 /(sum=2+3)
fraction
sum
end
//endex
//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection matrix operations 
//slide ------------------------------------------------------------------------
//title arithmatic

/*txt
{pstd}
Matrix addition, subtraction, and multiplication work as you would expect with 
the {cmd:+}, {cmd:-}, and {cmd:*} operators:
txt*/

//ex
mata:
A = 1 , 2 \        
    3 , 2           

b = 1     \
    2

C = 2 , 4 \   
    1 , 3    

A + C 

A - C 

A * C 

A * b
end 
//endex


/*txt
{pstd}
Multiplication of a matrix by a scalar works as expected

{pstd}
By analogy, division by a scalar works just fine with the {cmd:/} operator

{pstd}
The {cmd:/} operator does not work matrix division
txt*/

//ex
mata:
A*2
A/2
A / C
end
//endex

/*txt
{pstd}
You can transpose a matrix with {cmd:'}
txt*/

//ex
mata:
b'
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title elementwise operations
/*txt
{pstd}
Alternatively, you sometimes want to do something element by element 

{pstd}
For that you can add a colon in front of many operators
txt*/

//ex
mata:
A
b
C

A:*C
A:*b
A:*b'
end
//endex

/*txt
{pmore}
What rules does {cmd::*} apply to these matrices?
txt*/
//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title Subscripting

/*txt
{pstd}
We can get at cells in a matrix using {cmd:[]}:
txt*/

//ex
mata:
A
b

A[2,1]
b[2]
end
//endex

/*txt
{pstd}
We can also get at multiple cells
txt*/

//ex
mata:
D = A, b
D
D[2,.]
D[.,2]
D[1,(2,3)]
end
//endex

/*txt
{pstd}
We can also specify the starting cell and the ending cell, and get the entire 
submatrix between those using {cmd:[||]}

{pstd}
This can be faster
txt*/

//ex
mata:
D[|1,2 \ 1,3|]
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title logic 
/*txt
{pstd}
Like in Stata 0 is false, and non-zero (including missing) is true

{pstd}
Operators or functions that return true or false will return 0 for false and 1 
for true

{pstd}The basic operators are:{p_end}
{pmore}{cmd:==} for equals{p_end}
{pmore}{cmd:!=} for not equals{p_end}
{pmore}{cmd:>} for larger than{p_end}
{pmore}{cmd:>=} for larger than or equal{p_end}
{pmore}{cmd:<} for less than{p_end}
{pmore}{cmd:<=} for than than or equal{p_end}
{pmore}{cmd:!} for negation{p_end}
{pmore}{cmd:&} for and{p_end}
{pmore}{cmd:|} for or{p_end}
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title elementwise logic

/*txt
{pstd}
You can also use the elementwise colon operator for logic
txt*/
//ex
mata:
A:==2
end
//endex

/*txt
{pmore}
You can add the elements of a matrix with the {help mata sum():sum()} function. 
So we can count the number of 2s in the matrix {cmd:A}.
txt*/

//ex
mata:
sum(A:==2)
end
//endex

/*txt
{pstd}
Since 0 is false and non-zero is true, we can use the previous answer to test
whether 2 occurs in matrix {cmd:A}.

{pstd}
Better (quicker and less memory used) would be to use the {helpb mata all():any()} function:
txt*/

//ex
mata: any(A:==2)
//endex

/*txt
{pstd}
Even better would be to use {cmd:anyof()}
txt*/

//ex
mata: anyof(A,2)
//endex

/*txt
{pstd}
Similarly you can use {cmd:all()} and {cmd:allof()} to check if {it:all} elements are
true or equal to some value.
txt*/

//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection precision

//slide ------------------------------------------------------------------------
//title binary versus decimal

/*txt
{pstd}
There is a limit on how precise numbers are stored on computers

{pstd}
If a computer stored numbers in decimal format we would not be surprised that we
could not store the number 1/3 exactly; we would have to stop storing 3s 
otherwise we would need an infinite amount of memory to store one number.

{pstd}
A computer however stores numbers in binary format. In binary some numbers we would
not consider problematic, are actualy like 1/3. The most common example is 0.1. 

{pstd}
So a lot of numbers we think are perfectly "normal" are in a computer actually 
rounded versions of that number.
txt*/

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title how a number is stored

/*txt
{pstd}
So how are numbers stored? 

{pstd}
We could say that we store a number up to 6 digits 
after the decimal point (ignoring that they  are actually stored in binary)

{pstd}
This is problematic

{pmore}
We would store the number 1,000,000 with 13 significant digits

{pmore}
While we would store the number 0.0001 with only 3 significant digits

{pstd}
Instead a number is stored in three parts: the sign and two numbers, lets call
them a and b

{pstd}
If we would store the number in decimal format the number stored would then be
sign * a * 10^b

{pstd}
So if we decided on 6 significant digits we would store the number 1,000,000 as
+1*1.00000*10^6 and the number 0.0001 as +1*1.00000*10^-4

{pstd}
In real computers both a and b are binary numbers and we don't use 10^b, but 2^b

{pstd}
In Mata all real numbers are stored in "double precision":{p_end}
{pmore}A number is stored using 8 bytes, i.e. 64 bits{p_end}
{pmore}1 bit is used for the sign{p_end}
{pmore}11 bits are used for the exponent (b){p_end}
{pmore}The remaining 52 bits are used for the fractional part (a){p_end}
{pmore}27 of the possible configurations of bits are reserved for missing values (., .a, .b, .., .z){p_end}
{pmore}2 possible configurations of bits are reserved for 0 (+0 and -0)

txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title rounding errors: adding and subtracting

/*txt
{pstd}
This way of storing number allows us to reliably store number within a very large
range.

{pstd}
It has some quirks, for example adding numbers that differ by a large order of
magnitude can lead to quite large rounding errors.

{pstd}
We want to add 1,000,000 and 0.0001

{pmore}
Then we are adding +1*1,00000*10^6 and +1*1.00000*10^-4

{pmore}
In order to add them we would need to the exponent the same:

{pmore}
We would change +1*1.00000*10^-4 to +1*0.00000000001*10^6

{pmore}
However, we only stored 6 digits, so 0.00000000001 gets rounded to 0 

{pstd}
A common computations where this could be a problem are: 

{pmore}
Computing a sum of values in a large matrix 

{pmore}
1 - probability
txt*/

//endslide ---------------------------------------------------------------------


//..............................................................................
//subsection moving data between Stata and Mata
//slide ------------------------------------------------------------------------
//title reading data from Stata in Mata

/*txt
{pstd}
You can store parts of a Stata dataset as a matrix using {helpb mf_st_data:st_data()}.

{pstd}
In its simplest form it accepts two arguments{p_end}
{pmore}The first argument specifies the rows{p_end}
{pmore}The second argument specifies the columns{p_end}
txt*/

//ex
sysuse auto, clear

mata:
y = st_data(.,"foreign rep78")
y
end
//endex

/*txt
{pstd}
Notice that we have missing values, which we may want to ignore

{pstd}
One posibility is to set a third argument equal to 0. This will ignore all
observations with at least one missing value on one of the specified variables.
txt*/

//ex
mata: 
y = st_data(.,"foreign rep78", 0)
y
end
//endex

/*txt
{pstd}
Alternatively, that third argument can be a variable

{pstd}
non-zero values indicate that that observation is to be included, while a value 
of zero means that that observation is to be ignored

{pstd}
In programming, this is the most common way to do this
txt*/

//ex
gen byte touse = !missing(foreign, rep78)
mata:
y = st_data(.,"foreign rep78", "touse")
y
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title storing data from Mata in Stata

/*txt
{pstd}
We can store a matrix in Mata as (a) variable(s) using {helpb st_store()}

{pstd}
This will replace existing variables
txt*/

//ex
sysuse auto, clear
mata: 
x = st_data(.,"foreign")
x = x:+10
st_store(.,"foreign",x)
end
tab foreign
//endex

/*txt
{pstd}
If we want to store our matrix as a new variable, then we first have to create 
that variable with {helpb st_addvar}, and than replace its content with 
{cmd:st_store()}
txt*/

//ex
sysuse auto, clear
mata:
x = st_data(.,"foreign")
x = x :+ 10
idx = st_addvar("byte", "x")
st_store(.,idx, x)
end
tab foreign x
//endex

/*txt
{pstd}
We can control which observations gets a value by using a selection variable
txt*/

//ex
sysuse auto, clear
gen touse = !missing(foreign, rep78)
mata:
x = st_data(.,"foreign", "touse")
x = x :+ 10
idx = st_addvar("byte", "x")
st_store(.,idx, "touse", x)
end
tab foreign x, missing
tab x touse, missing
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title views and subviews

/*txt
{pstd}
If we use {cmd:st_data} to load data into Mata, we are making a copy of that 
datast meaning we use potentially a lot of memory. 

{pstd}
Alternatively, we can make a "view" of the data which directly "sees" the Stata
data rather than make a copy of it.
txt*/

//ex
sysuse auto, clear
gen byte touse = !missing(foreign, rep78, price)
mata:
Data = .
st_view(Data, ., "foreign rep78 price", "touse")
Data[1..10,.]
end
//endex

/*txt
{pstd}
Since a view directly sees the Stata data, we change that data when we change 
the view
txt*/

//ex
list foreign in 1/5
mata:
Data[1,1] = 5
end
list foreign in 1/5
//endex

/*txt
{pstd}
Often we want to get different parts of the data into Mata as different matrices

{pstd}
For example, we may want a dependent variable in a vector {cmd:y}, and the independent
variables in a matrix {cmd:X}

{pstd}
We need to make sure that all matices use the same observations

{pstd}
The best way to do that is to use a common selection variable

{pstd}
Alternatively, we can make a main view of all variables we need, and make 
subviews from that main view using {helpb mata st_subview():subview()}
txt*/

//ex
sysuse auto, clear
mata:
Data = y = X = .
st_view(Data,.,"foreign rep78 price",0)
st_subview(y,Data,.,1)
st_subview(X,Data,.,(2\.))
Data[1..5,.]
y[1..5,.]
X[1..5,.]
end
//endex 

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title reading and writing matrices and macros from Stata

/*txt
{pstd}
Stata also has matrices, and we may want to load those in Stata. We do that with
the {helpb mata st_matrix():st_matrix()} function.

{pstd}
For example, {cmd:regress} leaves the coefficients as the rowvector e(b)
txt*/
//ex
sysuse nlsw88, clear
reg wage i.union i.race i.south grade ttl_exp

mata:
b = st_matrix("e(b)")
b
end
//endex

/*txt
{pstd}
We can also use {cmd:st_matrix()} to copy matrices from Mata to Stata
txt*/

//ex
mata:
X = 1,2 \ 
    3,4
st_matrix("X",X)    
end

matlist X
//endex

/*txt
{pstd}
We can also read the content of {helpb macro:macros} and {helpb scalar:scalars}
from Stata into Mata using {helpb mata st_local():st_local()} and 
{helpb mf_st_numscalar: st_scalar()}

{pstd}
we can use the same functions to write to Stata

{pstd}
There are some /*digr*/ to consider
txt*/

//ex
tempname realnumber
local nirv "here we are now, entertain us"
mata:
st_local("nirv")
st_local("greetings", "Hello")
st_local("number", strofreal(42))
st_numscalar(st_local("realnumber"), 42)
end
di "`greetings'"
di `number'
di `realnumber'
//endex

/*txt
{pstd}
We have already seen that we can access returned matrices using {cmd:st_matrix()}

{pstd}
Returned string scalars can be accessed using {cmd:st_global()}

{pstd}
Returned numeric scalars can be accessed using {cmd:st_numscalar()}
txt*/
//ex
ereturn list

mata:
st_global("e(title)")
st_numscalar("e(N)")
end
//endex
//endslide ---------------------------------------------------------------------

//digr -------------------------------------------------------------------------
//title macros and scalars in Stata
//label arcana of macros and scalars in Stata
/*txt
{pstd}
A macro is a shorthand, it is one thing standing for another

{pstd}
It can contain anything, but is always a string
txt*/

//ex
local mac "foo"
di `mac'
//endex

/*txt
{pstd}
I said that the content of a macro is always a string, then why did this return 
an error?

{pstd}
The double quotes are there to indicate that this is a string, but they are not 
part of the string.

{pstd}
So `mac' contains {it:foo} not {it:"foo"}

{pstd}
So for the second line Stata saw {cmd:di foo}, and since there were no double 
quotes Stata assumed we wanted to look at a variable (or scalar) foo, could not
find that variable and returned the error message.

{pstd}
This will work:
txt*/

//ex
local mac "foo"
di "`mac'"
//endex

/*txt
{pstd}
Because the quotes are stripped, macros may also contain numbers.

{pstd}
They are stored as strings, but as soon as Stata replaces the name of the macro
with its content it will see them as numbers, as there are no quotes around them.
txt*/

//ex
local mac 1
di `mac'
//endex

/*txt
{pstd}
However, numbers stored in macros are not quite as precise as numbers stored in
scalars.

{pstd}
Scalars are stored in double precision (15-16 decimal digits), while locals have
about 12 decimal digits, sometimes more, but never less than 11.

{pstd}
A scalar is a "container" containing one element, either a string or a number.

{pstd}
It is good practice to use tempnames for scalars as they share the same namespace
as variables

{pstd}
{cmd:tempname} stores the names it reserves in a local macro, so we can use 
{cmd:st_local} to recover that.
txt*/

//enddigr ----------------------------------------------------------------------

//..............................................................................
//subsection Application: linear regression and instrumental variable regression
//slide ------------------------------------------------------------------------
//title linear regression: getting variables

/*txt
{pstd}
I am going to implement a linear regression in Mata in steps

{pstd}
You are going to implement a IV regression with a two stage least square 
estimator using similar steps

{pstd}
Data: nlsw88

{pstd}{cmd:y} = wage{p_end}
{pstd}{cmd:X} = grade union ttl_exp tenure south{p_end}
txt*/

//ex
sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

mata:
X=y=.
st_view(X,.,"grade union ttl_exp tenure south", "touse")
st_view(y,.,"wage", "touse")
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Try it yourself
/*txt
{pstd}
We are going to implement a IV regression via two stage least squares 

{pstd}The data is hsng2{p_end}
{pstd}The dependent variable {cmd:y} is rent{p_end}
{pstd}The endogenous variable {cmd:Y} is hsngval{p_end}
{pstd}The instruments {cmd:X2} are faminc reg2 reg3 and reg4{p_end}
{pstd}The other exogenous variables {cmd:X1} is pcturban{p_end}

{pstd}
We need to load three matrices:{p_end}
{pmore}{cmd:y}{p_end}
{pmore}{cmd:X} = {cmd:Y}, {cmd:X1}, {cmd:cons}{p_end}
{pmore}{cmd:Z} = {cmd:X1}, {cmd:X2}, {cmd:cons}{p_end}

{pstd}
Open the dataset using {cmd:webuse}, create a new variable cons containing 1, and load the 
three matrices in Mata

//apcodefile tsls01.do "(solution)"
txt*/


//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Parameter estimates
/*txt
{pstd}
The formula for the parameter estimates {cmd:b} in a linear regression is: {cmd:b} = {cmd:X}'{cmd:X}^-1{cmd:X}'{cmd:y}

{pstd}
Notice that I did not add the constant here. That is because I (mostly) don't 
need to as {helpb mata cross():cross()} will do most of the computions and allows
you to add the constant on the fly
txt*/

//ex
sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

mata:
X=y=.
st_view(X,.,"grade union ttl_exp tenure south", "touse")
st_view(y,.,"wage", "touse")
XX = cross(X,1, X,1)
Xy = cross(X,1, y,0)
b = invsym(XX)*Xy
b
end
reg wage grade union ttl_exp tenure south
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
The formulas for the parameter estimates of 2sls model are:

{pstd}{cmd:b}      = ({cmd:X}'{cmd:MX})^-1{cmd:X}'{cmd:My}{p_end}
{pstd}{cmd:M}      = {cmd:Z}({cmd:Z}'{cmd:Z})^-1{cmd:Z}'{p_end}

{pstd}
They don't lend themselves so readily for {cmd:cross}, which is why we added the 
constants

{pstd}
Continue working in your do file and compute {cmd:M} and {cmd:b}

{pstd}
Check your results agains {cmd:ivregress 2sls rent pcturban (hsngval = faminc i.region), small}

//apcodefile tsls02.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title The variance covariance matrix
 /*txt
{pstd}{cmd:Var(b)} = s2*{cmd:X}'{cmd:X}^-1{p_end}
{pstd}s2 = ess/(N-k){p_end}
{pstd}ess = ({cmd:y}-{cmd:Xb})'({cmd:y}-{cmd:Xb}){p_end}
{pstd}N = rows({cmd:X}){p_end}
{pstd}k = cols({cmd:X}) + 1   (the +1 for the constant){p_end}
 txt*/
 
//ex
sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

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
sqrt(diagonal(Var))
end
reg wage grade union ttl_exp tenure south
//endex 
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Try it yourself

/*txt
{pstd}
The formulas for the variance covariance matrix in the 2sls estimator are:

{pstd}{cmd:Var(b)} = s2*{cmd:X}'{cmd:MX}^-1{p_end}
{pstd}s2 = ess/(N-k){p_end}
{pstd}ess = ({cmd:y}-{cmd:Xb})'({cmd:y}-{cmd:Xb}){p_end}
{pstd}N = rows({cmd:X}){p_end}
{pstd}k = cols({cmd:X})    (not +1: constant is already in X){p_end}

{pstd}
Expand your do-file to create the variance covariance matrix

//apcodefile tsls03.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Export and display the results in Stata

/*txt
{pstd}
We can use {helpb ereturn} in Stata to display our results in the standard way 
Stata users expect from an estimation commands

{pstd}
We first need to export our results from Mata to Stata and than use {cmd:ereturn}
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
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Do it yourself

/*txt
{pstd}
Use the same tricks to display the results from your 2sls estimator

//apcodefile tsls04.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------
