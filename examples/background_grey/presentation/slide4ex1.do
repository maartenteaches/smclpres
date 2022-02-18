graph drop _all
sysuse nlsw88, clear

gen grade2 = grade + .5*runiform()
label var grade2 "`: var label grade'"

fp <grade> , scale: poisson wage <grade>
predict wagehat
twoway scatter wage grade2,                         ///
           yscale(log) ylab(1.25 2.5 5 10 20 40) || ///
       line wagehat grade, sort legend(off)         ///
            name(fit1, replace)
