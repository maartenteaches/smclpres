sysuse auto, clear
program drop _all

mata:
mata clear
mata set matastrict on

void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
}

void logitwork(string scalar depvar, string scalar indepvars)
{
    transmorphic M
    M = moptimize_init()
    moptimize_init_evaluatortype(M, "lf")
    moptimize_init_evaluator(M, &logiteval())
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

program define my_logit, eclass
    version 16
    syntax varlist(fv ts) [if] [in]
    
    marksample touse
    
    _rmcoll `varlist' if `touse' , expand ///
        logit touse(`touse')       // options specific to logit (detect perfect predictions)
    
    local varlist `r(varlist)'
    gettoken y x : varlist
    _fv_check_depvar `y'
    
    mata logitwork("`y'", "`x'")
end

sum price
gen byte expensive = price > r(mean) if price < .

my_logit foreign i.expensive weight
logit foreign i.expensive weight 

