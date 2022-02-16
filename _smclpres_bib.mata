mata:
void smclpres::read_bib() {
	real       scalar    i
	string     colvector entries

	entries = collect_entries()
	for(i=1; i<=rows(entries); i++) {
		parse_entry(entries[i])
	}
	
	parse_authors()
}

string colvector smclpres::collect_entries()
{
	real          scalar in_entry, fh, openbraces, closebraces
	string        scalar line, entry
	string     colvector res

	res = J(0,1,"")
	in_entry = 0
	fh = sp_fopen( bib.bibfile, "r") 

	while ( (line = fget(fh)) != J(0,0,"") ) {
		line = remove_tab(line) 
		line = ustrltrim(line)
		if ( in_entry == 0 & usubstr(ustrltrim(line),1,1) == "@") {
			in_entry = 1
			openbraces = 0
			closebraces = 0
			entry = ""
		}
		if (in_entry == 1) {
			openbraces = openbraces + nbrace(line, "{")
			closebraces = closebraces + nbrace(line, "}")
			entry = entry + line
			if (openbraces - closebraces == 0) {
				in_entry = 0
				res = res \ entry
			}
		}
	}
	sp_fclose(fh)	
	return(res)
}

void smclpres::parse_entry(string scalar entry) 
{

	string       scalar key, type, content, token
	real         scalar k
	transmorphic scalar t
	
	t = tokeninit(" "+char(9), (","),  ("{}"))
	tokenset(t, entry)
	type = tokenget(t)
	type = strlower(tokens(type, "@")[2])
	tokenset(t,stripbraces(tokenget(t)))
	key = tokenget(t)
	bib.keys = bib.keys \ key
	bib.bibdb.put((key,"type"),type)
	while ((token= tokenget(t)) != "") {
		if (token == "," ) {
			k = -1
			if (key != "" & content != "" )  {
				if (type == "author") {
					content = stripbraces(content)
				}
				else {
					content = remove_all_braces(content)
				}
				bib.bibdb.put((key,type), content)
			}
		}
		k = k +1
		if (k == 1) {
			type = token
		}
		if (k == 2) {
			if (token != "=") {
				printf("{err}a problem occured with bibliography entry {res}"+ type )
				error(198)
			}
		}
		if (k == 3) {
			content = token
		}
		if (k >= 4) {
			content = content + " " +  token
		}
	}
	if (key != "" & content != "" )  {
		if (type == "author") {
			content = stripbraces(content)
		}
		else {
			content = remove_all_braces(content)
		}
		bib.bibdb.put((key,type), content)
	}
}
void smclpres::parse_authors()
{
	real   scalar    i
	string rowvector key
	string matrix    parsed
	
	for(i = 1 ; i <= rows(bib.keys); i++) {
		key = bib.keys[i]
		parsed = parse_author(key)
		key = (key,"author_first")
		bib.bibdb.put(key, parsed[.,1])
		key[2] = "author_last"
		bib.bibdb.put(key, parsed[.,2])
	}
}

string matrix smclpres::parse_author(string scalar key)
{
	real   scalar    i
	string colvector unparsed
	string matrix    parsed
	
	parsed = J(0,2,"")
	
	unparsed = bib.bibdb.get((key,"author"))
	if (unparsed != "") {	
		unparsed = split_on_and(unparsed)
		
		for (i = 1 ; i <= rows(unparsed) ; i++)  {
			parsed = parsed \ parse_name(unparsed[i])
		}
	}
	return(parsed)	
}
string colvector smclpres::split_on_and(string scalar str)
{
	string       colvector res
	string       scalar    temp, token
	transmorphic scalar    t
	
	res = J(0,1, "")
	temp = ""
	
	t = tokeninit(" ", "", "{}")	
	tokenset(t, str)
	
	while ((token= tokenget(t)) != "") {
		if (token == "and" & temp != "") {
			res = res \ temp
			temp = ""
		}
		else {
			temp = temp + " " + token
		}
	}
	res = res \ temp
	res = ustrtrim(res)
	return(res)
}

string rowvector smclpres::parse_name(string scalar str) 
{
	string       scalar    first, last
	string       rowvector temp
	real         scalar    i, hascomma
	transmorphic scalar    t
	
	first = ""
	last = ""
	hascomma = 0
	
	t = tokeninit(" ", ",", "{}")
	tokenset(t, str)
	temp = tokengetall(t)

	for (i=1 ; i <= cols(temp); i++) {
		if (temp[i] == ",") {
			last = first
			first = ""
			hascomma = 1
		}
		else {
			if (hascomma == 1) {
				first = first + " " + temp[i]
			}
		}
		if (hascomma == 0) {
			if (i == cols(temp)) {
				last = temp[i]
			}
			else {
				first = first + " " + temp[i]
			}
		}
	}
	last = stripbraces(last)
	return((ustrtrim(first), ustrtrim(last)))
	
}

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

string scalar smclpres::write_single_ref(string scalar key)
{
	string matrix authors
	string scalar res
	real   scalar i
	
	authors = bib.bibdb.get((key,"author_last"))

	res = ""
	for (i = 1 ; i < rows(authors); i++) {
		if (i > 1 & rows(authors) > 2) res = res + ", "
		res = res + authors[i]
	}
	if (i > 2) res = res + ","
	if (i > 1) res = res + " " + bib.and + " "
	res = res + authors[i] 
	res = res + " " + bib.bibdb.get((key,"year")) +  
	      bib.bibdb.get((key,"postfix")) 
	return(res)
}

string scalar smclpres::write_ref(string scalar str)
{
	transmorphic scalar t
	string       scalar token, res, ref
	real         scalar nrefs, ncomment
	
	nrefs = 0
	ncomment = 0
	res = ""
	t = tokeninit(" ", "", "{}" )
	tokenset(t, str)
	while ( (token = tokenget(t)) != "") {
        if ( usubstr(token,1,1) != "{" ) {
			nrefs = nrefs + 1
			if (nrefs > 1 & ncomment < 2) res = res + "; "
			ncomment = 0
			ref = write_single_ref(token) 
			ref = "{view slide" + strofreal(bib.bibslide) + ".smcl##" + token + ":" + ref + "}"
			res = res + ref

		}
		else  {
			ncomment = ncomment + 1
			if (nrefs >= 1 & ncomment == 2) res = res + "; "
			res = res + stripbraces(token)
		}
    }
	res = "(" + res + ")"
	return(res)
}

struct strstate scalar smclpres::ref_replace(struct strstate scalar state) {
	real   scalar    st, fi
	string scalar    rawref, ref
	
	st = 0

	while( (st = ustrpos(state.line, "/*cite", st) + 1 ) != 1) {
		fi = ustrpos(state.line, "*/", st)
		rawref = usubstr(state.line,st+6, fi-st-6)
		ref = write_ref(rawref)
		state.line = usubstr(state.line,1, st-2) + ref + usubstr(state.line,fi+2,.)
	}
	
	return(state)
}

void smclpres::write_bib(struct strstate scalar state) 
{
	real scalar i
    string scalar err

    exopen(state, "bibliography")
	noslideopen(state, "bibliography")
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

void smclpres::collect_bib()
{
	real   scalar    dest, bibopen, bibslide
	real   scalar    txtopen, rownr, exopen
	string scalar    err
	string rowvector tline
	
	bibopen  = 0
	bibslide = 0
	txtopen  = 0
	exopen   = 0
	
	dest   = sp_fopen(bib.bibfile, "w")
	
	for (rownr = 1 ; rownr <= rows_source; rownr++){
		tline = tokens(source[rownr,1])
		if (cols(tline) > 0) {
			if (tline[1] == "/*txt") txtopen = 1
			if (tline[1] == "//txt") txtopen = 1
			if (tline[1] == "txt*/") txtopen = 0
			if (tline[1] == "//ex")  exopen  = 1
			if (tline[1] == "//endex") exopen = 0
			if (tline[1] == "bib*/") {
				if (bibopen == 0) {
					err = "{err}tried to close a bibliography while none was open"
					printf(err)
					where_err(rownr)
					exit(198)
				}
				bibopen = 0
			}
			if (tline[1] == "/*bib") {
				if (bibopen ==  1) {
					err = "{err}tried to open bibliography while one was already open"
					printf(err)
					where_err(rownr)
					exit(198)
				}
				if (bibslide == 0) {
					err = "{err}tried to open a bibliography while not on a bibliography slide"
					printf(err)
					where_err(rownr)
					exit(198)
				}
				if (txtopen == 1) {
					err = "{err}tried to open a bibliography while a textblock was open"
					printf(err)
					where_err(rownr)
					exit(198)
				}
				if (exopen == 1) {
					err = "{err}tried to open a bibliography while an example was open"
					printf(err)
					where_err(rownr)
					exit(198)
				}				
				bibopen = 1
			}
			else if (bibopen == 1) {
				fput(dest, source[rownr,1])
			}
			if (tline[1] == "//bib") {
				bibslide = 1
			}
			if (tline[1] == "//endbib")  { 
				bibslide = 0
				if (bibopen == 1) {
					err = "{p}{err}tried to close the bibliography slide while a " +
						  "bibliography was still open{p_end}"
					printf(err)
					where_err(rownr)
					exit(198)
				}
			}
		}
	}
	sp_fclose(dest)
}

void smclpres::set_style()
{
	if (bib.stylefile == "") {
		base_style()
	}
	else {
		import_style()
	}
}

void smclpres::base_style()
{
	string rowvector style 
	
    style = ("{p 4 8 2}", "[author]", " (", "[year]", "), {it:", "[title]", "}.  ", 
    "[address]", ": ", "[publisher]", ".{p_end}")
    bib.style.put( "book", style)
     
    style = ("{p 4 8  2}", "[author]", " (", "[year]", `"), ""', "[title]", `"", {it:"', 
    "[journal]", "}, {bf:", "[volume]", "}(", "[number]", "), pp. ", "[pages]", 
    ".{p_end}")
    bib.style.put( "article", style)
    
      style = ("{p 4 8 2}", "[author]", " (", "[year]", `"), ""', "[title]", `"". In {it:"', 
    "[booktitle]", "}, edited by ", "[editor]", ", pp. ", "[pages]", ". ", 
    "[address]", ": ", "[publisher]", ".{p_end}")
    bib.style.put( "incollection", style)
    
      style = ("{p 4 8 2}", "[author]", " (", "[year]", "), {it:", "[title]", "}. ", 
    "[school]", ".{p_end}")
    bib.style.put( "phdthesis", style)
    
      style = ("{p 4 8 2}", "[author]", " (", "[year]", "), {it:", "[title]", "}. ", 
    "[note]", ".{p_end}")
    bib.style.put( "unpublished", style)
}

void smclpres::import_style()
{
	real   scalar in_entry, fh, openbraces, closebraces
	string scalar entry, line
	
	in_entry = 0
	fh = sp_fopen(bib.stylefile, "r")
	
	while ((line = fget(fh)) != J(0,0,"") ) {
		if ( in_entry == 0 & usubstr(ustrltrim(line),1,1) == "@") {
			in_entry = 1
			openbraces = 0
			closebraces = 0
			entry = ""
		}
		if (in_entry == 1) {
			openbraces = openbraces + nbrace(line, "{")
			closebraces = closebraces + nbrace(line, "}")
			entry = entry + line
			if (openbraces - closebraces == 0) {
				in_entry = 0
				parse_style_entry( entry )
			}
		}		
	}
	sp_fclose(fh)
}

void smclpres::parse_style_entry(string scalar entry)
{
	real         scalar    st, fi 
	string       scalar    type
	string       rowvector res
	transmorphic scalar    t
	
	st = ustrpos(entry, "@") + 1
	fi = ustrpos(entry, "{")
	type = usubstr(entry, st , fi - st)

	entry = ustrtrim(stripbraces(usubstr(entry, fi, .)))
	t = tokeninit("", (""),  ("[]"))
	tokenset(t, entry)
	res = tokengetall(t)
	bib.style.put( type, res)
}

void smclpres::collect_refs()
{
	real   scalar    rownr, txtopen, i
	string rowvector tline
	string colvector refs

	txtopen  = 0

	for(rownr=1; rownr <= rows_source; rownr++) {
		tline = tokens(source[rownr,1])
		if (cols(tline) > 0) {
			if (tline[1] == "/*txt") txtopen = 1
			if (tline[1] == "//txt") txtopen = 1
			if (tline[1] == "txt*/") txtopen = 0
			if (txtopen == 1 & bib.write == "cited") {
				if (anyof(tline, "/*cite")) {
					refs = extract_refs(rownr)
					for(i = 1 ; i <= rows(refs); i++) {
						bib.refs = bib.refs \ refs[i]					
					}
				}
			}
			if (tline[1] == "//txt") txtopen = 0
		}
	}
	
	if (bib.write == "all") {
		bib.refs = bib.bibdb.keys()
	}
	fix_collisions()
}

string colvector smclpres::extract_refs(real scalar rownr)
{
	string       colvector rawrefs, res
	string       scalar    token
	real         scalar    i
	transmorphic scalar    t
	
	res = J(0,1, "")
	t = tokeninit(" ", "", "{}" )
	rawrefs = extract_rawrefs(rownr)
	for (i = 1 ; i <= rows(rawrefs) ; i++) {
		tokenset(t, rawrefs[i])
		while ( (token = tokenget(t)) != "") {
            if ( usubstr(token,1,1) != "{" & !anyof((bib.refs \ res),token)) {
				key_not_found(token,rownr)
				res = res \ token
			}
        }
	}
	return(res)
}

void smclpres::key_not_found(string scalar key, real scalar rownr) 
{
	string scalar errmsg
	
	if (!anyof(bib.keys,key)) {
		errmsg = "{err}Could not find the key {res} " + key + " {err} in the bibliography"
		printf(errmsg)
		where_err(rownr)
		exit(198)
	}
}
string colvector smclpres::extract_rawrefs( real scalar rownr) 
{
	real   scalar    st, fi
	string colvector res
	string scalar    err, line
	
	res = J(0,1, "")
	line = source[rownr,1]
	st = 0
	while( (st = ustrpos(line, "/*cite", st) + 1 ) != 1) {
		fi = ustrpos(line, "*/", st)
		if (fi == 0) {
			err = "{p]{err}a /*cite was started but was not finished by a */{p_end}"
			printf(err)
			where_err(rownr)
			exit(198)
		}
		res = res \ usubstr(line,st+6, fi-st-6)
	}
	return(res)
}

void smclpres::fix_collisions() 
{
	string matrix     content
	string scalar     key, pf
	real   scalar     i, k, dup
	real   colvector  o
	
	k = rows(bib.refs)
	if (k > 1) {
		content = J(k,4, "")
		for (i = 1 ; i <= k; i++) {
			key = bib.refs[i]
			if (bib.bibdb.exists((key,"author"))) {
				content[i,1] = invtokens(bib.bibdb.get((key, "author_last"))')
				content[i,2] = bib.bibdb.get((key, "year"))
				content[i,3] = bib.bibdb.get((key, "title"))
				content[i,4] = key
			}
		}
		o = order(content,(1,2,3,4))
		content = content[o,.]
		bib.refs = bib.refs[o]
		
		dup = 0
		for (i = 2 ; i <= k; i++) {
			if ( content[|i,1 \ i, 2|] == content[|i-1,1 \ i-1, 2|] ) {
				dup = dup + 1
				if (dup == 1) {
					key = content[i-1,4]
					bib.bibdb.put((key, "postfix"), "a")
				}
				key = content[i,4]
				pf = strlower(numtobase26(dup+1))
				bib.bibdb.put((key,"postfix"),pf)
			}
			else {
				dup = 0
			}
		}
	}
}

void smclpres::init_bib()
{
	if (bib.bibslide != .) {
		if (bib.bibfile == "" ) {
			bib.bibfile = st_tempfilename()
			collect_bib()
		}
		read_bib()
		set_style()
		collect_refs()
	}
}
end
