bys industry : egen mwage = mean(wage)
replace mwage = -mwage
egen Industry = axis(mwage industry), label(industry)
scatter wage gradej, by(Industr, note("") compact) ///
    yscale(log) ylab(1.25 2.5 5 10 20 40)          ///
    name(byscatter2, replace)
