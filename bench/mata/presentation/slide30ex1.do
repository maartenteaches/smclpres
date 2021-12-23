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
