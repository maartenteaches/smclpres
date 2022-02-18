use homogamy_allbus, clear
tab meduc feduc if inrange(byr,1940,1945), matcell(data1940)
use margins1940, clear
list
