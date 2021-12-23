sysuse auto, clear
mata: 
x = st_data(.,"foreign")
x = x:+10
st_store(.,"foreign",x)
end
tab foreign
