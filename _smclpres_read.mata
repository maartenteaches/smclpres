mata:

void smclpres::p_toc_font(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    string scalar errmsg
    if (arg != "") {
        errmsg = "{p}{err}no argument allowed for option {res}" +
                 opt + " {err} of {res}//layout " + cmd + " {p_end}" 
        printf(errmsg)
        errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
        printf(errmsg)
        exit(198)
    }
    if (cmd=="secbold") {
        settings.toc.secbf = "bold"
    }
    if (cmd=="secitalic") {
        settings.toc.secit = "italic"
    }    
    if (cmd=="subsecbold") {
        settings.toc.subsecbf = "bold"
    }
    if (cmd=="subsecitalic") {
        settings.toc.subsecit = "italic"
    }
    if (cmd=="subsubsecbold") {
        settings.toc.subsubsecbf = "bold"
    }
    if (cmd=="subsubsecitalic") {
        settings.toc.subsubsecit = "italic"
    }        
    if (cmd=="subsubsubsecbold") {
        settings.toc.subsubsubsecbf = "bold"
    }
    if (cmd=="subsubsubsecitalic") {
        settings.toc.subsubsubsecit = "italic"
    }
    if (cmd=="subtitlebold") {
        settings.toc.subtitlebf = "bold"
    }
    if (cmd=="subtitleitalic") {
        settings.toc.subtitleit = "italic"
    }        
}
void smclpres::p_toc_sec_sub_sub(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    string scalar errmsg
    string rowvector allowed

    allowed = "section", "subsection", "subsubsection"
    if (anyof(allowed, arg)== 0) {
        errmsg = "{p}{err} option {res}" + opt + "{err} in " +
                 "{res}//layout "+ cmd + "{err} may contain either " +
                 "section, subsection, or subsubsection{p_end}"
        printf(errmsg)
        errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
        printf(errmsg)
        exit(198)
    }
    if (cmd == "link") {
        settings.toc.link = arg
    }
    else if (cmd == "title") {
        settings.toc.title = arg
    }
}
void smclpres::notallowed(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line) 
{
	string scalar errmsg
	errmsg = "{p}{err}option {res}" + opt
	if (arg != "") {
		errmsg = errmsg +"(" + arg + ")"
	}
	errmsg = errmsg + "{err} not allowed in {res}//layout " + cmd + "{p_end}"
	printf(errmsg)
	errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
	printf(errmsg)
	exit(198)
}

string matrix smclpres::extract_args(string scalar line)
{
	transmorphic scalar t
    string matrix res
    string scalar arg, token, EOL
    string rowvector row

    EOL = ""
    res = J(0,2,"")
    
    t = tokeninit(" "+char(9),(""),   ( `""""', `"`""'"',"()"),0,0)
    tokenset(t,line)
    
    
    while ( (token = tokenget(t)) != EOL) {
    	row = token
        arg = ""
        if (usubstr(tokenpeek(t),1,1) == "(") {
            arg = tokenget(t)
            arg = usubstr(arg,2, ustrlen(arg)-2)
        }
        row = row, arg
        res = res \ row
    }
    return(res)
}

void smclpres::parse_args(string scalar cmd, string scalar line, string scalar filename, real scalar lnr)
{
    string matrix args
    string rowvector key
    real scalar i
    pointer(void function) scalar p

    args = extract_args(line)
    for (i=1; i<=rows(args); i++) {
        key = cmd, args[i,1]
        p = option_parse.get(key)
        (*p)(cmd, args[i,1], args[i,2], filename, strofreal(lnr))
    }
}

real scalar smclpres::_read_file(string scalar filename, real scalar lnr) {
    transmorphic scalar t
    string matrix EOF, toadd
    real scalar fh, i, newlines
    string scalar line, part, cmd
    
    EOF = J(0,0,"")
    newlines = count_lines(filename)
    toadd = J(newlines,3,"")
    source = source \ toadd
    fh = fopen(filename, "r")
    i = 0
    
    while ((line=fget(fh))!=EOF) {
        i++
        t = tokeninit()
        tokenset(t,line)
        part = tokenget(t)
        if (part == "//include") {
            source = source[|1,1 \ rows(source)-1,3|]
            part = tokenget(t)
            lnr = _read_file(part, lnr)
        }
        else if (part == "//layout") {
            cmd = tokenget(t)
            line = tokenrest(t)
            parse_args(cmd, line, filename, i) 
        }
        else {
            source[lnr  ,1] = line
            source[lnr  ,2] = filename
            source[lnr++,3] = strofreal(i)
        }
    }
    fclose(fh)
    return(lnr)
}

void smclpres::read_file(string scalar filename) {
    real scalar i
    i = _read_file(filename,1)
}

real scalar smclpres::count_lines(string scalar filename) {
    string matrix EOF
    real scalar fh, i
    
    fh = fopen(filename, "r")
    EOF = J(0,0,"")
    
    i=0
    while (fget(fh)!=EOF) {
       i++ 
    }
    fclose(fh)
    return(i)
}
end