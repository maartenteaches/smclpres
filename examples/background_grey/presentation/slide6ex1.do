graph drop _all
sysuse nlsw88, clear
gen ed2 = grade + 1

bys industry : egen mwage = mean(wage)
replace mwage = -mwage
egen Industry = axis(mwage industry), label(industry)

gen wagehat = .
forvalues i = 1/12 {
    fp <ed2>, replace : poisson wage <ed2> if industry == `i'
    predict wage`i' if e(sample)
    replace wagehat = wage`i' if industry == `i'
    local gr `gr' line wage`i' grade , sort ||
}
sort industry grade
twoway line wagehat grade, connect(L) name(spagetti1, replace)
