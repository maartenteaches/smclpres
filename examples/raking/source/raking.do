// This .do-file is intended to be compiled into a smcl presentation using:
// smclpres using raking.do
// -----------------------------------------------------------------------------

//version 4.0.0
//layout toc title(subsection) link(subsection) secbold 
//layout toc subsubsecitalic 
//layout tocfiles on customname(sol solutions to "Try it yourself") p2(5 26 27 0)
//layout bottombar toc arrow
//layout bib authorstyle(last first)

//titlepage --------------------------------------------------------------------
/*txt




{center:{bf:Log-linear models}}
{center:{bf:Lecture 2: raking}}

{center:Maarten Buis}
{center:office F532}
{center:maarten.buis@uni.kn}
{center:office hours by appointment}
txt*/

//endtitlepage -----------------------------------------------------------------

//toctitle Table of content

//section Standardizing a table

//subsection The goal

//slide ------------------------------------------------------------------------
//title Standardize the table for homogamy
//tocfile data homogamy_allbus.dta ALLBUS 1980 - 2016
//file homogamy_allbus.dta

/*txt
{pstd}Consider the table of the education of the male and female partners in a
marriage or stable partnership. {p_end}
txt*/

//ex initial look at the homogamy data
clear
use homogamy_allbus.dta
tab meduc feduc, matcell(data)
//endex

/*txt
{pstd}It is hard to interpret this table as is, because of the differences in 
the margins.{p_end}

{pstd}For example, it appears that a {bf:female with medium vocational education} 
marying a {bf:male with lower vocational education} is more common than 
{it:vice versa}.{p_end}

{pstd}This is contrary to the notion that partnerships where the men are better 
educated are more common. {p_end}

{pstd}But the observed pattern may be due to the fact that 
{bf:lower vocational education} is more common among men than women, and 
{bf:medium vocational education} is more common among women than men.{p_end}

{pstd}Can't we change the table such that the pattern of association remains 
constant, but all the margins are the same, e.g. 100?{p_end}

{pstd}That would make it easier to see patterns.{p_end}

{pstd}Last week we solved this problem by looking at how independence was defined
in a chi-square test:{p_end}

{pstd}We imagined what the table would look like if the margins remained as we 
observed them, but there is no other association between the row and column 
variable{p_end}

{pstd}This week we turn this around: We keep the association in the table as 
observed, but change the margins. /*cite yule12 agresti02 { p. 345-346}*/{p_end}
txt*/
//endslide ---------------------------------------------------------------------

//subsection First try

//slide ------------------------------------------------------------------------
//title Making all the row totals 100
/*txt
{pstd}Notice, that I added the option {cmd:matcell(data)} to the {cmd:tab} 
command. This leaves behind the table as a Stata matrix named data, which in turn
can be read into Mata{p_end}
txt*/

//ex load the data in Mata
mata
data = st_matrix("data")
data
end
//endex

/*txt
{pstd}If we divide all cell entries by the rowsum, then the new rowsum will be 1.{p_end}

{pstd}Multiply the new cell entries by a 100, and the rowsum will be a 100.{p_end}
txt*/

//ex adjust the rows to sum to 100
mata
muhat = data

muhat = muhat:/rowsum(muhat):*100
muhat
rowsum(muhat)
colsum(muhat)
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Making all the colum totals 100

/*txt
{pstd}The row totals are as we want them, but the column totals are not. What
if we repeat this process for the columns?{p_end}
txt*/

//ex adjust the columns to sum to 100
mata
muhat = muhat:/colsum(muhat):*100
muhat
rowsum(muhat)
colsum(muhat)
end
//endex

/*txt
{pstd}Now the column totals are as we want them, but now the row totals are a
bit off.{p_end}

{pstd}However, the row totals are better than in the original table, so maybe
we need to repeat this process a couple of times?{p_end}
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Repeat
//ex repeat adjusting rows and colums
mata
muhat = muhat:/rowsum(muhat):*100
muhat
rowsum(muhat)
colsum(muhat)

muhat = muhat:/colsum(muhat):*100
muhat
rowsum(muhat)
colsum(muhat)
end
//endex
/*txt
{pstd}Notice that each time we get a bit closer to our goal{p_end}
txt*/
//endslide ---------------------------------------------------------------------

//subsection Iterative Proportional Fitting

//slide ------------------------------------------------------------------------
//title Iterative Proportional Fitting

/*txt
{pstd}The algorithm is called Iterative Proportional Fitting (IPF) /*cite kruithof37 deming_stephan40*/{p_end}

{pstd}We can automate this repeating using a loop, and in particular we want to
continue the loop until the table does not change anymore.{p_end}
txt*/

//ex write that up in a loop
mata
muhat = data
muhat2 = 0:*data
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
	muhat2 = muhat
	muhat = muhat:/rowsum(muhat):*100
	muhat = muhat:/colsum(muhat):*100
	printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
	i = i + 1
}
muhat
data
end
//endex

/*txt
{pstd}In the raw data the odds of men with lower voc marying a women with lower 
vocational instead of low is 4.6 times the odds of men with low education 
marying a women with lower vocational:{p_end}
txt*/
//ex odds ratio in raw data
di (7665 / 3864 ) / (600 / 1378 )
//endex

/*txt
{pstd}In our new table we get the exact same odds ratio:{p_end}
txt*/

//ex odds ratio in adjusted data
di (47.28612524 / 27.29231899) / (21.01486714 / 55.2594258)
//endex

/*txt
{pstd}Standardizing a table like this is nice in a teaching setting, because 
you can see what is going on. In a real analysis you use the /*digr*/ package{p_end}
txt*/
//endslide ---------------------------------------------------------------------

//digr -------------------------------------------------------------------------
//title stdtable
//label stdtable

/*txt
This method has been implemented in Stata as the {help stdtable} command.
txt*/

//ex do this standardization with stdtable
stdtable meduc feduc
//endex

//enddigr ----------------------------------------------------------------------

//anc --------------------------------------------------------------------------
//title Can all tables be standardized?

/*txt
{pstd}Consider the following table{p_end}

        0 0 2
        1 5 2
        8 7 0
	
{pstd}In order to make the first row total 100, the top right cell {it:must} be 
100{p_end}	

{pstd}In order to make the last column total 100, the top right cell {it:cannot} 
be 100{p_end}

{pstd}This is an example of a table that cannot be standardized. The Mata program
we created above will stop after 30 iterations, but the condition 
{cmd:mreldif(muhat2,muhat)>1e-8} will not be met. In other words the algorithm 
has not converged. The {cmd:stdtable} command will give a more explicit warning 
when that happens.
txt*/
//endanc -----------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Try it yourself
//tocfile data place.dta German Live History Study I
//file place.dta

/*txt
{pstd}Use IPF to standardize the place of residence table ({cmd:place.dta}) to 
have margins of all 100.{p_end}

//apcodefile raking_sol1.do Solution

txt*/
//tocfile sol raking_sol1.do sollution
//endslide ---------------------------------------------------------------------


//section Standardization to compare tables

//slide ------------------------------------------------------------------------
//title comparing tables

/*txt
{pstd}Say we want to compare the tables for the cohorts born in 1940-1945 (i.e.
were 20 in 1960-1965) and born in 1960-1965 (i.e. were 20 in 1980-1985).{p_end}

{pstd}What if we standardize the table from 1940-1945 to have the margins of the
table from 1960-1965?{p_end}

{pstd}This way we can easier compare across cohorts, and still have margins that
are more realistic than all 100s.{p_end}

{pstd}We start with preparing the data and loading it into Mata{p_end}
txt*/

//ex load data by cohort in Mata
use homogamy_allbus.dta, clear
gen coh = cond(inrange(byr, 1960, 1965), 1, ///
          cond(inrange(byr, 1940, 1945), 0, .))
label define coh 0 "1940-1945" 1 "1960-1965"
label value coh coh
label var coh "resp. birth cohort"
tab meduc feduc if coh==0, matcell(data1940)
tab meduc feduc if coh==1, matcell(data1960)
mata
data1940 = st_matrix("data1940")
data1960 = st_matrix("data1960")
end
//endex

/*txt
{pstd}We extract the desired row and column totals{p_end}
txt*/

//ex store the desired margins
mata
col = colsum(data1960)
row = rowsum(data1960)
end
//endex

/*txt
{pstd}We can now apply these row and column totals instead of 100.{p_end}

{pstd}We can see that a large part of the apparent difference between the 
cohorts is due to the change in distribution of education between the cohorts.{p_end}
txt*/

//ex standardize the 1940 table to 1960 margins
mata
muhat = data1940
muhat2 = 0:*data1940
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
	muhat2 = muhat
	muhat = muhat:/rowsum(muhat):*row
	muhat = muhat:/colsum(muhat):*col
	printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
	i = i + 1
}
data1940
muhat
data1960
end
//endex

/*txt
{pstd}Alternatively, we can use {cmd:stdtable}{p_end}
txt*/

//ex do this with stdtable
stdtable meduc feduc, by(coh,baseline(1))
//endex
//endslide ---------------------------------------------------------------------



//slide ------------------------------------------------------------------------
//title Try it yourself

/*txt
{pstd}Standardize the tables in {cmd:place.dta} such that the margins for all 
cohorts correspond to the margins of the 1950 cohort.{p_end}


//apcodefile raking_sol2.do Solution
txt*/
//tocfile sol raking_sol2.do sollution

//endslide ---------------------------------------------------------------------

//section keep the margins as observed, but change the pattern
//slide ------------------------------------------------------------------------
//title Independence revisited

/*txt
{pstd}We have until now keept the patern as observed in the data, and changed 
the margins. Can we not turn that around: Keep the margins as observed in the 
data, and change the pattern?{p_end}

{pstd}An interesting baseline pattern would be independence. We would start with
a table that satisfies independence, and change the values such that the margins
correspond to the observed margins. A table that satisfies independence is a 
table with all 1s.{p_end}
txt*/

//ex use IPF to find the counts under independence
mata:
row = rowsum(data)
col = colsum(data)
muhat = J(5,5,1)
muhat2 = 0:*muhat
muhat
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
	muhat2 = muhat
	muhat = muhat:/rowsum(muhat):*row
	muhat = muhat:/colsum(muhat):*col
	printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
	i = i + 1
}
muhat
end
tab meduc feduc , exp nofreq
//endex

/*txt
{pstd}Notice that the second iteration added nothing, so the IPF converged in 
one iteration. Also, the estimated counts correspond to the counts we computed 
last week.{p_end}

{pstd}This is not a coincidence:{p_end}

{pmore}In the first step of the first iteration, each cell gets 1/5 rowtotal{p_end}

{pmore}At the begining of the second step of the first iteration, the collumn 
totals are 1/5th of N{p_end}

{pmore}So we get: (rowtotal/5)/(N/5)*coltotal = (rowtotal*coltotal)/N {p_end}
txt*/

//endslide ---------------------------------------------------------------------

//section Standardization to known margins in the population

//slide ------------------------------------------------------------------------
//title Margins in our sample and margins in the population

/*txt
{pstd}Samples often deviate from the population because of{p_end}
{phang2}The way the sample was drawn{p_end}
{phang2}the way the data was collected{p_end}
{phang2}some people are harder to contact{p_end}
{phang2}some people are less likely to participate{p_end}

{pstd}What if we had the marginal distriubtion of our variables from the 
population?{p_end}

{pstd}Can't we use the same trick to standardize our table to those population
margins?{p_end}

{pstd}This is a classic application of raking, and is often used when computing
(post-stratification) weights.{p_end}

txt*/
//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title Computing post-stratification weights for the cohort 1940-1945
//tocfile data margins1940.dta Volks- und Berufszählung 1970 and 1987
//file margins1940.dta

/*txt
{pstd}Lets get the observed data again and take a look at the population 
margins{p_end}
txt*/

//ex load data and census margins in Stata
use homogamy_allbus, clear
tab meduc feduc if inrange(byr,1940,1945), matcell(data1940)
use margins1940, clear
list
//endex

/*txt
{pstd}Lets get the data and the desired margins in Mata and compare them with 
the observed margins.{p_end}

{pstd}Notice the {cmd:'} at the end of the line starting with {cmd:col}. This 
turns the columnvector {cmd:col} into a rowvector.{p_end}
txt*/

//ex load data and census margins in Mata
mata
data1940 = st_matrix("data1940")
row = st_data((1,5),3)
col = st_data((6,10),3)'
n = sum(data1940)
row = row:*n
col = col:*n
row
rowsum(data1940)
col
colsum(data1940)
end
//endex

/*txt
{pstd}Now we can apply the same trick as before.{p_end}
txt*/

//ex adjust table to fit census margins
mata
muhat = data1940
muhat2 = 0:*data1940
i = 1
while(i<30 & mreldif(muhat2,muhat)>1e-8) {
	muhat2 = muhat
	muhat = muhat:/rowsum(muhat):*row
	muhat = muhat:/colsum(muhat):*col
	printf("{txt}iteration {res}%f {txt}relative change {res}%f\n", i, mreldif(muhat2,muhat))
	i = i + 1
}
data1940
muhat
end
//endex

/*txt
{pstd}So if the margins in our data corresponded with the margins in the 
population then we would expect to find 475 couples with both low education, but
in our data we only found 146 such couples.{p_end}

{pstd}So a single couple with both low education in our data stands for 
475/146=3.3 observations in the table with the population margins.{p_end}

{pstd}This 3.3 is our post-stratification weight{p_end}
txt*/

//ex use these adjusted counts to create weights
use homogamy_allbus
mata
muhat:/data1940
st_matrix("weights", muhat:/data1940)
end
gen weight = weights[meduc,feduc] if inrange(byr,1940,1945)
tab meduc feduc if inrange(byr, 1940, 1945) [iweight=weight]
//endex
//endslide ---------------------------------------------------------------------

//bib --------------------------------------------------------------------------
//title Bibliography

/*bib
@Article{yule12,
  author    = {G. Udny Yule},
  title     = {On the Methods of Measuring Association Between Two Attributes},
  journal   = {Journal of the Royal Statistical Society},
  year      = {1912},
  volume    = {75},
  number    = {6},
  pages     = {579-652},
}
@Article{kruithof37,
  author    = {Kruithof, J.},
  title     = {Telefoonverkeersrekening},
  journal   = {De Ingenieur},
  year      = {1937},
  volume    = {52},
  number    = {8},
  pages     = {E15-E25},
}
@book{agresti02,
  author    = {Alan Agresti},
  title     = {Categorical Data Analysis, 2nd edition},
  year      = {2002},
  address   = {Hoboken, NJ},
  publisher = {Wiley},
}
@article{deming_stephan40,
  author    = {W. Edwards Deming and Frederick F. Stephan},
  journal   = {The Annals of Mathematical Statistics},
  year      = {1940},
  volume    = {11},
  number    = {4},
  pages     = {427--444},
  title     = {On a Least Squares Adjustment of a Sampled Frequency Table When the Expected Marginal Totals are Known},
}
bib*/

//endbib -----------------------------------------------------------------------

