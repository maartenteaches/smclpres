drop _all

mata:
mata clear
mata set matastrict on

class hist_gen {
    string                  scalar    fn_stopwords
	class  AssociativeArray scalar    stopwords
	string                  scalar    fn
	class  AssociativeArray scalar    hist
	string                  rowvector punct
	
    transmorphic                      fn_stopwords()
    transmorphic                      fn()
    transmorphic                      punct()
	void                              setup()
    void                              parse_stopwords()
	void                              make_hist()
	string                  rowvector parse_line()
	real                    scalar    valid_word()
	void                              count_words() 
	void                              to_stata()
}

transmorphic hist_gen::fn_stopwords(| string scalar val)
{
	if (args() == 1) {
    	fn_stopwords = val
    }
    else {
    	return(fn_stopwords)
    }
}
transmorphic hist_gen::fn(| string scalar val)
{
	if (args() == 1) {
    	fn = val
    }
    else {
    	return(fn)
    }
}
transmorphic hist_gen::punct(| string scalar val)
{
	if (args() == 1) {
    	punct = val
    }
    else {
    	return(punct)
    }
}
void hist_gen::parse_stopwords() 
{
    real scalar fh, i
    string rowvector line, EOF
    
    EOF = J(0,0,"")
    
    fh = fopen(fn_stopwords, "r")
    while ( (line=fget(fh)) != EOF ) {
        line = strlower(line)
        line = tokens(line)
        for(i=1; i <=cols(line);i++) {
            stopwords.put(line[i], 1)
        }
    }
    fclose(fh)
}

void hist_gen::setup() 
{
	parse_stopwords()
    punct = tokens(punct)    
}

void hist_gen::make_hist()
{
	setup()
    count_words()
}	

void hist_gen::count_words()
{
	string rowvector EOF, line
    real scalar fh, i, freq
    
    EOF = J(0,0,"")
    
    hist.notfound(0)
    fh = fopen(fn, "r") 
    
    while ((line=fget(fh))!=EOF) {
    	line = parse_line(line)
        for (i=1; i <= cols(line); i++) {
            if (valid_word(line[i])) {
                freq = hist.get(line[i]) + 1
                hist.put(line[i], freq)   
            }
        }
    }
    fclose(fh)
}

string rowvector hist_gen::parse_line(string scalar line)
{
	real scalar i
    
    line = strlower(line)
    for(i=1; i<= cols(punct); i++) {
		line = usubinstr(line,punct[i], "",.)
	}
    line = tokens(line)
    return(line)
}

real scalar hist_gen::valid_word(string scalar word)
{
	return(!stopwords.exists(word))
}

void hist_gen::to_stata()
{
	string colvector words
    real   colvector count, o
    real   scalar    k, i, maxl, idx
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
}
end

mata:
hist = hist_gen()
hist.fn("spd.txt")
hist.fn_stopwords("stop_words_german.txt")
hist.punct(`", . ; : ! ? ( ) [ ] > < - – * "')
hist.make_hist()
hist.to_stata()
end

sort count
list in -20/L