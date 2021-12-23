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
