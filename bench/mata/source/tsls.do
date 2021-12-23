/*
y      = rent
x1     = pcturban            (other exogenous vars)
x2     = faminc i.region     (instruments)
Y      = hsngval             (to be instrumented)

X      = Y, X1, cons
Z      = X1, X2, cons

b      = (X'MX)^-1X'My
M      = Z(Z'Z)^-1Z'
ess    = (y-X*b)'*(y-X*b)
s2     = ess/(n-k)
k      = cols(X)  (not +1: constant is already in X)
N      = rows(X)
var(b) = s2(X'MX)^-1
*/

clear all
webuse hsng2

gen byte cons = 1

tempname b V

gen byte touse = !missing(rent, pcturban, faminc, reg2, reg3, reg4, hsngval)

mata:
st_view((data=.),.,("rent", "pcturban", "faminc", "reg2", "reg3", "reg4", "hsngval", "cons"),"touse")
st_subview((y=.),data,.,1)
st_subview((X=.),data,.,(7,2,8))
st_subview((Z=.),data,.,(2..6,8))

k = cols(X) 
N = rows(X)
ZZi = invsym(quadcross(Z, Z))
M= (Z)*ZZi*(Z)'
b = invsym(X'*M*X)*X'*M*y

res = y - X*b
ess = quadcross(res,res)
s2 = ess/(N-k)
Var = s2*invsym(X'*M*X)

st_matrix(st_local("b"),b')
st_matrix(st_local("V"),Var)
st_local("df_r",strofreal(N-k))
st_local("N", strofreal(N))
end

local xnames `""pcturban" "faminc" "_cons""'
matrix colnames `b' = `xnames'
matrix colnames `V' = `xnames'
matrix rownames `V' = `xnames'
ereturn post `b' `V', dof(`df_r') obs(`N') esample(touse)
ereturn display


ivregress 2sls rent pcturban (hsngval = faminc i.region), small

