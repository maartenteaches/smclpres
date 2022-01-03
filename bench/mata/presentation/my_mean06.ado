*! version 1.0.0 MLB 06Oct2021
program define my_mean06, rclass
    version 16
    syntax varlist(numeric)
    tempname res
    mata:my_mean("`varlist'")
    matrix colnames `res' = `varlist'
    matrix rownames `res' = "mean"
    matlist `res'
    return matrix mean = `res'
end

mata:
mata set matastrict on

void my_mean(string scalar varn)
{
    real scalar k, i
    real rowvector mean
    real colvector x
    
    varn = tokens(varn)
    k = cols(varn)
    mean = J(1,k,.)
    for (i=1; i<=k; i++) {
        x = st_data(.,varn[i],0)
        mean[i] = sum(x)/rows(x)
    }
    st_matrix(st_local("res"),mean)
}

end
