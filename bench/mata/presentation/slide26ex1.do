sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

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
sqrt(diagonal(Var))
end
reg wage grade union ttl_exp tenure south
