/*
y = wage
X = grade union ttl_exp tenure south

b = X'X^-1X'y
ess = (y-Xb)'(y-Xb)
s2 = ess/(N-k)
N = rows(X)
k = cols(X) + 1   (the +1 for the constant)
Var(b) = s2*X'X^-1
*/

sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

tempname b V

mata:
data = X = y = .
st_view(data,., "wage grade union ttl_exp tenure south", "touse")
st_subview(y,data,.,1)
st_subview(X,data,.,(2\.))
XX = quadcross(X,1, X,1)
Xy = quadcross(X,1, y, 0)
b = invsym(XX)*Xy

N = rows(X)
k = cols(X) + 1
cons = J(N,1,1)
res = y - (X,cons)*b
ess = quadcross(res,res)
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