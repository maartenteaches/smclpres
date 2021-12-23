sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

mata:
X=y=.
st_view(X,.,"grade union ttl_exp tenure south", "touse")
st_view(y,.,"wage", "touse")
XX = cross(X,1, X,1)
Xy = cross(X,1, y,0)
b = invsym(XX)*Xy
b
end
reg wage grade union ttl_exp tenure south
