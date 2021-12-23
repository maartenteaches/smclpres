sysuse auto, clear
mata:
x = st_data(.,"foreign")
x = x :+ 10
idx = st_addvar("byte", "x")
st_store(.,idx, x)
end
tab foreign x
