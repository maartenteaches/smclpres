mata:
real scalar smclpres::nbrace(string scalar str, string scalar type) 
{
	real scalar pos, n

	pos = 1 
	n   = 0
	while( (pos = ustrpos(str,type, pos) + 1) != 1 ) {
		n = n + 1
	}
	return(n)
}

string scalar smclpres::stripbraces(string scalar str) 
{
	real scalar start , finish

	if (usubstr(ustrltrim(str), 1,1) == "{" & 
	    usubstr(ustrrtrim(str),-1,1) == "}") {
		start = ustrpos(str,"{")
		finish = ustrrpos(str, "}")
		return(usubstr(str,start+1, finish-start-1))
	}
	else {
		return(str)
	}
}

string scalar smclpres::stripbrackets(string scalar str) 
{
	real scalar start , finish

	if (usubstr(ustrltrim(str), 1,1) == "[" & 
	    usubstr(ustrrtrim(str),-1,1) == "]") {
		start = ustrpos(str,"[")
		finish = ustrrpos(str, "]")
		return(usubstr(str,start+1, finish-start-1))
	}
	else {
		return(str)
	}
}

string scalar smclpres::remove_all_braces(string scalar str)
{
	str = usubinstr(str, "{", "", .)
	str = usubinstr(str, "}", "", .)
	return(str)
}

void smclpres::write_bib(struct strstate scalar state) 
{
	real scalar i
    string scalar err

    exopen(state, "bibliography")
	slideopen(state, "bibliography")
	txtopen(state, "bibliograph")
	if (state.snr != bib.bibslide) {
		err = "{p}{err}tried adding a bibliography on a non bibliography slide{p_end}"
		printf(err)
		where_err(state.rownr)
		exit(198)
	}

	for (i = 1 ; i <= rows(bib.refs) ; i++) {
		write_bib_entry(state, bib.refs[i])
		if (i < rows(bib.refs)) fput(state.dest, " ")
	}
}

void smclpres::write_bib_entry(struct strstate scalar state, string scalar key) 
{
	string scalar    type, res, entry
	string rowvector mask
	string colvector first, last
	real   scalar    i, j
	
	fput(state.dest, "{marker " + key + "}{...}")
	type = bib.bibdb.get((key,"type"))
	mask = bib.style.get(type)
	res = ""
	for (i = 1; i<=cols(mask); i++) {
		if (usubstr(mask[i],1,1) == "[") {
			entry = stripbrackets(mask[i])
			if (entry == "author") {
				first = bib.bibdb.get((key, "author_first"))
				last = bib.bibdb.get((key, "author_last"))
				if (bib.authorstyle == "first last") {
					for (j = 1; j < rows(first) ; j++) {
						res = res + first[j] + " " + last[j] 
						if (rows(first)>2) res = res + ","
						if (j < rows(first)-1) res = res + " "
					}
					if (j > 1) res = res + " " + bib.and + " "
					res = res + first[j] + " " + last[j]
				}
				else {
					for (j = 1; j < rows(first) ; j++) {
						res = res + last[j] + ", " + first[j]
						if (rows(first)>2) res = res + ";"
						if (j < rows(first)-1) res = res + " "
					}
					if (j > 1) res = res + " " + bib.and + " "
					res = res + last[j] + ", " + first[j]				
				}
			}
			else if (entry == "year") {
				res = res + bib.bibdb.get((key,"year")) + 
				            bib.bibdb.get((key,"postfix"))
			}
			else {
				res = res + bib.bibdb.get((key,entry))
			}
		}
		else{
			res = res + mask[i]
		}
	}
	fput(state.dest, res)
}
end