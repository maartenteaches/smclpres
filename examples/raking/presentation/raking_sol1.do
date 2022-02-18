use place.dta, clear
tab place15 place30, matcell(data)
mata
data = st_matrix("data")
muhat = data
muhat2 = 0:*data
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
	muhat2 = muhat
	muhat = muhat:/rowsum(muhat):*100
	muhat = muhat:/colsum(muhat):*100
	printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
	i = i + 1
}
muhat
data
end
stdtable place15 place30
