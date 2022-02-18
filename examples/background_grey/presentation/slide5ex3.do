sysuse nlsw88, clear
keep if !missing(industry, wage, grade)
bys industry : gen id = _n
fillin industry id

gen gradej = grade + .5*runiform()
label var gradej "`: var label grade'"

bys industry : egen mwage = mean(wage)
replace mwage = -mwage
egen Industry = axis(mwage industry), label(industry)

tempfile temp
save `temp'

keep wage industry gradej id
reshape wide wage gradej, j(industry) i(id)
merge 1:m id using `temp'

forvalues i = 1/12 {
    local backgr `backgr' scatter wage`i' gradej`i', ///
                          msymbol(Oh) mcolor(gs12) ||
}

twoway `backgr'                        ///
       scatter wage gradej,            ///
           msymbol(O) mcolor(black)    ///
           by(Industry, legend(off)    ///
              compact note(""))        ///
           ytitle(wage) xtitle(grade)  ///
           yscale(log)                 ///
           ylab(1.25 2.5 5 10 20 40)   ///
           name(byscatter3, replace)
