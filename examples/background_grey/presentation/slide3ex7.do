scatter wage grade2, yscale(log)       ///
    msymbol(Oh) mcolor(gs10) ||        ///
scatter wage grade2 if race == 2 ,     ///
    msymbol(O) mcolor(gs2)             ///
    yscale(log) legend(off)            ///
    ylab(1.25 2.5 5 10 20 40)          ///                
    name(scatter7, replace)
