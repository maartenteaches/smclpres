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

void smclpres::p_layout(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line)
{
    if (cmd=="toc") {
        if      (opt == "secthline"         ) p_hline(cmd, opt, arg, file , line)
        else if (opt == "secbhlil"          )  p_hline(cmd, opt, arg, file , line)
		else if (opt == "nosubtitlethline"  ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "nosubtitlebhline"  ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "itemize"           ) p_toc_itemize(cmd, opt, arg, file , line)
		else if (opt == "anc"               ) p_toc_name(cmd, opt, arg, file , line)
		else if (opt == "subtitle"          ) p_toc_name(cmd, opt, arg, file , line)
		else if (opt == "nodigr"            ) p_toc_nodigr(cmd, opt, arg, file , line)
		else if (opt == "subtitlepos"       ) p_pos(cmd, opt, arg, file , line)
		else if (opt == "link"              ) p_toc_sec_sub_sub(cmd, opt, arg, file , line)
		else if (opt == "title"             ) p_toc_sec_sub_sub(cmd, opt, arg, file , line)
		else if (opt == "secbold"           ) p_font(cmd, opt, arg, file , line)
		else if (opt == "secitalic"         ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsecbold"        ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsecitalic"      ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsubsecbold"     ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsubsecitalic"   ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsubsubsecbold"  ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsubsubsecitalic") p_font(cmd, opt, arg, file , line)
		else if (opt == "nosubtitlebold"    ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subtitleitalic"    ) p_font(cmd, opt, arg, file , line)
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd=="tocfiles"){
		if      (opt == "name"              ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "where"             ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "exname"            ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "doname"            ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "adoname"           ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "dataname"          ) p_tocfiles_name(cmd, opt, arg, file , line)	
		else if (opt == "classname"         ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "stylename"         ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "graphname"         ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "grecname"          ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "irfname"           ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "mataname"          ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "bcname"            ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "stername"          ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "tracename"         ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "semname"           ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "swmname"           ) p_tocfiles_name(cmd, opt, arg, file , line)
		else if (opt == "customname"        ) p_tocfiles_customname(cmd, opt, arg, file , line)
		else if (opt == "doedit"            ) p_tocfiles_howdisplay(cmd, opt, arg, file , line)
		else if (opt == "view"              ) p_tocfiles_howdisplay(cmd, opt, arg, file , line)
		else if (opt == "gruse"             ) p_tocfiles_howdisplay(cmd, opt, arg, file , line)
		else if (opt == "euse"              ) p_tocfiles_howdisplay(cmd, opt, arg, file , line)
		else if (opt == "use"               ) p_tocfiles_howdisplay(cmd, opt, arg, file , line)
		else if (opt == "p2"                ) p_tocfiles_p2(cmd, opt, arg, file , line)
		else if (opt == "on"                ) p_tocfiles_on_off(cmd, opt, arg, file , line)
		else if (opt == "off"               ) p_tocfiles_on_off(cmd, opt, arg, file , line)
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd == "digress") {
		if      (opt == "name"              ) p_digr(cmd, opt, arg, file , line)
		else if (opt == "prefix"            ) p_digr(cmd, opt, arg, file , line)		
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd == "example") {
		if (opt == "name") p_ex(cmd, opt, arg, file , line)
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd == "topbar") {
        if      (opt == "on"                ) p_topbar_on_off(cmd, opt, arg, file , line)
		else if (opt == "off"               ) p_topbar_on_off(cmd, opt, arg, file , line)
		else if (opt == "nothline"          ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "nobhline"          ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "nosubsec"          ) p_topbar_nosubsec(cmd, opt, arg, file , line)
		else if (opt == "nosecbold"         ) p_font(cmd, opt, arg, file , line)
		else if (opt == "secitalic"         ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsecbold"        ) p_font(cmd, opt, arg, file , line)
		else if (opt == "subsecitalic"      ) p_font(cmd, opt, arg, file , line)
		else if (opt == "sep"               ) p_topbar_sep(cmd, opt, arg, file , line)		
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd == "bottombar") {
		if      (opt == "nothline"          ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "nobhline"          ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "arrow"             ) p_bottombar_arrow_label(cmd, opt, arg, file , line)
		else if (opt == "label"             ) p_bottombar_arrow_label(cmd, opt, arg, file , line)
		else if (opt == "toc"               ) p_bottombar_arrow_label(cmd, opt, arg, file , line)
		else if (opt == "next"              ) p_pos(cmd, opt, arg, file , line)
		else if (opt == "index"             ) p_bottombar_name(cmd, opt, arg, file , line)
		else if (opt == "nextname"          ) p_bottombar_name(cmd, opt, arg, file , line)
		else if (opt == "tpage"             ) p_bottombar_name(cmd, opt, arg, file , line)
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd == "title") {
		if      (opt == "thline"            ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "bhline"            ) p_hline(cmd, opt, arg, file , line)
		else if (opt == "nobold"            ) p_font(cmd, opt, arg, file , line)
		else if (opt == "italic"            ) p_font(cmd, opt, arg, file , line)
		else if (opt == "left"              ) p_pos(cmd, opt, arg, file , line)
		else if (opt == "center"            ) p_pos(cmd, opt, arg, file , line)
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd == "tabs") {
		if (opt == "spaces"            ) p_tab(cmd, opt, arg, file , line)
		else notallowed(cmd, opt, arg, file , line)
	}
	else if (cmd == "bib") {
		if      (opt == "bibfile"           ) p_bib_file(cmd, opt, arg, file , line)
		else if (opt == "stylefile"         ) p_bib_file(cmd, opt, arg, file , line)
		else if (opt == "and"               ) p_bib_opt(cmd, opt, arg, file , line)
		else if (opt == "authorstyle"       ) p_bib_opt(cmd, opt, arg, file , line)
		else if (opt == "write"             ) p_bib_opt(cmd, opt, arg, file , line)
		else notallowed(cmd, opt, arg, file , line)
    }
	else notallowed(cmd, opt, arg, file , line) 
}
void smclpres::parse_args(string scalar cmd, string scalar line, string scalar filename, real scalar lnr)
{
    string matrix args
    real scalar i

    args = extract_args(line)
    for (i=1; i<=rows(args); i++) {
        p_layout(cmd, args[i,1], args[i,2], filename, strofreal(lnr))
    }
}

real scalar smclpres::_read_file(string scalar filename, real scalar lnr, real rowvector current_version) {
    transmorphic scalar t
    string matrix EOF, toadd
    real matrix toadd_v
    real scalar fh, i, newlines
    string scalar line, part, cmd
    real rowvector old_version
    
    EOF = J(0,0,"")
    newlines = count_lines(filename)
    toadd = J(newlines,3,"")
    source = source \ toadd
    toadd_v = J(newlines,3,.)
    source_version = source_version \toadd_v
    

    fh = sp_fopen(filename, "r")
    i = 0
    
    while ((line=fget(fh))!=EOF) {
        i++
        t = tokeninit()
        tokenset(t,line)
        part = tokenget(t)
        if (part == "//include") {
            source = source[|1,1 \ rows(source)-1,3|]
            source_version = source_version[|1,1 \ rows(source_version)-1,3|]
            part = tokenget(t)
            if (!pathisabs(part)) part = settings.other.sourcedir + part
            old_version = current_version
            lnr = _read_file(part, lnr, current_version)
            current_version = old_version
        }
        else if (part == "//layout") {
            source = source[|1,1 \ rows(source)-1,3|]
            source_version = source_version[|1,1 \ rows(source_version)-1,3|]
            cmd = tokenget(t)
            line = tokenrest(t)
            parse_args(cmd, line, filename, i) 
        }
        else if (part == "//version") {
            source = source[|1,1 \ rows(source)-1,3|]
            source_version = source_version[|1,1 \ rows(source_version)-1,3|]
            part = tokenget(t)
            current_version = parse_version(part, filename, i)
        }
        else {
            source[lnr,1] = line
            source[lnr,2] = filename
            source[lnr,3] = strofreal(i)
            source_version[lnr++,.] = current_version
        }
    }
    sp_fclose(fh)
    return(lnr)
}

void smclpres::read_file() {
    real scalar i

    i = _read_file(settings.other.source,1, smclpres_version)
}

real scalar smclpres::count_lines(string scalar filename) {
    string matrix EOF
    real scalar fh, i
    
    fh = sp_fopen(filename, "r")
    EOF = J(0,0,"")
    
    i=0
    while (fget(fh)!=EOF) {
       i++ 
    }
    sp_fclose(fh)
    return(i)
}

void smclpres::parsedirs()
{
    string scalar usingpath, dir, replace
    string scalar file, stub, odir, path, sdir, source, ddir

    usingpath = st_local("using")
    dir = st_local("dir")
    replace = st_local("replace")
    pathsplit(usingpath, path="", file="")
    stub = pathrmsuffix(file)
    odir = pwd()
    if(path != "") cd(path)
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
        errmsg = "{p}{err}directory " + path + " not found{p_end}"
        printf(errmsg)
        exit(rc)
    }
}

real rowvector smclpres::parse_version(string scalar valstr, string scalar filename, real scalar lnr)
{
	real scalar l, i, j
	real rowvector v
	string scalar part, errmsg, where
	string rowvector res, nr

    where = "{p}{err}This error occured on line " + strofreal(lnr) + " of " + filename + "{p_end}"
	res = "", J(1,2,"0")
	l = ustrlen(valstr)
	j=1
	nr = "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
	
	for(i=1; i<=l; i++) {
		part = usubstr(valstr,i,1)
		if (anyof(nr,part)) {
			res[j] = res[j]+part
		}
		else if (part == "." ) {
			if (i!=l) {
				j=j+1
				if (j>3) {
                    printf("{p}{err}format for version number is #.#.#{p_end}")
                    printf(where)
					exit(198)
				}
				res[j]=""
			}
		}
		else {
			printf("{p}{err}format for version number is #.#.#{p_end}")
            printf(where)
            exit(198)
		}
	}
	v = strtoreal(res)
    if (pres_lt_val(1, v, "max")) {
        errmsg = invtokens(strofreal(smclpres_version), ".")
        errmsg = "{p}{err}this is version " + errmsg + " of smclpres{p_end}"    
        printf(errmsg)
        printf("{p}{err}a version specified in //version cannot exceed that{p_end}")
        printf(where)
        exit(198)
    }
	return(v)
}

real scalar smclpres::pres_lt_val(real scalar sourcerow, real rowvector tocheck, | string scalar max) 
{
    real scalar i, res
	real rowvector pres
	
    if (args()==2) {
		pres = source_version[sourcerow,.]
	}
	else {
		pres = smclpres_version
	}

	res = 0
	for (i=1; i<=3 ; i++) {
		if (pres[i] > tocheck[i]) {
			break
		}
	    if (pres[i] < tocheck[i]) {
		    res = 1
			break
		}
	}
	return(res)
}

real scalar smclpres::pres_leq_val(real scalar sourcerow, real rowvector tocheck) 
{
    real scalar i, res
	
	if (tocheck==source_version[sourcerow,.]) return(1)
	return(pres_lt_val(sourcerow, tocheck))
}

real scalar smclpres::pres_geq_val(real scalar sourcerow, real rowvector tocheck) 
{
    real scalar i, res
	
	if (tocheck==source_version[sourcerow,.]) return(1)
	return(pres_gt_val(sourcerow, tocheck))
}

real scalar smclpres::pres_gt_val(real scalar sourcerow, real rowvector tocheck) 
{
    real scalar i, res
	
	res = 0
	for (i=1; i<=3 ; i++) {
		if (source_version[sourcerow, i] > tocheck[i]) {
			res = 1
			break
		}
	    if (source_version[sourcerow, i] < tocheck[i]) {
			break
		}
	}
	return(res)
}

real scalar smclpres::sp_fopen ( string scalar file, string scalar mode, | real scalar sourcerow) {
	real scalar fh, errcode
	string scalar errmsg
        
    if (mode == "w" & settings.other.replace == "replace") {
        errcode = _unlink(file)
        if (errcode != 0){
            if (args() == 3) {
                errmsg = "{p}{err}an error occured when replacing file " + file + "{p_end}"
                printf(errmsg)
                errmsg = "{p}{err}This error occured on line " + source[sourcerow,3] + " of  file " + source[sourcerow,2] +"{p_end}"
                printf(errmsg)
                exit(abs(errcode))
            }
            else {
                exit(error(abs(errcode)))
            }
        }
    }
	fh = _fopen(file, mode)
    if (fh < 0 ) {
        if (args() == 3) {
            errmsg = "{p}{err}An error occured when opening file " + file +"{p_end}"
            printf(errmsg)
            errmsg = "{p}{err}This error occured on line " + source[sourcerow,3] + " of  file " + source[sourcerow,2] +"{p_end}"
            printf(errmsg)
            exit(abs(fh))
        }
        else {
            exit(error(abs(fh)))
        }
    }
	files.put(fh, "open")
	return(fh)
}

void smclpres::sp_fclose ( real scalar fh,| real scalar sourcerow) {
    real scalar errcode
    string scalar errmsg

    errcode = _fclose(fh)
    if (errcode < 0 ) {
        if (args() == 2) {
            errmsg = "{p}{err}An error occured when closing a file {p_end}"
            printf(errmsg)
            errmsg = "{p}{err}This error occured on line " + source[sourcerow,3] + " of  file " + source[sourcerow,2] +"{p_end}"
            printf(errmsg)
            exit(abs(errcode))
        }
        else {
            exit(error(abs(errcode)))
        }
    }
	files.put( fh, "closed")
}

void smclpres::sp_fcloseall () {
	transmorphic scalar notfound
	real         scalar fh
    string       scalar val
	
    notfound = files.notfound()
    for (val=files.firstval(); val!=notfound; val=files.nextval()) {
        if (val == "open") {
            fh = files.key()
            fclose(fh)
            files.put(fh, "closed")
        }
    }
}

end
