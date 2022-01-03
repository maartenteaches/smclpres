webuse hsng2, clear

gen byte cons = 1

gen byte touse = !missing(rent, pcturban, faminc, reg2, reg3, reg4, hsngval)

mata:
y = X = Z = .
st_view(y,.,"rent", "touse")
st_view(X,.,"hsngval pcturban cons", "touse")
st_view(Z,.,"pcturban faminc reg2 reg3 reg4 cons", "touse")
end