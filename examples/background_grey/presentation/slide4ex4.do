twoway scatter wage grade2, mcolor(gs10)            ///
           yscale(log) ylab(1.25 2.5 5 10 20 40) || ///
       line wagehat grade, sort legend(off)         ///
           lpattern(solid) lwidth(*3)               ///
           name(fit4, replace)
