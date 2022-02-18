sysuse nlsw88, clear
twoway histogram wage,     ///
    width(1) freq          ///
    by(collgrad, note("")) ///
    name(hist1, replace)
