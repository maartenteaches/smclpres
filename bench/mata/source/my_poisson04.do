use horse, clear
program drop _all

program Startval, rclass
    syntax varname [if], k(integer) 
    
    tempname b0
    matrix `b0' = J(1, `k', 0)
    
    marksample touse
    sum `varlist' if `touse', meanonly
    matrix `b0'[1,`k'] = ln(r(mean))
    return matrix b0 = `b0'
end

program define my_poisson, eclass
    version 16
    syntax varlist(fv ts) [if] [in]
    
    marksample touse
    
    _rmcoll `varlist' if `touse', expand
    local varlist `r(varlist)'
    gettoken y x : varlist
    _fv_check_depvar `y'
    
    local k : word count `x'
    local k = `k' + 1
    Startval `y' if `touse', k(`k') `constant'
    
    mata poissonwork("`y'", "`x'")
end


mata:
mata clear
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
    moptimize_init_valueid(M, "log likelihood") 
    moptimize_init_eq_coefs(M,1,st_matrix("r(b0)"))
    moptimize_init_search(M, "off")    
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}
end


my_poisson deaths i.unit
poisson deaths i.unit 