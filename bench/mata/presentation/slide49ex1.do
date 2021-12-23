sysuse auto, clear

mata:
mata clear
mata set matastrict on

// Step 1
void logiteval(transmorphic M, real rowvector b, real colvector lnf)
{
    real colvector xb
    real colvector y
    
    xb = moptimize_util_xb(M, b, 1)
    y  = moptimize_util_depvar(M,1)
    
    lnf = y:*ln(invlogit(xb)) + (1:-y):*ln(invlogit(-xb)) 
}

// Step 2
M = moptimize_init()

// Step 3
moptimize_init_evaluator(M, &logiteval())
moptimize_init_depvar(M, 1, "foreign")
moptimize_init_eq_indepvars(M,1,"price weight") 

// Step 4
moptimize(M)

// Step 5
moptimize_result_display(M)
end

logit foreign price weight
