sysuse auto, clear
gen touse = !missing(foreign, rep78)
mata:
x = st_data(.,"foreign", "touse")
x = x :+ 10
idx = st_addvar("byte", "x")
st_store(.,idx, "touse", x)
end
tab foreign x, missing
tab x touse, missing
