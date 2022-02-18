bys Industry : gen id = _n
fillin Industry id
tempfile temp
save `temp'
forvalues i = 1/12 {
    bys id (wage`i') : replace wage`i' = wage`i'[1]
    by id : gen grade`i' = grade[1]
}
keep if Industry == 1
keep id grade? grade?? wage? wage??
merge 1:m id using `temp'

local gr ""
forvalues i = 1/12 {
    local gr `gr' line wage`i' grade`i' , ///
        lpattern(solid) lcolor(gs12) sort ||
}

twoway `gr'                                           ///
       line wagehat grade ,                           ///
           by(Industry, legend(off) compact note("")) ///
           sort yscale(log) ylab(2.5 5 10 20)         ///
           lpattern(solid) lcolor(black) lwidth(*3)   ///      
           xtitle(grade) ytitle(predicted wage)       ///
           name(spagetti2, replace)
