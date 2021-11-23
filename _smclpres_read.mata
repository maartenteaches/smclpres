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

void smclpres::no_arg_err(string scalar opt, string scalar cmd, string scalar arg, string scalar file, string scalar line)
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

void smclpres::allowed_arg_err(string scalar opt, string scalar cmd, string scalar arg, string scalar file, string scalar line, string rowvector allowed)
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
    no_arg_err(opt, cmd, arg, file, line)
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
    no_arg_err(opt, cmd, arg, file, line)
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
    allowed_arg_err(opt, cmd, arg, file, line, ("left", "center"))
    settings.toc.subtitlepos = opt
}

void smclpres::p_toc_sec_sub_sub(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{

    allowed_arg_err(opt, cmd, arg, file, line, ("section", "subsection", "subsubsection"))

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
    no_arg_err(opt, cmd, arg, file, line)
    settings.toc.itemize = "itemize"
}

void smclpres::p_toc_name(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (cmd=="anc") {
        settings.toc.anc = arg
    }
    if (cmd=="subtitle") {
        settings.toc.subtitle = arg
    }
}

void smclpres::changemarkname(string scalar mark, string scalar name) {
	real colvector i
	
	i = selectindex(settings.tocfiles.markname[.,1] :== mark)
	if (cols(i) > 1) {
		exit(error(198))
	}
	settings.tocfiles.markname[i,2] = name
}

void smclpres::p_tocfiles_howdisplay(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    arg = usubinstr(arg, ".", "", .)
    if (opt == "doedit") {
        settings.tocfiles.doedit = arg
    }
    else if (opt == "view") {
        settings.tocfiles.view = arg
    }
    else if (opt == "gruse") {
        settings.tocfiles.gruse = arg
    }
    else if (opt == "euse") {
        settings.tocfiles.euse = arg
    }
    else if (opt == "use") {
        settings.tocfiles.use = arg
    }
}
void smclpres::p_tocfiles_howdisplay_default()
{
    string rowvector specified, def
    string scalar tofill
    real scalar i

    specified = tokens(settings.tocfiles.doedit), 
                tokens(settings.tocfiles.view),
                tokens(settings.tocfiles.gruse),
                tokens(settings.tocfiles.euse),
                tokens(settings.tocfiles.use)

    def = "do", "ado", "dct", "class", "scheme", "style"

    tofill = ""
    for(i=1 ; i<= cols(def) ; i++) {
        if (!anyof(specified, def[i])) {
            tofill = tofill + " " + def[i]
        }
    }
    settings.tocfiles.doedit = settings.tocfiles.doedit + tofill

    def = "smcl", "log", "hlp", "sthlp"
    tofill = ""
    for(i=1 ; i<= cols(def) ; i++) {
        if (!anyof(specified, def[i])) {
            tofill = tofill + " " + def[i]
        }
    }
    settings.tocfiles.view = settings.tocfiles.view + tofill

    if !anyof(specified, "gph") {
        settings.tocfiles.gruse = settings.tocfiles.gruse + " gph"
    }
    if !anyof(specified, "ster") {
        settings.tocfiles.euse = settings.tocfiles.euse + " ster"
    }
    if !anyof(specified, "dta") {
        settings.tocfiles.use = settings.tocfiles.use + " dta"
    }
}

void smclpres::p_tocfiles_name(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    string scalar mark
    if (cmd == "name") {
        settings.tocfiles.name = arg
    }
    if (cmd == "where") {
        settings.toctiles.where = arg
    }
    else  {
        mark = usubstr(cmd, 1, ustrpos(cmd, "name") - 1)
        changemarkname(mark, opt)
    }
}

void smclpres::p_tocfiles_customname(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    string rowvector parts
    real scalar i
    transmorphic scalar t
    string scalar mark, label, errmsg
    string matrix res

    parts = tokens(arg, ";")
    t = tokeninit(" ")
    res = J(0,2,"")
    for(i=1; i<=cols(parts); i++) {
        if (parts[i]!=";") {
            tokenset(t,parts[i])
            mark = tokenget(t)
            label = tokenrest(t)
            if (label == "") {
                errmsg = "{p}{err}there is a problem with the customname() option in //layout tocfiles{p_end}"
                printf(errmsg)
                errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
                printf(errmsg)
                exit(198)                       
            }
            res = res \ (mark, label)
        }
    }
    settings.tocfiles.markname = settings.tocfiles.markname \ res
}
void smclpres::p_tocfiles_p2(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    real rowvector nums
    real scalar ok, k
    string scalar errmsg

    nums = strtoreal(tokens(arg))
    k = cols(nums)
    if (k > 2) {
    ok = !anyof(nums,.)        & 
         !any(nums:<0)         & 
         (nums == floor(nums)) & 
         (nums[1]<=nums[2])    & 
         (cols(nums)==4)
    }
    else {
        ok = 0
    }
    if (!`ok') {
        errmsg = "{p}{err}there is a problem with the p2() option in //layout tocfiles{p_end}"
        printf(errmsg)
    	errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
	    printf(errmsg)
	    exit(198)           
	}
    settings.tocfiles.p2 = arg
}    
void smclpres::p_toc_nodigr(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    settings.toc.nodigr="nodigr"    
}

void smclpres::p_tocfiles_on_off(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    settings.tocfiles.on = cmd
}

void smclpres::p_digr(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (cmd == "name"){
        settings.digress.name = arg
    }
    if (cmd == "prefix"){
        settings.digress.prefix = arg
    }
}
void smclpres::p_ex(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (cmd == "name"){
        settings.example.name = arg
    }
}
    sep(string asis)

void smclpres::p_topbar_sep(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    settings.topbar.sep = arg
}
void smclpres::p_topbar_font(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    if (cmd=="nosecbold") {
        settings.topbar.secbf = "regular"
    }
    if (cmd=="secitalic") {
        settings.topbar.secit = "italic"
    }    
    if (cmd=="subsecbold") {
        settings.topbar.subsecbf = "bold"
    }
    if (cmd=="subsecitalic") {
        settings.topbar.subsecit = "italic"
    }
    if (cmd=="subsubsecbold") {
        settings.toc.subsubsecbf = "bold"
    }
    if (cmd=="subsubsecitalic") {
        settings.toc.subsubsecit = "italic"
    }  
}
void smclpres::p_topbar_nosubsec(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    settings.topbar.subsec = cmd
}

void smclpres::p_topbar_hline(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    if (cmd="nothline") {
        settings.topbar.thline = "nohline"
    }
    if (cmd="nobhline"){
        settings.topbar.bhline = "nohline"
    }
}
void smclpres::p_topbar_on_off(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    settings.topbar.on = cmd
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

void smclpres::parsedirs(string scalar usingpath, string scalar dir, string scalar replace)
{
    string scalar file, stub, odir, path, sdir, source, ddir
    pathsplit(usingpath, file="", path="")
    stub = pathrmsuffix(file)
    odir = pwd()
    cd(path)
    sdir = pwd()
    source = pathjoin(sdir,file)
    if (dir!= "") {
        cd(odir)
        cd(dir)
        ddir = pwd()
    }
    else {
        ddir = odir
    }
    cd(odir)
	settings.other.stub      = "stub"
	settings.other.sourcedir = "sdir"
	settings.other.source    = "source"
	settings.other.olddir    = "odir"
	settings.other.destdir   = "ddir"
	settings.other.replace   = "replace"
}

void smclpres::cd(string scalar path) {
    real scalar rc
    string scalar errmsg
    rc = _chdir(path)
    if (rc != 0) {
        errmsg = "{p}{err}directory " + path + "not found{p_end}"
        printf(errmsg)
        exit(rc)
    }
}

end
