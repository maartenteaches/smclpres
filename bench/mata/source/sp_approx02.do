mata:
mata clear
mata set matastrict on

// the function we want to apprximate
real scalar curve(real scalar mu)
{
	real colvector y, lnL
	y = 0 \ 5 \ 2 \ 2 \ 4 \ 8 \ 1
    lnL = y:*ln(mu) :- mu :- lnfactorial(y)
	return(sum(lnL))
}

// the approximation
real matrix find_knots(pointer(real scalar function) p,   // new
                       real scalar lb, real scalar ub, 
                       real scalar tol, real scalar maxiter)
{
	real matrix res 
    real rowvector newknot
    real scalar i,j
    
    res = init_knots(p, lb, ub)                          // changed
    
    i = 1
    j= 0
    while (i < rows(res) & j < maxiter) {
    	j++
    	newknot = check_knot(p, res[i,.], res[i+1,.], tol)  //changed
        if (newknot != J(1,0,.)) {
            res = res[|1,1 \ i, 2|] \ newknot \ res[|i+1,1 \ .,2 |]
        }
        else {
        	i++
        }
    }
    if (j==maxiter) {
        exit(error(430))
    }
    return(res)
}

real matrix init_knots(pointer(real scalar function) p,  //new
                       real scalar lb, real scalar ub)
{
	real matrix res
    
    res = J(2,2,.)
    res[.,1] = lb \ ub
    res[1,2] = (*p)(lb)                                  //new
    res[2,2] = (*p)(ub)                                  //new  
    
    return(res)
}

real rowvector check_knot(pointer(real scalar function) p,  //new
                          rowvector lk, rowvector uk, real scalar tol)
{
	real scalar est, x, ref

    est = interp(lk[2], uk[2])
    x   = interp(lk[1], uk[1])
    ref = (*p)(x)                                        //new
    if (reldif(est,ref) > tol) {
    	return((x,ref))
    }
    else{
    	return(J(1,0,.))
    }
}

real scalar interp(real scalar lv, real scalar uv) 
{
	return(lv + (uv-lv)/2)
}

real scalar eval_spline(real matrix sp, real scalar x)
{
	real scalar i, frac
    
    if (x == sp[rows(sp),1]) return(sp[rows(sp),2])
	
    i = find_x(sp,x)
    
    frac = (x - sp[i,1]) / (sp[i+1,1] - sp[i,1])
    
    return(sp[i,2] + frac* (sp[i+1,2] - sp[i,2]))
}

real scalar find_x(real matrix sp, real scalar x) 
{
	real scalar i
    
    for(i=1; i <= rows(sp); i++) {
    	if (sp[i,1] >= x) break
    }
    
    if (i == rows(sp)) {
    	printf("x is out of range of sp")
    	exit(198)
    }
    
    return(i)
    
}
end
// example use
drop _all
mata:
sp = find_knots(&curve(),1e-5,10,1e-3,1000)

res = J(80,3,.)
for(i=1; i<=80; i++) {
	j=i/10
    res[i,.] = (j, eval_spline(sp,j), curve(j))
}

nobs = st_nobs()
if (nobs < 80) st_addobs(80-nobs)

idx = st_addvar("double", ("x","aprox", "actual"))
st_store(.,idx, res)

end

twoway line aprox actual x