sysuse auto, clear
mata:
Data = y = X = .
st_view(Data,.,"foreign rep78 price",0)
st_subview(y,Data,.,1)
st_subview(X,Data,.,(2\.))
Data[1..5,.]
y[1..5,.]
X[1..5,.]
end
