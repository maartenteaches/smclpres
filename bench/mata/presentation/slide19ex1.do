sysuse auto, clear
gen byte touse = !missing(foreign, rep78, price)
mata:
Data = .
st_view(Data, ., "foreign rep78 price", "touse")
Data[1..10,.]
end
