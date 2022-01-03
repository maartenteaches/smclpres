webuse hsng2, clear

gen byte cons = 1

gen byte touse = !missing(rent, pcturban, faminc, reg2, reg3, reg4, hsngval)

tempname b V

mata:
mata clear
mata set matastrict on

void my_2sls(string scalar depvar, string scalar exog, string scalar endog,
             string scalar instrum, string scalar cons, string scalar select)
{
	transmorphic y, X, Z
    string scalar Xnames, Znames
    real matrix ZZi, M, Var
    real colvector b, res
    real scalar k, N, ess, s2
    
    y = X = Z = .
    Xnames = endog + " " +  exog + " " + cons
    Znames = exog + " " + instrum + " " + cons
    st_view(y,.,depvar, select)
    st_view(X,.,Xnames, select)
    st_view(Z,.,Znames, select)

    ZZi = invsym(cross(Z, Z))
    M= Z*ZZi*Z'
    b = invsym(X'*M*X)*X'*M*y

    k = cols(X) 
    N = rows(X)
    res = y - X*b
    ess = quadcross(res,res)
    s2 = ess/(N-k)
    Var = s2*invsym(X'*M*X)

    st_matrix(st_local("b"),b')
    st_matrix(st_local("V"),Var)
    st_local("df_r",strofreal(N-k))
    st_local("N", strofreal(N))
}
end


mata: my_2sls("rent", "pcturban", "hsngval", "faminc reg2 reg3 reg4", "cons", "touse")
local xnames `""pcturban" "faminc" "_cons""'
matrix colnames `b' = `xnames'
matrix colnames `V' = `xnames'
matrix rownames `V' = `xnames'
ereturn post `b' `V', dof(`df_r') obs(`N') esample(touse)
ereturn display

ivregress 2sls rent pcturban (hsngval = faminc i.region), small
