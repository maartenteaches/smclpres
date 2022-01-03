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

class sp_approx {                                   //new
    real scalar lb, ub, tol, maxiter
    pointer(real scalar function) p
	real matrix sp
    
    real matrix find_knots()
    void        init_knots()
    real rowvector check_knot()
    real scalar interp()
    real scalar eval_spline()
    real scalar find_x()
}


real matrix sp_approx::find_knots(pointer(real scalar function) valp,   
                       real scalar vallb, real scalar valub, 
                       real scalar valtol, real scalar valmaxiter)
{ 
    real rowvector newknot
    real scalar i,j

    lb     = vallb                                
    ub     = valub                                
    tol    = valtol                               
    maxiter= valmaxiter                           
    p      = valp                                 
    
    init_knots()                                  

    i = 1
    j = 0
    while (i < rows(sp) & j < maxiter) {   
    	j++
    	newknot = check_knot(i)                
        if (newknot != J(1,0,.)) {
            sp = sp[|1,1 \ i, 2|] \ newknot \ sp[|i+1,1 \ .,2 |] 
        }
        else {
        	i++
        }
    }
    if (j==maxiter) {
        exit(error(430))
    }
    return(sp)                               
}

void sp_approx::init_knots()    
{
    sp = J(2,2,.)
    sp[.,1] = lb \ ub
    sp[1,2] = (*p)(lb)                                  
    sp[2,2] = (*p)(ub)                                  
}

real rowvector sp_approx::check_knot(real scalar i) 
{
	real scalar est, x, ref
    real rowvector lk, uk

    lk = sp[i,.]
    uk = sp[i+1, .]
    est = interp(lk[2], uk[2])
    x   = interp(lk[1], uk[1])
    ref = (*p)(x)     
    if (reldif(est,ref) > tol) {
    	return((x,ref))
    }
    else{
    	return(J(1,0,.))
    }
}

real scalar sp_approx::interp(real scalar lv, real scalar uv) 
{
	return(lv + (uv-lv)/2)
}

real scalar sp_approx::eval_spline(real scalar x)
{
	real scalar i, frac
    
    if (x == sp[rows(sp),1]) return(sp[rows(sp),2])
	
    i = find_x(x)
    
    frac = (x - sp[i,1]) / (sp[i+1,1] - sp[i,1])
    
    return(sp[i,2] + frac* (sp[i+1,2] - sp[i,2]))
}

real scalar sp_approx::find_x(real scalar x) 
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
sp = sp_approx()
sp.find_knots(&curve(),1e-5,10,1e-3,1000)

res = J(80,3,.)
for(i=1; i<=80; i++) {
	j=i/10
    res[i,.] = (j, sp.eval_spline(j), curve(j))
}

nobs = st_nobs()
if (nobs < 80) st_addobs(80-nobs)

idx = st_addvar("double", ("x","aprox", "actual"))
st_store(.,idx, res)

end

twoway line aprox actual x