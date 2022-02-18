graph drop _all
sysuse nlsw88, clear
gen gradej = grade + .5*runiform()
label var gradej "`: var label grade'"

scatter wage gradej, by(industr, note("") compact) ///
    yscale(log) ylab(1.25 2.5 5 10 20 40)          ///
    name(byscatter1, replace)
