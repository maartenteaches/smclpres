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