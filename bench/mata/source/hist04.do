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

words[|k-20 \ k|]
count[|k-20 \ k|]

end