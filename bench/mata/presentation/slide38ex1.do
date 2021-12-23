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
