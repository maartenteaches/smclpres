mata:
void smclpres::generic_err_msg(string scalar cmd, string scalar opt, string scalar file, string scalar line)
{
    string scalar errmsg
    errmsg = "{p}{err}there is an error with option {res}" +
             opt + " {err} of {res}//layout " + cmd + " {p_end}" 
    printf(errmsg)
    errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
    printf(errmsg)
    exit(198)
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

void smclpres::p_font(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    if (cmd=="toc") {
        if (opt=="secbold") {
            settings.toc.secbf = "bold"
        }
        if (opt=="secitalic") {
            settings.toc.secit = "italic"
        }    
        if (opt=="subsecbold") {
            settings.toc.subsecbf = "bold"
        }
        if (opt=="subsecitalic") {
            settings.toc.subsecit = "italic"
        }
        if (opt=="subsubsecbold") {
            settings.toc.subsubsecbf = "bold"
        }
        if (opt=="subsubsecitalic") {
            settings.toc.subsubsecit = "italic"
        }        
        if (opt=="subsubsubsecbold") {
            settings.toc.subsubsubsecbf = "bold"
        }
        if (opt=="subsubsubsecitalic") {
            settings.toc.subsubsubsecit = "italic"
        }
        if (opt=="nosubtitlebold") {
            settings.toc.subtitlebf = "regular"
        }
        if (opt=="subtitleitalic") {
            settings.toc.subtitleit = "italic"
        }
    }    
    if (cmd=="title"){
        if (opt=="nobold") {
            settings.title.bold = "regular"
        }
        if (opt=="italic") {
            settings.title.italic = "italic"
        }  
    }
    if (cmd=="topbar"){
        if (opt=="nosecbold") {
            settings.topbar.secbf = "regular"
        }
        if (opt=="secitalic") {
            settings.topbar.secit = "italic"
        }    
        if (opt=="subsecbold") {
            settings.topbar.subsecbf = "bold"
        }
        if (opt=="subsecitalic") {
            settings.topbar.subsecit = "italic"
        }
        if (opt=="subsubsecbold") {
            settings.toc.subsubsecbf = "bold"
        }
        if (opt=="subsubsecitalic") {
            settings.toc.subsubsecit = "italic"
        }  
    }
}

void smclpres::p_pos(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (cmd=="bottombar") {
        allowed_arg_err(opt, cmd, arg, file, line, ("left", "right"))
        settings.bottombar.next = arg 
    }
    if (cmd == "toc") {
        allowed_arg_err(opt, cmd, arg, file, line, ("left", "center"))
        settings.toc.subtitlepos = opt
    }
    if (cmd=="title") {
        no_arg_err(opt, cmd, arg, file, line)
        settings.title.pos = opt 
    }
}
void smclpres::p_hline(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (cmd == "toc") {
        no_arg_err(opt, cmd, arg, file, line)
        if (opt=="secthline") {
            settings.toc.secthline = "hline"
        }
        if (opt=="secbhline") {
            settings.toc.secbhline = "hline"
        }
        if (opt=="nosubtitlethline") {
            settings.toc.subtitlethline = "nohline"
        }
        if (opt=="nosubtitlebhline"){
            settings.toc.subtitlebhline = "nohline"
        }
    }
    if (cmd == "title") {
        if (opt=="thline") {
            settings.bottombar.thline = "hline"
        }
        if (opt=="bhline"){
            settings.bottombar.bhline = "hline"
        }
    }
    if (cmd == "topbar") {
        if (opt=="nothline") {
            settings.topbar.thline = "nohline"
        }
        if (opt=="nobhline"){
            settings.topbar.bhline = "nohline"
        }
    }
    if (cmd == "bottombar") {
        if (opt=="nothline") {
            settings.bottombar.thline = "nohline"
        }
        if (opt=="nobhline"){
            settings.bottombar.bhline = "nohline"
        }
    }
}

void smclpres::p_toc_sec_sub_sub(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{

    allowed_arg_err(opt, cmd, arg, file, line, ("section", "subsection", "subsubsection"))

    if (opt == "link") {
        settings.toc.link = arg
    }
    else if (opt == "title") {
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
    if (opt=="anc") {
        settings.toc.anc = arg
    }
    if (opt=="subtitle") {
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

    if (!anyof(specified, "gph")) {
        settings.tocfiles.gruse = settings.tocfiles.gruse + " gph"
    }
    if (!anyof(specified, "ster")) {
        settings.tocfiles.euse = settings.tocfiles.euse + " ster"
    }
    if (!anyof(specified, "dta")) {
        settings.tocfiles.use = settings.tocfiles.use + " dta"
    }
}

void smclpres::p_tocfiles_name(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    string scalar mark
    if (opt == "name") {
        settings.tocfiles.name = arg
    }
    if (opt == "where") {
        settings.tocfiles.where = arg
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
    string scalar mark, label
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
                generic_err_msg(cmd,opt,file,line)                    
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
    if (!ok) {
        generic_err_msg(cmd, opt, file, line)           
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
    settings.tocfiles.on = opt
}

void smclpres::p_digr(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (opt == "name"){
        settings.digress.name = arg
    }
    if (opt == "prefix"){
        settings.digress.prefix = arg
    }
}
void smclpres::p_ex(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (opt == "name"){
        settings.example.name = arg
    }
}
void smclpres::p_topbar_sep(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    settings.topbar.sep = arg
}
void smclpres::p_topbar_nosubsec(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    settings.topbar.subsec = opt
}

void smclpres::p_topbar_on_off(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    settings.topbar.on = opt
}

void smclpres::p_bottombar_name(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (opt == "index" ) {
        settings.bottombar.index = arg
    }
    if (opt == "nextname") {
        settings.bottombar.nextname = arg
    }
    if (opt == "tpage") {
        settings.bottombar.tpage = arg
    }
}

void smclpres::p_bottombar_arrow_label(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    no_arg_err(opt, cmd, arg, file, line)
    settings.bottombar.arrow = opt
}

void smclpres::p_tab(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    real scalar spaces
    spaces = strtoreal(arg)
    if (spaces==. | spaces < 0 | floor(spaces)!=spaces) {
        generic_err_msg(cmd,opt, file, line)
    }
    settings.other.tab = spaces
}
void smclpres::p_bib_file(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    string scalar path
    path = settings.other.sourcedir
    path = pathjoin(path, arg)
    if (!fileexists(path)) {
        generic_err_msg(cmd,opt,file,line)
    }
    if (opt == "bibfile") {
        bib.bibfile = path
    }
    if (opt == "stylefile") {
        bib.stylefile = path
    }
}    

void smclpres::p_bib_opt(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (opt=="and") {
        bib.and = arg
    }
    if (opt == "authorstyle") {
        allowed_arg_err(opt, cmd, arg, file, line, ("first last", "last first"))
        bib.authorstyle = arg
    }
    if (opt == "write") {
        allowed_arg_err(opt, cmd, arg, file, line, ("cited", "all"))
        bib.write = arg
    }
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
            source = source[|1,1 \ rows(source)-1,3|]
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

void smclpres::read_file() {
    real scalar i
    i = _read_file(settings.other.source,1)
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

void smclpres::parsedirs()
{
    string scalar usingpath, dir, replace
    string scalar file, stub, odir, path, sdir, source, ddir

    usingpath = st_local("using")
    dir = st_local("dir")
    replace = st_local("replace")

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
	settings.other.stub      = stub
	settings.other.sourcedir = sdir
	settings.other.source    = source
	settings.other.olddir    = odir
	settings.other.destdir   = ddir
	settings.other.replace   = replace
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
