cscript
run smclpres_main.mata

//start slide
mata:
totest = smclpres()
totest.settings.other.destdir = pathjoin(pwd(), "bench")
totest.settings.other.stub = "foo"
unlink("bench/slide2.smcl")
fh = totest.start_slide(2, "")
assert(totest.files.get(fh)=="open")
fclose(fh)
fh = fopen(`"bench/slide2.smcl"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`"{* "' + st_strscalar("c(current_date)") + `"}{...}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/slide2.smcl")

totest = smclpres()
totest.settings.other.destdir = pathjoin(pwd(), "bench")
totest.settings.other.stub = "foo"
unlink("bench/foo.smcl")
fh = totest.start_slide(2, "titlepage")
assert(totest.files.get(fh)=="open")
fclose(fh)
fh = fopen(`"bench/foo.smcl"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`"{* "' + st_strscalar("c(current_date)") + `"}{...}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/foo.smcl")
end

// end_titlepage()
mata:
totest = smclpres()
totest.settings.other.destdir = pathjoin(pwd(), "bench")
totest.settings.other.stub = "foo"
totest.slide = strslide(10)
totest.titleslide = strslide()
totest.titleslide.forw = 2
totest.settings.other.titlepage = 1
totest.settings.other.index = "slide1.smcl"
unlink("bench/foo.smcl")
state = strstate()
state.dest = totest.start_slide(1, "titlepage")
state.slideopen = 1
state.exopen = 0
state.txtopen = 0
state = totest.end_titlepage(state)
assert(totest.files.get(state.dest)=="closed")
fh = fopen(`"bench/foo.smcl"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`"{* "' + st_strscalar("c(current_date)") + `"}{...}"')
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{center:     {view slide1.smcl:index}   {view slide2.smcl:>>}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{* slides }{...}"')
assert(fget(fh)==`"{* foo.smcl }{...}"')
assert(fget(fh)==`"{* index.smcl }{...}"')
assert(fget(fh)==`"{* slide1.smcl }{...}"')
assert(fget(fh)==`"{* slide2.smcl }{...}"')
assert(fget(fh)==`"{* slide3.smcl }{...}"')
assert(fget(fh)==`"{* slide4.smcl }{...}"')
assert(fget(fh)==`"{* slide5.smcl }{...}"')
assert(fget(fh)==`"{* slide6.smcl }{...}"')
assert(fget(fh)==`"{* slide7.smcl }{...}"')
assert(fget(fh)==`"{* slide8.smcl }{...}"')
assert(fget(fh)==`"{* slide9.smcl }{...}"')
assert(fget(fh)==`"{* slide10.smcl }{...}"')
assert(fget(fh)==`"{* bottomstyle arrow }{...}"')
fclose(fh)
unlink("bench/foo.smcl")
end

//start_ex()
mata:
totest = smclpres()
state = strstate()
state.exopen = 0
state.slideopen = 1
state.exnr = 0
state.snr = 5
unlink("bench/start_ex.test")
unlink("bench/slide5ex1.do")
state.dest = totest.sp_fopen("bench/start_ex.test", "w")
totest.settings.other.destdir = pathjoin(pwd(), "bench")
state = totest.start_ex(state)
totest.sp_fcloseall()
assert(state.exnr==1)
assert(state.exopen==1)
assert(state.exname=="slide5ex1")
fh = fopen(`"bench/start_ex.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* ex slide5ex1 }{...}"')
assert(fget(fh)==`"{cmd}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
fh = fopen(`"bench/slide5ex1.do"', "r")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/start_ex.test")
unlink("bench/slide5ex1.do")
end

//end_ex()
mata:
totest = smclpres()
state = strstate()
state.exopen = 0
state.slideopen = 1
state.exnr = 0
state.snr = 5
unlink("bench/start_ex.test")
unlink("bench/slide5ex1.do")
state.dest = totest.sp_fopen("bench/start_ex.test", "w")
totest.settings.other.destdir = pathjoin(pwd(), "bench")
state = totest.start_ex(state)
state = totest.end_ex(state)

//end_ex() should close the example .do file
//so we should be able to open it before we close all open files
assert(state.exopen==0)
fh = fopen(`"bench/slide5ex1.do"', "r")
assert(fget(fh)==J(0,0,""))
fclose(fh)
totest.sp_fcloseall()
fh = fopen(`"bench/start_ex.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* ex slide5ex1 }{...}"')
assert(fget(fh)==`"{cmd}"')
assert(fget(fh)==`"{txt}{...}"')
assert(fget(fh)==`"{pstd}({stata "do slide5ex1.do":{it:click to run}}){p_end}"')
assert(fget(fh)==`""')
assert(fget(fh)==`""')
assert(fget(fh)==`"{* endex }{...}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/start_ex.test")
unlink("bench/slide5ex1.do")
end

//digr_replace()
mata:
totest=smclpres()
state= strstate()
totest.slide = strslide(10)
state.snr=5
state.line = "ia zegt het ezeltje /*digr*/ klim maar op mijn rug"
totest.slide[6].type="digression"
state = totest.digr_replace(state)
assert(state.line == `"ia zegt het ezeltje {* digr <a href="#slide6.smcl">&gt;&gt; digression</a>}{view slide6.smcl:>> digression}{* /digr} klim maar op mijn rug"')
end

// write_db()
mata:
state = strstate()
state.line = `"//db bla read.do "stuff""'
state.exopen = 0
state.slideopen = 1
state.txtopen = 1
unlink("bench/test/bla.dlg")
unlink("bench/test/read.do")
totest = smclpres()
totest.settings.other.sourcedir= pathjoin(pwd(), "bench")
totest.settings.other.destdir= pathjoin(pwd(), "bench/test")
state = totest.write_db(state)
assert(state.line== `"{* dofile read.do }{pstd}{stata "db bla":stuff}{p_end}"')
assert(fileexists("bench/test/bla.dlg"))
assert(fileexists("bench/test/read.do"))
unlink("bench/test/bla.dlg")
unlink("bench/test/read.do")
end

// write_dofiles()
mata:
state=strstate()
state.txtopen = 1
state.exopen = 0
state.slideopen = 1
state.line = `"read.do "bla blup""'
totest=smclpres()
unlink("bench/test/read.do")
totest.settings.other.sourcedir= pathjoin(pwd(), "bench")
totest.settings.other.destdir= pathjoin(pwd(), "bench/test")
state=totest.write_dofiles("//dofile", state)
assert(state.line==`"{* dofile read.do bla blup }{pstd}{stata "doedit read.do":bla blup}{p_end}"')
assert(fileexists("bench/test/read.do"))
unlink("bench/test/read.do")

state=strstate()
state.txtopen = 1
state.exopen = 0
state.slideopen = 1
state.line = `"read.do "bla blup""'
totest=smclpres()
unlink("bench/test/read.do")
totest.settings.other.sourcedir= pathjoin(pwd(), "bench")
totest.settings.other.destdir= pathjoin(pwd(), "bench/test")
state=totest.write_dofiles("//apdofile", state)
assert(state.line==`"{* apdofile read.do bla blup }{pstd}{stata "doedit read.do":bla blup}{p_end}"')
assert(fileexists("bench/test/read.do"))
unlink("bench/test/read.do")

state=strstate()
state.txtopen = 1
state.exopen = 0
state.slideopen = 1
state.line = `"read.do "bla blup""'
totest=smclpres()
unlink("bench/test/read.do")
totest.settings.other.sourcedir= pathjoin(pwd(), "bench")
totest.settings.other.destdir= pathjoin(pwd(), "bench/test")
state=totest.write_dofiles("//codefile", state)
assert(state.line==`"{* codefile read.do bla blup }{pstd}{stata "doedit read.do":bla blup}{p_end}"')
assert(fileexists("bench/test/read.do"))
unlink("bench/test/read.do")

state=strstate()
state.txtopen = 1
state.exopen = 0
state.slideopen = 1
state.line = `"read.do "bla blup""'
totest=smclpres()
unlink("bench/test/read.do")
totest.settings.other.sourcedir= pathjoin(pwd(), "bench")
totest.settings.other.destdir= pathjoin(pwd(), "bench/test")
state=totest.write_dofiles("//apcodefile", state)
assert(state.line==`"{* apcodefile read.do bla blup }{pstd}{stata "doedit read.do":bla blup}{p_end}"')
assert(fileexists("bench/test/read.do"))
unlink("bench/test/read.do")
end

// begin_slide()
mata:
totest = smclpres()
totest.settings.other.destdir = pathjoin(pwd(), "bench")
totest.settings.other.stub = "foo"
totest.slide = strslide(10)
totest.slide[2].section = "foo"
totest.slide[2].subsection = "bar"
totest.slide[2].type = "regular"
unlink("bench/slide2.smcl")
state=strstate()
state.txtopen = 0
state.exopen = 0
state.exnr= 3
state.slideopen = 0
state.snr = 1
state = totest.begin_slide(state)
totest.sp_fclose(state.dest)
fh = fopen(`"bench/slide2.smcl"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`"{* "' + st_strscalar("c(current_date)") + `"}{...}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:foo} {hline 2} bar{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
assert(state.snr==2)
assert(state.slideopen==1)
assert(state.exnr==0)
unlink("bench/slide2.smcl")
end

// end_slide()
mata:
totest = smclpres()
totest.settings.other.destdir = pathjoin(pwd(), "bench")
totest.settings.other.stub = "foo"
totest.slide = strslide(10)
totest.slide[2].section = "foo"
totest.slide[2].subsection = "bar"
totest.slide[2].type = "regular"
totest.slide[2].forw = 3
totest.slide[2].prev = 1
totest.settings.other.index = "foo.smcl"
unlink("bench/slide2.smcl")
state=strstate()
state.txtopen = 0
state.exopen = 0
state.exnr= 3
state.slideopen = 0
state.snr = 1
state = totest.begin_slide(state)
state = totest.end_slide(state)
fh = fopen(`"bench/slide2.smcl"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`"{* "' + st_strscalar("c(current_date)") + `"}{...}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:foo} {hline 2} bar{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{center:{view slide1.smcl:<<}   {view foo.smcl:index}   {view slide3.smcl:>>}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
assert(state.slideopen==0)
unlink("bench/slide2.smcl")
end

// slideopen noslideopen txtopen notxtopen exopen
mata:
totest = smclpres()
state = strstate()
state.slideopen = 0 
state.titlepageopen = 0
state.rownr = 2
sourcemat = "bla bla" , "file.do", "1" \
            "blup"    , "file.do", "2"
totest.source = sourcemat 
totest.rows_source = 2  
end
rcof `"noisily  mata: totest.noslideopen(state, "example")"' == 198
mata: totest.slideopen(state, "example")


mata: state.slideopen = 1
rcof `"noisily  mata: totest.slideopen(state, "example")"' == 198
mata: totest.noslideopen(state, "example")

mata: state.slideopen = 0
mata: state.titlepageopen = 1
rcof `"noisily  mata: totest.slideopen(state, "example")"' == 198
mata: totest.noslideopen(state, "example")

mata: state.txtopen = 0
rcof `"noisily  mata: totest.notxtopen(state, "example")"' == 198
mata: totest.txtopen(state, "example")

mata: state.txtopen = 1
rcof `"noisily  mata: totest.txtopen(state, "example")"' == 198
mata: totest.notxtopen(state, "example")

mata: state.exopen = 1
rcof `"noisily  mata: totest.exopen(state, "example")"' == 198
mata: state.exopen = 0
mata: totest.exopen(state, "example")

// begin_txt end_txt
mata:
totest = smclpres()
state = strstate()
state.txtopen = 0
state.exopen = 0
state.slideopen = 1
state = totest.begin_txt(state)
assert(state.txtopen == 1)
state = totest.end_txt(state)
assert(state.txtopen == 0)
end

// write_oneline_text()
mata:
totest = smclpres()
state = strstate()
state.txtopen = 1
state.slideopen = 1
state.exopen = 0
state.line = "T'as voulu voir Vierzon et on a vu Vierzon"
unlink("bench/write_oneline_text.test")
state.dest = fopen("bench/write_oneline_text.test", "w")
totest.write_oneline_text(state)
fclose(state.dest)
fh = fopen(`"bench/write_oneline_text.test"', "r")
assert(fget(fh)==`"T'as voulu voir Vierzon et on a vu Vierzon"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
state = strstate()
state.txtopen = 1
state.slideopen = 1
state.exopen = 0
state.line = "T'as voulu voir /*digr*/ Vierzon et on a vu Vierzon"
state.snr=5
totest.slide = strslide(10)
totest.slide[6].type="digression"
unlink("bench/write_oneline_text.test")
state.dest = fopen("bench/write_oneline_text.test", "w")
totest.write_oneline_text(state)
fclose(state.dest)
fh = fopen(`"bench/write_oneline_text.test"', "r")
assert(fget(fh)==`"T'as voulu voir {* digr <a href="#slide6.smcl">&gt;&gt; digression</a>}{view slide6.smcl:>> digression}{* /digr} Vierzon et on a vu Vierzon"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_oneline_text.test")
end