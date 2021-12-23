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
