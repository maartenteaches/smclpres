sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

tempname b V

mata:
X=y=.
st_view(X,.,"grade union ttl_exp tenure south", "touse")
st_view(y,.,"wage", "touse")
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
end

local xnames `""grade" "union" "ttl_exp" "tenure" "south" "_cons""'
matrix colnames `b' = `xnames'
matrix colnames `V' = `xnames'
matrix rownames `V' = `xnames'
ereturn post `b' `V', dof(`df_r') obs(`N') esample(touse)
ereturn display

reg wage grade union ttl_exp tenure south
