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

struct sp_data {                                   //new
    real scalar lb, ub, tol, maxiter
    pointer(real scalar function) p
	real matrix sp
}

real matrix find_knots(pointer(real scalar function) p,   
                       real scalar lb, real scalar ub, 
                       real scalar tol, real scalar maxiter)
{ 
    real rowvector newknot
    real scalar i,j
    struct sp_data scalar data                      //new   

    data.lb     = lb                                //new 
    data.ub     = ub                                //new 
    data.tol    = tol                               //new
    data.maxiter= maxiter                           //new
    data.p      = p                                 //new
    
    data = init_knots(data)                          // changed

    i = 1
    j = 0
    while (i < rows(data.sp) & j < data.maxiter) {   //changed
    	j++
    	newknot = check_knot(data, i)                //changed
        if (newknot != J(1,0,.)) {
            data.sp = data.sp[|1,1 \ i, 2|] \ newknot \ data.sp[|i+1,1 \ .,2 |] //changed
        }
        else {
        	i++
        }
    }
    if (j==maxiter) {
        exit(error(430))
    }
    return(data.sp)                               //changed
}

struct sp_data scalar init_knots(struct sp_data scalar data)    //changed
{
    data.sp = J(2,2,.)
    data.sp[.,1] = data.lb \ data.ub
    data.sp[1,2] = (*data.p)(data.lb)                                  
    data.sp[2,2] = (*data.p)(data.ub)                                  
    
    return(data)
}

real rowvector check_knot(struct sp_data scalar data, real scalar i) // changed
{
	real scalar est, x, ref
    real rowvector lk, uk

    lk = data.sp[i,.]
    uk = data.sp[i+1, .]
    est = interp(lk[2], uk[2])
    x   = interp(lk[1], uk[1])
    ref = (*data.p)(x)     
    if (reldif(est,ref) > data.tol) {
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