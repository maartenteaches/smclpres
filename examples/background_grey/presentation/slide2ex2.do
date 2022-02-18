collapse (mean) wage, by(industry)
separate wage, by(industry == 12)
graph hbar (asis) wage0 wage1,                   ///
    over(industry, descending sort(wage)) nofill ///
    bar(1, bfcolor(none)) legend(off)            ///
    ytitle(mean wage)                            ///
    name(bar2, replace)
