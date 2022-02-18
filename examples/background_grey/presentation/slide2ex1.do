sysuse nlsw88, clear
graph hbar (mean) wage,                       ///
    over(industry, descending sort(1))        ///
    name(bar1, replace)        
