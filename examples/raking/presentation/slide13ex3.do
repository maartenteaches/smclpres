mata
muhat = data1940
muhat2 = 0:*data1940
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
    muhat2 = muhat
    muhat = muhat:/rowsum(muhat):*row
    muhat = muhat:/colsum(muhat):*col
    printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
    i = i + 1
}
data1940
muhat
end
