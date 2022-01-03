drop _all

mata:
mata clear
mata set matastrict on

stopwords = AssociativeArray()
fhs = fopen("stop_words_german.txt", "r")
while ((line=fget(fhs))!=J(0,0,"")) {
    line = strlower(line)
	line = tokens(line)
	for(i=1; i <=cols(line);i++) {
	    stopwords.put(line[i], 1)
	}
}
fclose(fhs)
	
hist = AssociativeArray()
hist.notfound(0)
fh = fopen("spd.txt", "r")
punct = `", . ; : ! ? ( ) [ ] > < - – * "'
punct = tokens(punct)

while ((line=fget(fh))!=J(0,0,"")) {
    line = strlower(line)
    for(i=1; i<= cols(punct); i++) {
		line = usubinstr(line,punct[i], "",.)
	}
    line = tokens(line)
    for (i=1; i <= cols(line); i++) {
	    if (!stopwords.exists(line[i])) {
			freq = hist.get(line[i]) + 1
			hist.put(line[i], freq)   
		}
    }
}
fclose(fh)

words = hist.keys()
k = rows(words)
count = J(k,1,.)
for(i=1; i<=k; i++) {
    count[i] = hist.get(words[i])
}

o = order(count,1)
count = count[o,.]
words = words[o,.]

if (st_nobs() < k) {
    st_addobs(k-st_nobs())
}
maxl = max(strlen(words))
idx = st_addvar(maxl, "word")
st_sstore(.,idx, words)
idx = st_addvar("long","count")
st_store(., idx ,count)
end

// most common words
list in -20/L

//average length of words
gen len = ustrlen(word)
sum len [fw=count]

// a "Gini plot" for words
gen rel = count / r(N)
replace rel = sum(rel)
gen ref = _n/_N

twoway line rel ref, aspect(1) || ///
       function reference = x