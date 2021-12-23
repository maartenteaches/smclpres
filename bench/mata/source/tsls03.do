webuse hsng2, clear

gen byte cons = 1

gen byte touse = !missing(rent, pcturban, faminc, reg2, reg3, reg4, hsngval)

mata:
y = X = Z = .
st_view(y,.,"rent", "touse")
st_view(X,.,"hsngval pcturban cons", "touse")
st_view(Z,.,"pcturban faminc reg2 reg3 reg4 cons", "touse")

ZZi = invsym(cross(Z, Z))
M= Z*ZZi*Z'
b = invsym(X'*M*X)*X'*M*y

k = cols(X) 
N = rows(X)
res = y - X*b
ess = quadcross(res,res)
s2 = ess/(N-k)
Var = s2*invsym(X'*M*X)
sqrt(diagonal(Var))
end

ivregress 2sls rent pcturban (hsngval = faminc i.region), small
