use homogamy_allbus
mata
muhat:/data1940
st_matrix("weights", muhat:/data1940)
end
gen weight = weights[meduc,feduc] if inrange(byr,1940,1945)
tab meduc feduc if inrange(byr, 1940, 1945) [iweight=weight]
