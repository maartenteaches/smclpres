use horse, clear
tab unit, gen(unit)
unab varl : unit2-unit14 // I am lazy 

mata:
mata clear
mata set matastrict on

// Step 1
void poissoneval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*xb - exp(xb) - lnfactorial(y)
}

// Step 2
M = moptimize_init()

// Step 3
moptimize_init_evaluator(M, &poissoneval())
moptimize_init_depvar(M, 1, "deaths")
moptimize_init_eq_indepvars(M,1,st_local("varl")) 

// Step 4
moptimize(M)

// Step 5
moptimize_result_display(M)
end

poisson deaths i.unit