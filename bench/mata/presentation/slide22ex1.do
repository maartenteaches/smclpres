sysuse nlsw88, clear
gen byte touse = !missing(wage, grade, union, ttl_exp, tenure, south)

mata:
X=y=.
st_view(X,.,"grade union ttl_exp tenure south", "touse")
st_view(y,.,"wage", "touse")
end
