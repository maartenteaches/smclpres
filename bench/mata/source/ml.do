clear all

/*
svy
different types of standard errors cluster
display
by
*/


program define mylogit, eclass
    version 16
    syntax varlist(ts fv) [if] [in]  [fweight pweight iweight/] , [noCONStant Constraints(passthru) vce(passthru) Robust CLuster(passthru)]

    marksample touse
    
    _rmcoll `varlist' if `touse', `constant' expand logit touse(`touse')
    local x `r(varlist)'
    gettoken y x : x
    _fv_check_depvar `y' 
    local k : word count `x'
    local k = `k' + ("`constant'" == "")
    

    local vceopt =  `:length local vce'             |       ///
                    `:length local weight'          |       ///
                    `:length local cluster'         |       ///
                    `:length local robust'
    if `vceopt' {
            if "`weight'" != "" local wgt [`weight'=`exp']
            _vce_parse, argopt(CLuster) opt(OIM OPG Robust) old     ///
                    : `wgt', `vce' `robust' `cluster'
            local vce
            if "`r(cluster)'" != "" {
                    local clustvar `r(cluster)'
                    local vce vce(cluster `r(cluster)')
            }
            else if "`r(robust)'" != "" {
                    local vce vce(robust)
            }
            else if "`r(vce)'" != "" {
                    local vce vce(`r(vce)')
            }
    }
    
    
    MkCns, x(`x') k(`k') `constraints' `constant'

    startval `y' if `touse', k(`k') `constant'
    
    mata: logitest()
end

program define startval, rclass
    syntax varname [if], k(integer) [noCONStant]
    
    if "`constant'" != "" exit
    
    tempname b0
    matrix `b0' = J(1, `k', 0)
    
    marksample touse
    sum `varlist' if `touse', meanonly
    matrix `b0'[1,`k'] = ln(r(mean)/(1-r(mean)))
    return matrix b0 = `b0'

end

program define MkCns, eclass
    syntax, x(string) k(integer) [Constraints(string) noCONStant]
    
    if "`constraints'" == "" {
        exit
    }

    if "`constant'" == "" {
        local x = "`x' _cons"	
    }
    
    tempname b V 
        
    matrix `b' = J(1,`k',0)
    matrix colnames `b' = `x'
    matrix `V' = `b''*`b'
    matrix colnames `V' = `x'
    matrix rownames `V' = `x'
    ereturn post `b' `V'
    
    matrix makeCns `constraints' 
end

mata:
void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
} 


void logitest()
{
    M = moptimize_init()
    moptimize_init_touse(M, st_local("touse"))
    moptimize_init_evaluator(M, &logiteval())
    moptimize_init_evaluatortype(M, "lf")
    moptimize_init_ndepvars(M,1)
    moptimize_init_depvar(M, 1, st_local("y"))
    moptimize_init_eq_indepvars(M,1,st_local("x"))
    if (st_local("constraints") != "") {
        moptimize_init_constraints(M, st_matrix("e(Cns)"))
    }
    if (st_local("constant")=="") {
    	moptimize_init_eq_coefs(M,1,st_matrix("r(b0)"))
        moptimize_init_search(M, "off")
    }
    else {
    	moptimize_init_eq_cons(M, 1, "off")
    }
    if (st_local("weight") != "") {
     	moptimize_init_weighttype(M, st_local("weight"))
        moptimize_init_weight(M, st_local("exp"))
    }
    moptimize_init_valueid(M, "log likelihood")
    moptimize(M)
    moptimize_result_display(M)
    moptimize_result_post(M)
}
end


sysuse nlsw88
mylogit union south grade,
