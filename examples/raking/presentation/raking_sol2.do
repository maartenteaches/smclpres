use place.dta, clear
tab place15 place30 if coh==30, matcell(data30)
tab place15 place30 if coh==40, matcell(data40)
tab place15 place30 if coh==50, matcell(data50)
mata
data30 = st_matrix("data30")
data40 = st_matrix("data40")
data50 = st_matrix("data50")
row = rowsum(data50)
col = colsum(data50)
muhat = data30
muhat2 = 0:*data
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
	muhat2 = muhat
	muhat = muhat:/rowsum(muhat):*row
	muhat = muhat:/colsum(muhat):*col
	printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
	i = i + 1
}
muhat30 = muhat
muhat = data40
muhat2 = 0:*data
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
	muhat2 = muhat
	muhat = muhat:/rowsum(muhat):*row
	muhat = muhat:/colsum(muhat):*col
	printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
	i = i + 1
}
muhat40 = muhat
muhat30
muhat40
data50
end
stdtable place15 place30, by(coh,baseline(50))
