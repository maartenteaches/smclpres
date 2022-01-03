*! version 1.0.0 MLB 06Oct2021
program define my_poisson, eclass
    version 16
    syntax varlist(fv ts) [if] [in] [fweight pweight iweight/] 
    
    if "`weight'" != "" local wgt [`weight' = `exp']
    marksample touse
    
    _rmcoll `varlist' if `touse' `wgt', expand
    local varlist `r(varlist)'
    gettoken y x : varlist
    _fv_check_depvar `y'
    
    local k : word count `x'
    local k = `k' + 1
    Startval `y' if `touse' `wgt', k(`k') `constant'
    
    mata poissonwork("`y'", "`x'")
end

program Startval, rclass
    syntax varname [if] [fweight pweight iweight/] , k(integer) 
    
    if "`weight'" != "" local wgt [`weight' = `exp']
    if "`weight'" == "pweight" local wgt [aweight = `exp']
    
    tempname b0
    matrix `b0' = J(1, `k', 0)
    
    marksample touse
    sum `varlist' if `touse' `wgt', meanonly
    matrix `b0'[1,`k'] = ln(r(mean))
    return matrix b0 = `b0'
end

mata:
mata set matastrict on

void poissoneval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*xb - exp(xb) - lnfactorial(y)
}

void poissonwork(string scalar depvar, string scalar indepvars)
{
    transmorphic M
    M = moptimize_init()
    moptimize_init_evaluatortype(M, "lf")
    moptimize_init_evaluator(M, &poissoneval())
    moptimize_init_touse(M, st_local("touse"))
    moptimize_init_ndepvars(M,1)
    moptimize_init_depvar(M, 1, depvar)
    moptimize_init_eq_indepvars(M,1,indepvars)
    if (st_local("weight") != "") {
     	moptimize_init_weighttype(M, st_local("weight"))
        moptimize_init_weight(M, st_local("exp"))
    }    
    moptimize_init_valueid(M, "log likelihood") 
    moptimize_init_eq_coefs(M,1,st_matrix("r(b0)"))
    moptimize_init_search(M, "off")    
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}
end
