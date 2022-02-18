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
