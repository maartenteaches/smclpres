//section Advanced data types in Mata

//..............................................................................
//subsection Pointers
//slide ------------------------------------------------------------------------ 
//title What is a pointer

/*txt
{pstd}
Variables and functions are stored in memory

{pstd}
These objects have an address, so the computer is able to find these.

{pstd}
These addresses are just a number

{pstd}
This is what a {helpb [M-2] pointers:pointer} is  

{pstd} 
If we type {cmd:p = &x}, then p is a pointer, which points to x

{pstd} 
If we type {cmd:*p}, then we refer to contents of that address, or we derefernce p 
txt*/

//ex
mata:
x = 1, 2 \ 3, 4
p = &x
p
*p
(*p)[1,2]
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Passing functions to functions
/*txt
{pstd}
A common application of pointers is to pass a function to another function.

{pstd}
A pointer can point to functions as well as data
txt*/

//ex
mata:
mata clear

void greetings(string scalar who)
{
    printf("Hello " + who)
}   

p = &greetings()

(*p)("BIBB")
end
//endex

/*txt
{pstd}
We have seen an application in {cmd:moptimize}

{pstd}
We created a function {cmd:logiteval()} that computes our log likelihood, and we
needed to pass that on to {cmd:moptimize}, which we did with the line:

{pmore}
{cmd:moptimize_init_evaluator(M, &logiteval())}
txt*/

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Try it yourself: approximating a function with a linear spline

/*txt
{pstd}
We are writing a program to approximate a function with a set of linear splines

{pstd}
We need to find the knots

{pmore}
We start with a lower and upper bound

{pmore}
we look at the middle, and see if the approximation there is good enough

{pmore}
If it is not, we add a knots

{pmore}
We continue adding knots till the approximation is good enough

{pstd}
Here is a first attempt:

//codefile sp_approx01.do "sp_approx01"

{pstd}
The function we want to approximate is now hard coded in our program. We could 
make this more general with pointers

{pstd}
Do so

//apcodefile sp_approx02.do "(solution)"
txt*/

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Collecting different things under a single name

/*txt
{pstd}
You can make a matrix of pointers

{pstd}
these pointers can point to very differnt types of objects

{pstd}
We will later see more convient ways of collecting different types of objects,
but occationally using a matrix of pointers can be useful.
txt*/

//ex
mata:
mata clear
collection = J(3,1,NULL)
collection[1] = &(1,5,2,5,3)
collection[2] = &( "Hallo, meneer de Uil," \
                   "waar breng je ons naar toe?" \
                   "Naar Fabeltjesland?" \
                   "Eh, ja, naar Fabeltjesland!" \
                   "En lees je ons dan voor" \
                   "uit de Fabeltjeskrant?" \
                   "Ja, ja, uit de Fabeltjeskrant!" \
                   "Want daarin staat precies vermeld" \
                   "hoe het met de dieren is gesteld." \
                   "Echt waar? " \
                   "Echt waar!" \
                   "Echt waar, meneer de Uil?" \
                   "Want dieren zijn precies als mensen" \
                   "Met dezelfde mensen-wensen" \
                   "En dezelfde mensen-streken" \
                   "Dat staan allemaal in de krant van Fabeltjesland," \
                   "van Fabeltjesland" \
                   "De faaabeltjeskrant" )
                   
void greetings(string scalar who)
{
    printf("Hello " + who)
}                  
                   
collection[3] = &greetings()

*collection[1]
*collection[2]
(*collection[3])("world")
end

//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Using pointers to create an irregular array

/*txt
{pstd}
A special case of this would be an irregular array

{pstd}
A matrix is a regular array: each row has the same number of columns

{pstd}
An irregular array would allow each row to have a different number of columns

{pstd}
Consider the example below where we have data on the alliance structure of tribes
in the Eastern Central Highlands of New Guinea in the 1950's
txt*/


//ex
use alliance.dta, clear
notes
list in 1/10
//endex
//file alliance.dta

/*txt
{pstd}
Tribe 1 is a friend of tribe 2, but an enemy of tribe 3, etc.

{pstd}
We don't have a line in the data that says that tribe 2 is a friend of tribe 1. 
That is implicit.

{pstd}
If we were programming a network analysis where we need to repeatedly find all
the friends of tribe i, then this would be inconvenient (slow)

{pstd}
We could instead reorganize the data in an irregular array (not every tribe has
the same number of friends)
txt*/
//ex
mata:
data = st_data(.,"ego alter sign")

friends = J(16,1,&J(1,0,.))
enemies = J(16,1,&J(1,0,.))
for(i=1; i<=rows(data); i++) {
    if (data[i,3] == 1) {
        friends[data[i,1]] = &(*friends[data[i,1]], data[i,2])
        friends[data[i,2]] = &(*friends[data[i,2]], data[i,1])
    }
    else {
        enemies[data[i,1]] = &(*enemies[data[i,1]], data[i,2])
        enemies[data[i,2]] = &(*enemies[data[i,2]], data[i,1])
    }
}

*enemies[1]
*friends[1]
*enemies[16]
*friends[16]
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Try it yourself: 3D array

/*txt
{pstd}
Say we observed a matrix at three points in time.

{pstd}
Our results are:
txt*/

//ex
mata:
A1 = 2, 5, 3 \
     2, 3, 9

A2 = 4, 6, 2 \
     1, 4, 2 
      
A3 = 6, 2, 7 \
     2, 5, 1       
end     
//endex

/*txt
{pstd}
We want to store them in a single object, using pointers

{pstd}
extract from that object the value for t=2, row=2, col=3

//apcodefile threeD.do "(solution)"
txt*/

//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection associative array

//slide ------------------------------------------------------------------------
//title What is an associative array

/*txt
{pstd}
In a matrix the rows and columns are numbered, and we refer to the cells by these
row and column numbers

{pstd}
What if we could use names instead of numbers, and what if we could store anything
we want in the cells?

{pstd}
That is an {helpb mf_associativearray:associative array}
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Example: a bibliography in Mata

/*txt
{pstd}
Say we want to store a bibliography in Mata

{pmore}
Each article or book has a unique identifier, the key

{pmore}
For each key we want to store when applicable: the author(s), the year, 
the title, the journal, the pages, the publisher
txt*/

//ex
mata:
bib = AssociativeArray()
bib.reinit("string",2)

bib.put(("gould18","author"), "William W. Gould")
bib.put(("gould18","year"), 2018)
bib.put(("gould18","title"), "The Mata Book: A Book for Serious Programmers and Those Who Want to Be")
bib.put(("gould18","publisher"), "Stata Press")
bib.put(("gould18","address"), "College Station, TX")

bib.put(("buis14","author"), "Maarten L. Buis")
bib.put(("buis14","year"), 2014)
bib.put(("buis14","title"), "Stata tip 120: Certifying subroutines")
bib.put(("buis14","journal"), "The Stata Journal")
bib.put(("buis14","volume"), 14)
bib.put(("buis14","number"), 2)
bib.put(("buis14","pages"), "449-450")

bib.get(("gould18","title"))

end
//endex

/*txt
{pstd}
In the project we will do in the next section we will make extensive use of 
associative arrays
txt*/
//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection  struct

//slide ------------------------------------------------------------------------
//title What is a struct

/*txt
{pstd}
A {helpb [M-2] struct:struct} is another way of storing multiple things in a 
single object.

{pstd}
The difference is that what it contains and their names have to be declared 
beforehand.

{pstd}
This makes it quicker to store and retrieve things and there is automatic error 
checking, but is less flexible.  
txt*/

//ex
mata:
mata clear 
mata set matastrict on

struct mystruct {
    real scalar x, y
}

void main_func(real scalar x, real scalar y)
{
    struct mystruct scalar data
    
    data.x = x
    data.y = y
    
    subroutine(data)
}

real scalar subroutine(struct mystruct scalar data)
{
    return(data.x+data.y)
}

main_func(1,5)
end
//endex

/*txt
{pstd}
I use {cmd:struct}s in larger projects with many subroutines and I have a large 
amount of information to move between those routines.

txt*/

//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title Try it yourself: approximating a function with a linear spline

/*txt
{pstd}
Revisit our linear spline program. We can package lb, ub, tol, maxiter, p, and res
in a {cmd:struct} and pass those between subroutines of {cmd:find_knots()}. 

//apcodefile sp_approx03.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection  class

//slide ------------------------------------------------------------------------
//title What is a class
/*txt
{pstd}
A {helpb [M-2] class:class} is a {cmd:struct} that can also contain functions. 
These functions have access to all the data in that class. 
txt*/

//ex
mata:
mata clear 
mata set matastrict on

class myclass {
    real scalar x, y
    real scalar sum()
}


real scalar myclass::sum()
{
    return(x+y)
}
a = myclass()
a.x=3
a.y=2
a.sum()
end
//endex

/*txt
{pstd}
I use classes when I have lots of subroutines
txt*/

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title 3D array

/*txt
{pstd}
Previously we made a three dimensional array using pointers.

{pstd}
Subscripting our array is however awkward, as we subscript in two different 
places: once at the array of pointer and once inside the matrix to which the 
pointer points.

{pstd} 
If I were to use such an array in my programs, then I would write a wrapper 
around it using a class

txt*/
//ex
mata:
mata clear
mata set matastrict on

class threeD{
    private:
        pointer (real matrix) colvector data
        real                  scalar    rdim, cdim, zdim, setup
        void                            setup()
        void                            new()
        void                            isposint()
    
    public: 
        transmorphic                    rdim()
        transmorphic                    cdim()
        transmorphic                    zdim()
        void                            put()
        real matrix                     get()
}

void threeD::new()
{
    setup = 0
}

void threeD::isposint(real matrix tocheck)
{
    if (floor(tocheck)!= tocheck | any(tocheck :<= 0)) {
        _error(3300, "argument must be positive integers")
    }
}

transmorphic threeD::rdim(| real scalar val)
{
    if (args() == 1) {
        isposint(val)
        rdim = val
    }
    else {
        return(rdim)
    }
}
transmorphic threeD::cdim(| real scalar val)
{
    if (args() == 1) {
        isposint(val)
        cdim = val
    }
    else {
        return(cdim)
    }
}
transmorphic threeD::zdim(| real scalar val)
{
    if (args() == 1) {
        isposint(val)
        zdim = val
    }
    else {
        return(zdim)
    }
}
void threeD::setup()
{
    real scalar i
    
    if (setup) return
    if (rdim==. | cdim==. | zdim==.) {
        _error(30000, "rdim, cdim, and zdim need to be set first")
    }
    data = J(zdim,1,NULL)
    for(i=1; i<= zdim; i++) {
        data[i] = &J(rdim,cdim,.)
    }
    setup = 1
}
void threeD::put(real rowvector key, real matrix val)
{
    real scalar r, c, z
    real matrix toput
    
    if (!setup) setup()
    
    r = key[1]
    c = key[2]
    z = key[3]
    if ( z == . ) _error(3000, "z cannot be missing")

    toput = *data[z]
    toput[r,c] = val
    data[z] = &toput
}

real matrix threeD::get(real rowvector key)
{
    real scalar r, c, z
    real matrix toget
    
    if (!setup) return(J(0,0,.))
    
    r = key[1]
    c = key[2]
    z = key[3]
    if ( z == . ) _error(3000, "z cannot be missing")

    toget = *data[z]
    return(toget[r,c])
}

//intended use
data = threeD()
data.rdim(3)
data.cdim(2)
data.zdim(4)

A1 = 3,2 \
     3,1 \
     5,2

data.put((.,.,1), A1)
data.put((1,1,2), 2)
data.put((1,2,2), 7)

data.get((.,2,1))
data.get((1,1,2))
end
//endex

//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Try it yourself: approximating a function with a linear spline

/*txt
{pstd}
Revisit our linear spline program again. We can package the whole thing in a class. 

//apcodefile sp_approx04.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------
