clear all
mata:
mata set matastrict on
class smclpres {
    struct valid_set scalar valid_settings
    string           matrix source
    real             scalar count_lines()
    void                    read_file()
    real             scalar _read_file()
    void                    new()
    void                    parse_args()
    string           matrix extract_args()
}


struct valid_set 
{
    string                 rowvector layout
    string                 rowvector toc
    string                 rowvector tocfiles
    class AssociativeArray scalar    arg
}

void smclpres:: new() {
    source = J(0,3,"")
    valid_settings.layout    = "toc", "tocfiles"
    valid_settings.toc = "link", "itemize", "anc", "title", "secthline",
                         "secbhline", "secbold", "secitalic", "subsecbold",
                         "subsecitalic", "subsubsecbold", "subsubsecitalic",
                         "subsubsubsecbold", "subsubsubsecitalic",
                   		 "subtitlepos", "nosubtitlebold", "subtitleitalic", 
                         "nosubtitlethline", "nosubtitlebhline", "subtitle", "nodigr"
    vali_settings.tocfiles = "off", "on", "name", "where", "exname",
		"doname", "adoname", "dataname", "classname",
		"stylename", "graphname", "grecname", "irfname",
		"mataname", "bcname", "stername", "tracename",
        "semname", "swmname", "customname",
		"doedit", "view", "gruse", "euse", "use",
		"p2"       
    vali_settings.arg.reinit("string",2)                                
    valid_settings.arg.notfound("")
    valid_settings.arg.put(("toc","link"), ("section", "subsection", "subsubsection")) 
    valid_settings.arg.put(("toc","title"), ("subsection", "subsubsection", "notitle"))                           
    valid_settings.arg.put(("toc","subtitlepos"), ("left", "center"))
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

real scalar smclpres::_read_file(string scalar filename, real scalar lnr) {
    string matrix EOF, toadd
    real scalar fh, i, newlines
    string scalar line
    string rowvector parts 
    
    newlines = count_lines(filename)
    toadd = J(newlines,3,"")
    source = source \ toadd
    fh = fopen(filename, "r")
    i = 0
    
    while ((line=fget(fh))!=EOF) {
        i++
        parts = tokens(line)
        if (cols(parts) > 0) {
            if (parts[1] == "//include") {
                source = source[|1,1 \ rows(source)-1,3|]
                lnr = _read_file(parts[2], lnr)
            }
            else {
                source[lnr  ,1] = line
                source[lnr  ,2] = filename
                source[lnr++,3] = strofreal(i)
            }
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