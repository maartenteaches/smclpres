mata:
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

void smclpres::no_arg_err(string scalar opt, string scalar cmd, string scalar file, string scalar line)
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
}

void smclpres::allowed_arg_err(string scalar opt, string scalar cmd, string scalar file, string scalar line, string rowvector allowed)
{
	string scalar errmsg, all_err
    real scalar k, i
    
    if (anyof(allowed, arg)== 0) {
        k = cols(allowed)
        all_err = allowed[1]
        if (k>1) {
            for(i=2; i<k; i++) {
                all_err = all_err + ", " + allowed[i]
            }
            all_err = all_err + ", or " + allowed[k]
        }
    
        errmsg = "{p}{err} option {res}" + opt + "{err} in " +
                 "{res}//layout "+ cmd + "{err} may contain either " +
                 all_err + "{p_end}"
        printf(errmsg)
        errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
        printf(errmsg)
        exit(198)
    }
}

void smclpres::p_toc_font(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, file, line)
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
    if (cmd=="nosubtitlebold") {
        settings.toc.subtitlebf = "regular"
    }
    if (cmd=="subtitleitalic") {
        settings.toc.subtitleit = "italic"
    }        
}

void smclpres::p_toc_hline(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, file, line)
    if (cmd=="secthline") {
        settings.toc.secthline = "hline"
    }
    if (cmd=="secbhline") {
        settings.toc.secbhline = "hline"
    }
    if (cmd="nosubtitlethline") {
        settings.toc.subtitlethline = "nohline"
    }
    if (cmd="nosubtitlebhline"){
        settings.toc.subtitlebhline = "nohline"
    }
}

void smclpres::p_toc_subtitlepos(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    allowed_arg_err(opt, cmd, file, line, ("left", "center"))
    settings.toc.subtitlepos = opt
}

void smclpres::p_toc_sec_sub_sub(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{

    allowed_arg_err(opt, cmd, file, line, ("section", "subsection", "subsubsection"))

    if (cmd == "link") {
        settings.toc.link = arg
    }
    else if (cmd == "title") {
        settings.toc.title = arg
        if (opt == "subsection") {
            settings.topbar.subsec = "nosubsec"
        }
    }
}

void smclpres::p_toc_itemize(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, file, line)
    settings.toc.itemize = "itemize"
}

void smclpres::p_toc_anc(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    settings.toc.anc = opt
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