twoway scatter wage grade2, mcolor(gs10)            ///
           yscale(log) ylab(1.25 2.5 5 10 20 40) || ///
       line wagehat grade, sort legend(off)         ///
           lpattern(solid)                          ///
           name(fit3, replace)
