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
