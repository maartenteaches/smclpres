sysuse nlsw88, clear
graph drop _all
scatter wage grade,         ///
    name(scatter1, replace)
