use horse, clear
tab unit, gen(unit)

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
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}
end

program define my_poisson, eclass
    version 16
    syntax varlist [if] [in]
    
    marksample touse
    
    _rmcoll `varlist' if `touse'
    local varlist `r(varlist)'
    gettoken y x : varlist

    mata poissonwork("`y'", "`x'")
end

my_poisson deaths unit2-unit14
poisson deaths i.unit 