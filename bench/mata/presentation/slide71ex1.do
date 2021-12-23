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
