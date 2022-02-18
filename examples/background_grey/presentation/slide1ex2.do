twoway histogram wage,                       ///
    width(1) freq                            ///
    bcolor(gs14)  blw(*.4) blcolor(black) || /// 
histogram wage if collgrad,                  ///
    width(1) freq legend(off)                ///
    bcolor(gs6) blw(*.4) blcolor(black)      ///
    title(distribution of hourly wage)       ///
    subtitle(college graduates highlighted)  ///
    name(hist2, replace) 
