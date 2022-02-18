gen pipe = "|"
gen y = 1.8
gen gradej = grade + .5*runiform()
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
           xtitle(grade) ytitle(predicted wage) ||    ///
       scatter y gradej,                              ///
           mlabel(pipe) mlabpos(0) mlabsize(vsmall)   ///
           msymbol(i) name(spagetti3, replace)
