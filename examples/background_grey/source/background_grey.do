// This .do-file is intended to be compiled into a smcl presentation using:
// smclpres using background_grey.do, 
// =============================================================================

//version 4.0.0
//layout toc        link(subsection) title(subsection)
//layout topbar     on 
//layout bottombar  arrow 
//layout title      center

/*toctitle 
Graphics in Stata
Graphs in the background
toctitle*/

/*toctxt

{center:Maarten Buis}
{center:office F532}
{center:maarten.buis@uni.kn}
{center:office hours by appointment}
toctxt*/

//section histograms and bar graphs
//subsection highlighting a sub-population in a histogram

//slide ------------------------------------------------------------------------
//title Highlighting sub-populations in a histogram

/*txt
{pstd}We can compare distributions using {cmd:histogram} with the {cmd:by()} 
option.{p_end}
txt*/

//ex 
sysuse nlsw88, clear
twoway histogram wage,     ///
    width(1) freq          ///
    by(collgrad, note("")) ///
    name(hist1, replace)
//endex
//graph hist1

/*txt
{pstd}We can also highlight the part of the histogram that are college 
graduates /*cite cox09 */{p_end}
txt*/

//ex
twoway histogram wage,                       ///
    width(1) freq                            ///
    bcolor(gs14)  blw(*.4) blcolor(black) || /// 
histogram wage if collgrad,                  ///
    width(1) freq legend(off)                ///
    bcolor(gs6) blw(*.4) blcolor(black)      ///
    title(distribution of hourly wage)       ///
    subtitle(college graduates highlighted)  ///
    name(hist2, replace) 
//endex
//graph hist2
//endslide ---------------------------------------------------------------------

//subsection highlighting a bar

//slide ------------------------------------------------------------------------
//title Highlighting bars
//label highlighting bars

/*txt
{pstd}We can {cmd:graph hbar} to display the mean wage by industry.{p_end}
txt*/

//ex
sysuse nlsw88, clear
graph hbar (mean) wage,                       ///
    over(industry, descending sort(1))        ///
    name(bar1, replace)        
//endex
//graph bar1
/*txt

{pstd}Sometimes we want to highlight one bar.{p_end}

{pstd}This is particularly common for presentations.{p_end}
txt*/

//ex
collapse (mean) wage, by(industry)
separate wage, by(industry == 12)
graph hbar (asis) wage0 wage1,                   ///
    over(industry, descending sort(wage)) nofill ///
    bar(1, bfcolor(none)) legend(off)            ///
    ytitle(mean wage)                            ///
    name(bar2, replace)
//endex
//graph bar2
//endslide ---------------------------------------------------------------------

//section scatterplots
//subsection highlighting a sub-population

//slide ------------------------------------------------------------------------
//title Highlighting sub-populations in a scatter plot
//label highlighting in a scatter plot

/*txt
{pstd}We may want to highlight a certain sub-polation in a scatter plot{p_end}

{pstd}We start with a simple scatter plot{p_end}
txt*/

//ex
sysuse nlsw88, clear
graph drop _all
scatter wage grade,         ///
    name(scatter1, replace)
//endex
//graph scatter1

/*txt
{pstd}Grade is discrete, but we can show the individual values by adding the 
jitter() option.{p_end}
txt*/

//ex
scatter wage grade, jitter(2) ///
    name(scatter2, replace)
//endex
//graph scatter2

/*txt
{pstd}The jitter() option adds random noise in both the x and y direction, but 
we only need a jitter in the x-direction{p_end}
txt*/

//ex
gen grade2 = grade + .5*runiform()
scatter wage grade2,           ///
    name(scatter3, replace)
//endex
//graph scatter3

/*txt
{pstd}It would be nice if we could copy the variable label from grade{p_end}
txt*/

//ex
label var grade2 "`: var label grade'"
scatter wage grade2,            ///
    name(scatter4, replace)
//endex
//graph scatter4

/*txt
{pstd}It makes more sense to display wage on a log scal{p_end}
txt*/

//ex
scatter wage grade2, yscale(log) ///
    name(scatter5, replace)
//endex
//graph scatter5

/*txt
{pstd}But we need to adjust the axis labels a bit.{p_end}
txt*/

//ex
scatter wage grade2, yscale(log) ///
    ylab(1.25 2.5 5 10 20 40)    ///
    name(scatter6, replace)
//endex
//graph scatter6

/*txt
{pstd}Now we can highlight the blacks{p_end}
txt*/

//ex
scatter wage grade2, yscale(log)       ///
    msymbol(Oh) mcolor(gs10) ||        ///
scatter wage grade2 if race == 2 ,     ///
    msymbol(O) mcolor(gs2)             ///
    yscale(log) legend(off)            ///
    ylab(1.25 2.5 5 10 20 40)          ///                
    name(scatter7, replace)
//endex
//graph scatter7
//endslide ---------------------------------------------------------------------

//subsection line on top of a scatter plot

//slide ------------------------------------------------------------------------
//title Line on top of a scatter plot
//label background scatter

/*txt
{pstd}We can plot a line on top of a scatter plot{p_end}
txt*/

//ex
graph drop _all
sysuse nlsw88, clear

gen grade2 = grade + .5*runiform()
label var grade2 "`: var label grade'"

fp <grade> , scale: poisson wage <grade>
predict wagehat
twoway scatter wage grade2,                         ///
           yscale(log) ylab(1.25 2.5 5 10 20 40) || ///
       line wagehat grade, sort legend(off)         ///
            name(fit1, replace)
//endex
//graph fit1

/*txt
{pstd}The scatter plot is a bit too dominant{p_end}
txt*/

//ex
twoway scatter wage grade2, mcolor(gs10)            ///
           yscale(log) ylab(1.25 2.5 5 10 20 40) || ///
       line wagehat grade, sort legend(off)         ///
            name(fit2, replace)
//endex
//graph fit2

/*txt
{pstd}The line can be made solid{p_end}
txt*/

//ex
twoway scatter wage grade2, mcolor(gs10)            ///
           yscale(log) ylab(1.25 2.5 5 10 20 40) || ///
       line wagehat grade, sort legend(off)         ///
           lpattern(solid)                          ///
           name(fit3, replace)
//endex
//graph fit3

/*txt
{pstd}We can also make the line thicker{p_end}
txt*/

//ex
twoway scatter wage grade2, mcolor(gs10)            ///
           yscale(log) ylab(1.25 2.5 5 10 20 40) || ///
       line wagehat grade, sort legend(off)         ///
           lpattern(solid) lwidth(*3)               ///
           name(fit4, replace)
//endex
//graph fit4
//endslide 

//subsection by

//slide ------------------------------------------------------------------------
//title By graph
//label by graph

/*txt
{pstd}Lets look at the relationship between wage and education by industry{p_end}
txt*/

//ex
graph drop _all
sysuse nlsw88, clear
gen gradej = grade + .5*runiform()
label var gradej "`: var label grade'"

scatter wage gradej, by(industr, note("") compact) ///
    yscale(log) ylab(1.25 2.5 5 10 20 40)          ///
    name(byscatter1, replace)
//endex
//graph byscatter1

/*txt
{pstd}We can sort the sub graphs by mean wage{p_end}
txt*/

//ex
bys industry : egen mwage = mean(wage)
replace mwage = -mwage
egen Industry = axis(mwage industry), label(industry)
scatter wage gradej, by(Industr, note("") compact) ///
    yscale(log) ylab(1.25 2.5 5 10 20 40)          ///
    name(byscatter2, replace)
//endex
//graph byscatter2

/*txt
{pstd}We can display the entire sample as a background graph{p_end}
txt*/

//ex
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
//endex
//graph byscatter3
//endslide ---------------------------------------------------------------------

//section line plots
//subsection spagetti plots

//slide ------------------------------------------------------------------------
//title Line graph
//label line graph

/*txt
{pstd}Lets look at a spagetti plot{p_end}
txt*/

//ex
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
//endex
//graph spagetti1

/*txt
{pstd}Maybe this becomes more informative if we plot these lines by industry 
with all the lines as a grey background /*cite cox10 */{p_end}
txt*/

//ex
bys Industry : gen id = _n
fillin Industry id
tempfile temp
save `temp'
forvalues i = 1/12 {
	bys id (wage`i') : replace wage`i' = wage`i'[1]
    by id : gen grade`i' = grade[1]
}
keep if Industry == 1
keep id grade? grade?? wage? wage??
merge 1:m id using `temp'

local gr ""
forvalues i = 1/12 {
	local gr `gr' line wage`i' grade`i' , ///
        lpattern(solid) lcolor(gs12) sort ||
}

twoway `gr'                                           ///
       line wagehat grade ,                           ///
           by(Industry, legend(off) compact note("")) ///
           sort yscale(log) ylab(2.5 5 10 20)         ///
           lpattern(solid) lcolor(black) lwidth(*3)   ///      
           xtitle(grade) ytitle(predicted wage)       ///
           name(spagetti2, replace)
//endex
//graph spagetti2
/*txt
{pstd}We can also display a "rug" underneat to show the number of observations 
on which these lines are based /*cite cox04 */.{p_end}
txt*/

//ex
gen pipe = "|"
gen y = 1.8
gen gradej = grade + .5*runiform()
local gr ""
forvalues i = 1/12 {
	local gr `gr' line wage`i' grade`i' , ///
        lpattern(solid) lcolor(gs12) sort ||
}

twoway `gr'                                           ///
       line wagehat grade ,                           ///
           by(Industry, legend(off) compact note("")) ///
           sort yscale(log) ylab(2.5 5 10 20)         ///
           lpattern(solid) lcolor(black) lwidth(*3)   ///      
           xtitle(grade) ytitle(predicted wage) ||    ///
       scatter y gradej,                              ///
           mlabel(pipe) mlabpos(0) mlabsize(vsmall)   ///
           msymbol(i) name(spagetti3, replace)
//endex
//graph spagetti3
//endslide ---------------------------------------------------------------------

//bib --------------------------------------------------------------------------
//title Bibliography

/*bib
@article{cox04,
    author  =  {Nicholas J. Cox},
    title   = {Speaking Stata: Graphing distributions},
    journal = {The Stata Journal},
    year    = {2004},
    volume  = {4},
    number  = {1},
    pages   = {66-88}
}

@article{cox09,
    author  = {Nicholas J. Cox},
    title   = {Stata tip 78: Going gray gracefully: Highlighting subsets and downplaying substrates},
    journal = {The Stata Journal},
    year    = {2009},
    volume  = {9},
    number  = {3},
    pages   = {499-503}
}

@article{cox10,
    author  = {Nicholas J. Cox},
    title   = {Speaking Stata: Graphing subsets},
    journal = {The Stata Journal},
    year    = {2010},
    volume  = {20},
    number  = {4},
    pages   = {670-681} 
}

bib*/
//endbib -----------------------------------------------------------------------
