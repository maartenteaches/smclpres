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
