// ----------------------------------- parsedirs()
// absolute path
run smclpres_main.mata
local using "c:\temp\bla.do"
mata:
pwd = strlower(pwd())

totest = smclpres()
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == "c:\temp\")
assert(strlower(totest.settings.other.source) == "c:\temp\bla.do")
assert(strlower(totest.settings.other.stub) == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd)
assert(strlower(totest.settings.other.replace) == "")
end

// current dir
local using "bla.do"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd)
assert(strlower(totest.settings.other.source) == pwd + "bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd)
assert(strlower(totest.settings.other.replace) == "")
end

// relative path
local using "bench/test/bla.do"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd + "bench\test\")
assert(strlower(totest.settings.other.source) == pwd + "bench\test\bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd)
assert(strlower(totest.settings.other.replace) == "")
end

// dir
local using "bla.do"
local dir "bench/test"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd)
assert(strlower(totest.settings.other.source) == pwd + "bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd + "bench\test\")
assert(strlower(totest.settings.other.replace) == "")
end

// replace
local using "bla.do"
local dir "bench/test"
local replace "replace"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd)
assert(strlower(totest.settings.other.source) == pwd + "bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd + "bench\test\")
assert(strlower(totest.settings.other.replace) == "replace")
end

// -------------------------------------- count_lines()
mata:
assert(totest.count_lines("bench/minimalist.do") == 61)
end

// -------------------------------------- read_file()
//basic, all in one file
local using "bench/minimalist.do"
mata:
totest.parsedirs()
totest.read_file()
assert(rows(totest.source)==60) // there is a single //layout command in minimalist.do
assert(allof(strlower(totest.source[.,2]), pwd + "bench\minimalist.do"))
assert(totest.source[.,3]==(strofreal((1..4, 6..61)))')
assert(totest.settings.bottombar.arrow == "label")
end

// include
local using "bench/incl_main.do"
mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
assert(rows(totest.source)==56)

true = 
J(8,1,pwd + "bench\incl_main.do") \ 
J(15,1,pwd + "bench\incl_child.do") \ 
J(12,1, pwd + "bench\incl_grandchild1.do") \ 
pwd + "bench\incl_child.do" \ 
J(9,1, pwd + "bench\incl_grandchild2.do") \ 
J(11,1, pwd +  "bench\incl_child.do")
assert(strlower(totest.source[.,2]) == true)

true = (2..9, 1, 3..16, 2..13, 18, 1..9, 20..30)'
true = strofreal(true)
assert(totest.source[.,3]==true)

end

// ---------------------------------------------------------------------- sp_fopen & sp_fclose
local using "bench/incl_main.do"
local replace ""
mata:
totest = smclpres()
totest.parsedirs()
fh1 = totest.sp_fopen("bench\incl_main.do", "r")
unlink("bench/test/foo.do")
fh2 = totest.sp_fopen("bench\test\foo.do", "w")

notfound = totest.files.notfound()
for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "open") 
}

fput(fh2, "bla")
fput(fh2, "blup")
totest.sp_fclose(fh2)
fget(fh1)
totest.sp_fclose(fh1)

for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "closed") 
}

end
// no replace 
rcof `"mata: fh2 = totest.sp_fopen("bench\test\foo.do", "w")"' == 602

// replace
local using "bench/incl_main.do"
local replace "replace"
mata:
totest = smclpres()
totest.parsedirs()
fh2 = totest.sp_fopen("bench\test\foo.do", "w")
totest.sp_fclose(fh2)
end

// sp_fcloseall
local using "bench/incl_main.do"
local replace "replace"
mata:
totest = smclpres()
totest.parsedirs()
fh1 = totest.sp_fopen("bench\incl_main.do", "r")
fh2 = totest.sp_fopen("bench\test\foo.do", "w")
for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "open") 
}
totest.sp_fcloseall()
for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "closed") 
}
end

// ------------------------------------------------------------------- version
// parse_version

local using "bench/incl_main.do"
local replace "replace"
mata:
totest = smclpres()
assert(totest.parse_version("4.0.0", "filename", 1) == (4,0,0))
assert(totest.parse_version("3.14.0", "filename", 1) == (3,14,0))
assert(totest.parse_version("2.3.35", "filename", 1) == (2,3,35))
assert(totest.parse_version("4.0.", "filename", 1) == (4,0,0))
assert(totest.parse_version("4.0", "filename", 1) == (4,0,0))
assert(totest.parse_version("4.", "filename", 1) == (4,0,0))
assert(totest.parse_version("4", "filename", 1) == (4,0,0))

end

// version

local using "bench/incl_main.do"
local replace "replace"

mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
assert(totest.smclpres_version == (4,0,0))
true = J(9,1,(4,0,0))   \  // incl_main
       J(14,1,(3,1,0))  \  // incl_child
       J(12,1, (2,0,0)) \  // incl_grandchild1
       J(21,1,(3,1,0))     // incl_grandchild2 and incl_child
assert(totest.source_version == true)

assert(totest.pres_lt_val(1, (2,0,1))==0)
assert(totest.pres_lt_val(1, (4,0,0))==0) 
assert(totest.pres_lt_val(24, (2,0,1))==1)
assert(totest.pres_leq_val(1, (2,0,1))==0)
assert(totest.pres_leq_val(1, (4,0,0))==1) 
assert(totest.pres_leq_val(24, (2,0,1))==1)
assert(totest.pres_gt_val(1, (2,0,1))==1)
assert(totest.pres_gt_val(1, (4,0,0))==0) 
assert(totest.pres_gt_val(24, (2,0,1))==0)
assert(totest.pres_geq_val(1, (2,0,1))==1)
assert(totest.pres_geq_val(1, (4,0,0))==1) 
assert(totest.pres_geq_val(24, (2,0,1))==0)
end

// p_bib_opt()
mata:
totest = smclpres()
totest.p_bib_opt("bib", "and", "und", "file", "1")
assert(totest.bib.and == "und")
totest.p_bib_opt("bib", "authorstyle", "last first", "file", "1")
assert(totest.bib.authorstyle == "last first")
totest.p_bib_opt("bib", "write", "all", "file", "1")
assert(totest.bib.write == "all")

end

//errors
mata: totest = smclpres()
rcof `"noi mata: totest.generic_err_msg("topbar", "italic", "file", "4")"' == 198
rcof `"noi mata: totest.notallowed("topbar", "italic", "regular", "file", "4")"' == 198
noi mata: totest.no_arg_err("topbar", "italic", "", "file", "4")
rcof `"noi mata: totest.no_arg_err("topbar", "italic", "regular", "file", "4")"' == 198
noi mata: totest.allowed_arg_err("topbar", "italic", "regular", "file", "4", ("regular", "italic"))
noi mata: totest.allowed_arg_err("topbar", "italic", "italic", "file", "4", ("regular", "italic"))
rcof `"noi mata: totest.allowed_arg_err("topbar", "italic", "bold", "file", "4", ("regular", "italic"))"' == 198
noi mata : totest.allowed_arg_err("topbar", "hline", ("top","bottom"), "file", "4", ("bottom", "top"))
noi mata : totest.allowed_arg_err("topbar", "hline", tokens("top bottom"), "file", "4", ("bottom", "top"))
rcof `"noi mata : totest.allowed_arg_err("topbar", "hline", tokens("top middle bottom"), "file", "4", ("bottom", "top"))"' == 198
exit
//p_font()
mata:
totest = smclpres()
totest.p_font("toc","secfont", "bold", "file", "4")
assert(totest.settings.toc.secfont=="bold")
totest.p_font("toc","secfont", "italic", "file", "4")
assert(totest.settings.toc.secfont=="italic")
totest.p_font("toc","secfont", "regular", "file", "4")
assert(totest.settings.toc.secfont=="regular")
totest.p_font("toc","subsecfont", "bold", "file", "4")
assert(totest.settings.toc.subsecfont=="bold")
totest.p_font("toc","subsecfont", "italic", "file", "4")
assert(totest.settings.toc.subsecfont=="italic")
totest.p_font("toc","subsecfont", "regular", "file", "4")
assert(totest.settings.toc.subsecfont=="regular")
totest.p_font("toc","subsubsecfont", "bold", "file", "4")
assert(totest.settings.toc.subsubsecfont=="bold")
totest.p_font("toc","subsubsecfont", "italic", "file", "4")
assert(totest.settings.toc.subsubsecfont=="italic")
totest.p_font("toc","subsubsecfont", "regular", "file", "4")
assert(totest.settings.toc.subsubsecfont=="regular")
totest.p_font("toc","subsubsubsecfont", "bold", "file", "4")
assert(totest.settings.toc.subsubsubsecfont=="bold")
totest.p_font("toc","subsubsubsecfont", "italic", "file", "4")
assert(totest.settings.toc.subsubsubsecfont=="italic")
totest.p_font("toc","subsubsubsecfont", "regular", "file", "4")
assert(totest.settings.toc.subsubsubsecfont=="regular")
totest.p_font("toc","subtitlefont", "bold", "file", "4")
assert(totest.settings.toc.subtitlefont=="bold")
totest.p_font("toc","subtitlefont", "italic", "file", "4")
assert(totest.settings.toc.subtitlefont=="italic")
totest.p_font("toc","subtitlefont", "regular", "file", "4")
assert(totest.settings.toc.subtitlefont=="regular")

totest.p_font("title", "font", "bold", "file", "4")
assert(totest.settings.title.font == "bold")
totest.p_font("title", "font", "italic", "file", "4")
assert(totest.settings.title.font == "italic")
totest.p_font("title", "font", "regular", "file", "4")
assert(totest.settings.title.font == "regular")

totest.p_font("topbar", "secfont", "bold", "file", "4")
assert(totest.settings.topbar.secfont == "bold")
totest.p_font("topbar", "secfont", "italic", "file", "4")
assert(totest.settings.topbar.secfont == "italic")
totest.p_font("topbar", "secfont", "regular", "file", "4")
assert(totest.settings.topbar.secfont == "regular")
totest.p_font("topbar", "subsecfont", "bold", "file", "4")
assert(totest.settings.topbar.subsecfont == "bold")
totest.p_font("topbar", "subsecfont", "italic", "file", "4")
assert(totest.settings.topbar.subsecfont == "italic")
totest.p_font("topbar", "subsecfont", "regular", "file", "4")
assert(totest.settings.topbar.subsecfont == "regular")
end

// p_font_old()
mata:
totest = smclpres()
totest.p_font_old("toc","secbold", "", "file", "4")
assert(totest.settings.toc.secfont=="bold")
totest.p_font_old("toc","secitalic", "", "file", "4")
assert(totest.settings.toc.secfont=="italic")

totest.p_font_old("toc","subsecbold", "", "file", "4")
assert(totest.settings.toc.subsecfont=="bold")
totest.p_font_old("toc","subsecitalic", "", "file", "4")
assert(totest.settings.toc.subsecfont=="italic")

totest.p_font_old("toc","subsubsecbold", "", "file", "4")
assert(totest.settings.toc.subsubsecfont=="bold")
totest.p_font_old("toc","subsubsecitalic", "", "file", "4")
assert(totest.settings.toc.subsubsecfont=="italic")

totest.p_font_old("toc","subsubsubsecbold", "", "file", "4")
assert(totest.settings.toc.subsubsubsecfont=="bold")
totest.p_font_old("toc","subsubsubsecitalic", "", "file", "4")
assert(totest.settings.toc.subsubsubsecfont=="italic")

totest.p_font_old("toc","nosubtitlebold", "", "file", "4")
assert(totest.settings.toc.subtitlefont=="regular")
totest.p_font_old("toc","subtitleitalic", "", "file", "4")
assert(totest.settings.toc.subtitlefont=="italic")

totest.p_font_old("title", "nobold", "", "file", "4")
assert(totest.settings.title.font == "regular")
totest.p_font_old("title", "italic", "", "file", "4")
assert(totest.settings.title.font == "italic")

totest.p_font_old("topbar", "nosecbold", "", "file", "4")
assert(totest.settings.topbar.secfont == "regular")
totest.p_font_old("topbar", "secitalic", "", "file", "4")
assert(totest.settings.topbar.secfont == "italic")
totest.p_font_old("topbar", "subsecbold", "", "file", "4")
assert(totest.settings.topbar.subsecfont == "bold")
totest.p_font_old("topbar", "subsecitalic", "", "file", "4")
assert(totest.settings.topbar.subsecfont == "italic")
end

// p_pos
mata:
totest = smclpres()
totest.p_pos("bottombar", "next", "left", "file", "4")
assert(totest.settings.bottombar.next == "left")
totest.p_pos("bottombar", "next", "right", "file", "4")
assert(totest.settings.bottombar.next == "right")

totest.p_pos("toc", "subtitlepos", "left", "file", "4")
assert(totest.settings.toc.subtitlepos == "left")

totest.p_pos("title", "pos", "left", "file", "4")
assert(totest.settings.title.pos == "left")
totest.p_pos("title", "pos", "center", "file", "4")
assert(totest.settings.title.pos == "center")

totest.p_pos("title", "left", "", "file", "4")
assert(totest.settings.title.pos == "left")
totest.p_pos("title", "center", "", "file", "4")
assert(totest.settings.title.pos == "center")
end

//p_hline
mata:
totest = smclpres()
totest.p_hline("toc", "secthline", "", "file", "4")
assert(totest.settings.toc.secthline=="hline")
totest.p_hline("toc", "secbhline", "", "file", "4")
assert(totest.settings.toc.secbhline=="hline")

totest.p_hline("toc", "nosubtitlethline", "", "file", "4")
assert(totest.settings.toc.subtitlethline=="nohline")
totest.p_hline("toc", "nosubtitlebhline", "", "file", "4")
assert(totest.settings.toc.subtitlebhline=="nohline")

totest.p_hline("title", "thline", "", "file", "4")
assert(totest.settings.title.thline=="hline")
totest.p_hline("title", "bhline", "", "file", "4")
assert(totest.settings.title.bhline=="hline")

totest.p_hline("topbar", "nothline", "", "file", "4")
assert(totest.settings.topbar.thline=="nohline")
totest.p_hline("topbar", "nobhline", "", "file", "4")
assert(totest.settings.topbar.bhline=="nohline")

totest.p_hline("bottombar", "nothline", "", "file", "4")
assert(totest.settings.bottombar.thline=="nohline")
totest.p_hline("bottombar", "nobhline", "", "file", "4")
assert(totest.settings.bottombar.bhline=="nohline")
end

//p_toc_sub_sub()
mata:
totest = smclpres()
totest.p_toc_sec_sub_sub("toc", "link", "section", "file", "4")
assert(totest.settings.toc.link == "section")
totest.p_toc_sec_sub_sub("toc", "link", "subsection", "file", "4")
assert(totest.settings.toc.link == "subsection")
totest.p_toc_sec_sub_sub("toc", "link", "subsubsection", "file", "4")
assert(totest.settings.toc.link == "subsubsection")

totest.p_toc_sec_sub_sub("toc", "title", "notitle", "file", "4")
assert(totest.settings.toc.title == "notitle")
totest.p_toc_sec_sub_sub("toc", "title", "subsection", "file", "4")
assert(totest.settings.toc.title == "subsection")
assert(totest.settings.topbar.subsec == "nosubsec")
totest.p_toc_sec_sub_sub("toc", "title", "subsubsection", "file", "4")
assert(totest.settings.toc.title == "subsubsection")
end

//p_toc_itemize
mata:
totest = smclpres()
totest.p_toc_itemize("toc","itemize", "", "file", "4")
assert(totest.settings.toc.itemize == "itemize")
end

// p_toc_name
mata:
totest = smclpres()
totest.p_toc_name("toc", "anc", "extra", "file", "4")
assert(totest.settings.toc.anc == "extra")
totest.p_toc_name("toc", "subtitle", "presentatie", "", "4")
assert(totest.settings.toc.subtitle == "presentatie")
end

// changemarkname()
mata:
totest = smclpres()
totest.changemarkname("do", "kwak", "file", "4")
assert(totest.settings.tocfiles.markname[2,2] == "kwak")
end

//p_tocfiles_name()
mata:
totest = smclpres()
totest.p_tocfiles_name("tocfiles", "exname", "voorbeeld", "file", "4")
assert(totest.settings.tocfiles.markname[1,2] == "voorbeeld")
totest.p_tocfiles_name("tocfiles", "doname", "do bestand", "file", "4")
assert(totest.settings.tocfiles.markname[2,2] == "do bestand")
totest.p_tocfiles_name("tocfiles", "name", "voorbeeld", "file", "4")
assert(totest.settings.tocfiles.name == "voorbeeld")
totest.p_tocfiles_name("tocfiles", "where", "voorbeeld", "file", "4")
assert(totest.settings.tocfiles.where == "voorbeeld")
end

// p_tocfiles_howdisplay() p_tocfiles_howdisplay_default()
mata:
totest = smclpres()
totest.p_tocfiles_howdisplay("tocfiles", "doedit", ".do .mata .sthlp", "file", "4")
assert(totest.settings.tocfiles.doedit == "do mata sthlp")
totest.p_tocfiles_howdisplay("tocfiles", "view", ".smcl", "file", "4")
assert(totest.settings.tocfiles.view == "smcl")
totest.p_tocfiles_howdisplay_default()
assert(totest.settings.tocfiles.doedit == "do mata sthlp ado dct class scheme style")
assert(totest.settings.tocfiles.view == "smcl log hlp")
end

//p_tocfiles_customname()
mata:
totest = smclpres()
totest.p_tocfiles_customname("tocfiles", "customname", "foo bar blup; boo boooo", "file", "4")
assert(totest.settings.tocfiles.markname[|16,1 \ 17,2|] == ("foo", " bar blup" \ "boo", " boooo"))
end

//p_tocfiles_p2()
mata:
totest = smclpres()
totest.p_tocfiles_p2("tocfiles", "p2", "4 24 25 1", "file", "4")
assert(totest.settings.tocfiles.p2 == "4 24 25 1")
end

//p_toc_nodigr() p_tocfiles_on_off()
mata:
totest = smclpres()
totest.p_toc_nodigr("toc", "nodigr", "", "file", "4")
assert(totest.settings.toc.nodigr == "nodigr")
totest.p_tocfiles_on_off("tocfiles", "on", "", "file", "4")
assert(totest.settings.tocfiles.on == "on")
totest.p_tocfiles_on_off("tocfiles", "off", "", "file", "4")
assert(totest.settings.tocfiles.on == "off")
end

// p_digr() p_ex()
mata:
totest = smclpres()
totest.p_digr("digress", "name", "blup", "file", "4")
assert(totest.settings.digress.name == "blup")
totest.p_digr("digress", "prefix", "-->", "file", "4")
assert(totest.settings.digress.prefix == "-->")
totest.p_ex("example", "name", "voorbeeld", "file", "4")
assert(totest.settings.example.name == "voorbeeld")
end

//p_topbar_sep() p_topbar_nosubsec() p_topbar_on_off()
mata:
totest = smclpres()
totest.p_topbar_sep("topbar", "sep", " | ", "file", "4")
assert(totest.settings.topbar.sep == " | ")
totest.p_topbar_nosubsec("topbar", "nosubsec", "", "file", "4")
assert(totest.settings.topbar.subsec == "nosubsec")
totest.p_topbar_on_off("topbar", "on", "", "file", "4")
assert(totest.settings.topbar.on == "on")
totest.p_topbar_on_off("topbar", "off", "", "file", "4")
assert(totest.settings.topbar.on == "off")
end

// p_bottombar_arrow_label()
mata:
totest = smclpres()
totest.p_bottombar_arrow_label("bottombar", "arrow", "", "file", "1")
assert(totest.settings.bottombar.arrow == "arrow")
totest.p_bottombar_arrow_label("bottombar", "label", "", "file", "1")
assert(totest.settings.bottombar.arrow == "label")
totest.p_bottombar_arrow_label("bottombar", "toc", "", "file", "1")
assert(totest.settings.bottombar.toc == "toc")
end

// p_bottombar_name()
mata:
totest = smclpres()
totest.p_bottombar_name("bottombar", "index", "bla", "file", "1")
assert(totest.settings.bottombar.index == "bla")

totest.p_bottombar_name("bottombar", "nextname", "bla", "file", "1")
assert(totest.settings.bottombar.nextname == "bla")

// tpage is not documented, and is also not used
// it is the label for the title page
// The label of a page is used when not using arrows but labels in the bottombar to link to the next page
// Since with label we only link forwards, the label for the titlepage is never used
// this is only added for when I want to also to link to the previous page when linking via labels
totest.p_bottombar_name("bottombar", "tpage", "bla", "file", "1")
assert(totest.settings.bottombar.tpage == "bla")
end

//p_tab
mata:
totest = smclpres()
totest.p_tab("tabs", "spaces", "5", "file", "1")
assert(totest.settings.other.tab == 5)
end

// p_bib_file
local using "bench/incl_main.do"
local replace "replace"

mata:
totest = smclpres()
totest.parsedirs()
totest.p_bib_file("bib","bibfile", "incl_main.do", "file", "1")

assert(ustrlower(pathjoin(pwd(), "bench\incl_main.do")) == ustrlower(totest.bib.bibfile))
assert(ustrlower(totest.bib.bibfile) == ustrlower(pathjoin(pwd(), "bench\incl_main.do")))

totest.p_bib_file("bib","stylefile", "incl_main.do", "file", "1")
assert(ustrlower(totest.bib.stylefile) == ustrlower(pathjoin(pwd(),"bench\incl_main.do")))
end

// p_bib_opt()
mata:
totest = smclpres()
totest.p_bib_opt("bib", "and", "en", "file", "4")
assert(totest.bib.and == "en")
totest.p_bib_opt("bib", "authorstyle", "last first", "file", "4")
assert(totest.bib.authorstyle == "last first")
totest.p_bib_opt("bib", "write", "all", "file", "4")
assert(totest.bib.write=="all")
end

// extract_args()
mata:
totest = smclpres()
true = "foo", "" \
       "bar", "" \
       "bla", "5" \
       "blup", "a b c "
assert(totest.extract_args("foo bar bla(5) blup(a b c )") == true)
end

// p_layout()
mata:
totest = smclpres()
totest.p_layout("bib", "and", "en", "file", "4")
assert(totest.bib.and == "en")
end

//parse_args()
mata:
totest = smclpres()
totest.parse_args("bib", "and(en) write(all)", "file", 4 )
assert(totest.bib.and == "en")
assert(totest.bib.write=="all")
end
