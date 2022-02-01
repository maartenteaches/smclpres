cscript
run  smclpres_main.mata

//countslides
local using "bench/minimalist.do"
mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
totest.count_slides()
assert(cols(totest.slide) == 3)
assert(cols(totest.settings.other.regslides) == 3)
end

// find_structure()
local using "bench/minimalist.do"
mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
totest.find_structure()

assert(totest.settings.other.regslides == (1, 2, 3))

assert(totest.slide[1].type=="regular")
assert(totest.slide[1].section == "First section")
assert(totest.slide[1].subsection == "First subsection")
assert(totest.slide[1].prev == .)
assert(totest.slide[1].forw==2)
assert(totest.slide[1].title=="First slide")

assert(totest.slide[2].type=="regular")
assert(totest.slide[2].section == "First section")
assert(totest.slide[2].subsection == "Second subsection")
assert(totest.slide[2].prev == 1)
assert(totest.slide[2].forw == 3)
assert(totest.slide[2].title == "Second slide")

assert(totest.slide[3].type == "regular")
assert(totest.slide[3].section == "Second section")
assert(totest.slide[3].subsection == "")
assert(totest.slide[3].prev == 2)
assert(totest.slide[3].forw == .)
assert(totest.slide[3].title == "Third slide")

assert(totest.tocslide.forw == 1)
assert(totest.settings.other.index == "minimalist.smcl")
assert(totest.titleslide.forw == 1)
end

// write_title()
mata:
totest = smclpres()
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh)
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "")
assert(fget(fh) == "{center:{bf:an interesting title}}")
assert(fget(fh) == "")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh, "multiline")
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "{center:{bf:an interesting title}}")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.title.bhline = "hline"
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh)
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "")
assert(fget(fh) == "{center:{bf:an interesting title}}")
assert(fget(fh) == "{hline}")
assert(fget(fh) == "")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.title.bhline = "hline"
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh, "multiline")
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "{center:{bf:an interesting title}}")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.title.thline = "hline"
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh)
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "")
assert(fget(fh) == "{hline}")
assert(fget(fh) == "{center:{bf:an interesting title}}")
assert(fget(fh) == "")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.title.thline = "hline"
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh, "multiline")
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "{center:{bf:an interesting title}}")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.title.pos = "left"
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh)
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "")
assert(fget(fh) == "{p}{bf:an interesting title}{p_end}")
assert(fget(fh) == "")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.title.bold = "regular"
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh)
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "")
assert(fget(fh) == "{center:an interesting title}")
assert(fget(fh) == "")
assert(fget(fh) == J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.title.italic = "italic"
totest.settings.title.bold = "regular"
unlink("bench/write_title.test")
fh = fopen("bench/write_title.test", "w")
totest.write_title("an interesting title", fh)
fclose(fh)
fh = fopen("bench/write_title.test", "r")
assert(fget(fh) == "")
assert(fget(fh) == "{center:{it:an interesting title}}")
assert(fget(fh) == "")
assert(fget(fh) == J(0,0,""))
fclose(fh)
unlink("bench/write_title.test")
end

//write_toc_subtitle()
mata:
totest = smclpres()
unlink("bench/write_toc_subtitle.test")
fh = fopen("bench/write_toc_subtitle.test", "w")
totest.write_toc_subtitle("slides", fh)
fclose(fh)
fh = fopen("bench/write_toc_subtitle.test", "r")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="{hline}")
assert(fget(fh)=="{center:{bf:Slide table of contents}}")
assert(fget(fh)=="{hline}")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subtitle.test")

totest = smclpres()
unlink("bench/write_toc_subtitle.test")
fh = fopen("bench/write_toc_subtitle.test", "w")
totest.write_toc_subtitle("files", fh)
fclose(fh)
fh = fopen("bench/write_toc_subtitle.test", "r")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="{hline}")
assert(fget(fh)=="{center:{bf:Supporting materials}}")
assert(fget(fh)=="{hline}")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subtitle.test")

totest = smclpres()
totest.settings.toc.subtitlebf="regular"
totest.settings.toc.subtitleit="italic"
unlink("bench/write_toc_subtitle.test")
fh = fopen("bench/write_toc_subtitle.test", "w")
totest.write_toc_subtitle("slides", fh)
fclose(fh)
fh = fopen("bench/write_toc_subtitle.test", "r")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="{hline}")
assert(fget(fh)=="{center:{it:Slide table of contents}}")
assert(fget(fh)=="{hline}")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subtitle.test")

totest = smclpres()
totest.settings.toc.subtitlethline="nohline"
totest.settings.toc.subtitlebhline="nohline"
unlink("bench/write_toc_subtitle.test")
fh = fopen("bench/write_toc_subtitle.test", "w")
totest.write_toc_subtitle("slides", fh)
fclose(fh)
fh = fopen("bench/write_toc_subtitle.test", "r")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="{center:{bf:Slide table of contents}}")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subtitle.test")

totest = smclpres()
totest.settings.toc.subtitlepos="left"
unlink("bench/write_toc_subtitle.test")
fh = fopen("bench/write_toc_subtitle.test", "w")
totest.write_toc_subtitle("slides", fh)
fclose(fh)
fh = fopen("bench/write_toc_subtitle.test", "r")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="")
assert(fget(fh)=="{hline}")
assert(fget(fh)=="{p}{bf:Slide table of contents}{p_end}")
assert(fget(fh)=="{hline}")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subtitle.test")
end

//write_toc_top
mata:
sourcemat = "//toctitle foo bar", "file", "1"
totest = smclpres()
totest.source = sourcemat
totest.rows_source = 1
unlink("bench/write_toc_top.test")
fh = fopen("bench/write_toc_top.test", "w")
totest.write_toc_top(fh)
fclose(fh)
fh = fopen("bench/write_toc_top.test", "r")
assert(fget(fh)== "{smcl}")
assert(fget(fh)=="")
assert(fget(fh)=="{center:{bf:foo bar}}")
assert(fget(fh)=="")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_top.test")

sourcemat = "/*toctitle", "file", "1" \
           "line 1", "file", "2" \
           "line 2", "file", "3" \
           "toctitle*/", "file", "4"
totest = smclpres() 
totest.source = sourcemat 
totest.rows_source = 4         
unlink("bench/write_toc_top.test")
fh = fopen("bench/write_toc_top.test", "w")
totest.write_toc_top(fh)
fclose(fh)
fh = fopen(`"bench/write_toc_top.test"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`""')
assert(fget(fh)==`"{center:{bf:line 1}}"')
assert(fget(fh)==`"{center:{bf:line 2}}"')
assert(fget(fh)==`""')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_top.test")

sourcemat = "/*toctitle", "file", "1" \
           "line 1", "file", "2" \
           "line 2", "file", "3" \
           "toctitle*/", "file", "4"
totest = smclpres() 
totest.source = sourcemat 
totest.rows_source = 4         
totest.settings.title.thline = "hline"
totest.settings.title.bhline = "hline"
unlink("bench/write_toc_top.test")
fh = fopen("bench/write_toc_top.test", "w")
totest.write_toc_top(fh)
fclose(fh)
fh = fopen(`"bench/write_toc_top.test"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`""')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{center:{bf:line 1}}"')
assert(fget(fh)==`"{center:{bf:line 2}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`""')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_top.test")

sourcemat = "/*toctitle", "file", "1" \
           "line 1", "file", "2" \
           "line 2", "file", "3" \
           "toctitle*/", "file", "4"
totest = smclpres() 
totest.source = sourcemat 
totest.rows_source = 4         
totest.settings.title.bold = "regular"
totest.settings.title.italic = "italic"
unlink("bench/write_toc_top.test")
fh = fopen("bench/write_toc_top.test", "w")
totest.write_toc_top(fh)
fclose(fh)
fh = fopen(`"bench/write_toc_top.test"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`""')
assert(fget(fh)==`"{center:{it:line 1}}"')
assert(fget(fh)==`"{center:{it:line 2}}"')
assert(fget(fh)==`""')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_top.test")

sourcemat = "//toctitle foo bar", "file", "1" \
            "/*toctxt", "file", "2" \
            "{pstd}", "file", "3" \
           "line 1", "file", "4" \
           "line 2", "file", "5" \
           "toctxt*/", "file", "6" 
           
totest = smclpres() 
totest.source = sourcemat 
totest.rows_source = 6         
totest.settings.title.bold = "regular"
totest.settings.title.italic = "italic"
unlink("bench/write_toc_top.test")
fh = fopen("bench/write_toc_top.test", "w")
totest.write_toc_top(fh)
fclose(fh)

fh = fopen(`"bench/write_toc_top.test"', "r")
assert(fget(fh)==`"{smcl}"')
assert(fget(fh)==`""')
assert(fget(fh)==`"{center:{it:foo bar}}"')
assert(fget(fh)==`""')
assert(fget(fh)==`"{pstd}"')
assert(fget(fh)==`"line 1"')
assert(fget(fh)==`"line 2"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_top.test")
end

//write_toc_section()
mata:
totest = smclpres()
totest.slide = strslide(10)
totest.settings.other.l1 = "{p 4 5 2}"
totest.slide[5].section = "bla bla"
unlink("bench/write_toc_section.test")
fh = fopen("bench/write_toc_section.test", "w")
totest.write_toc_section(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_section.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* tocline }{p 4 5 2}{view slide5.smcl : bla bla}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_section.test")

totest = smclpres()
totest.slide = strslide(10)
totest.settings.toc.link = "subsection"
totest.slide[5].section = "bla bla"
totest.settings.other.l1 = "{p 4 5 2}"
fh = fopen("bench/write_toc_section.test", "w")
totest.write_toc_section(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_section.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* tocline }{p 4 5 2}bla bla{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_section.test")

totest = smclpres()
totest.slide = strslide(10)
totest.settings.toc.link = "subsection"
totest.slide[5].section = "bla bla"
totest.settings.other.l1 = "{p 4 5 2}"
totest.settings.toc.secbf = "bold"
fh = fopen("bench/write_toc_section.test", "w")
totest.write_toc_section(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_section.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* tocline }{p 4 5 2}{bf:bla bla}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_section.test")

totest = smclpres()
totest.slide = strslide(10)
totest.settings.toc.link = "subsection"
totest.slide[5].section = "bla bla"
totest.settings.other.l1 = "{p 4 5 2}"
totest.settings.toc.secbf = "bold"
totest.settings.toc.secbhline = "hline"
fh = fopen("bench/write_toc_section.test", "w")
totest.write_toc_section(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_section.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* tocline }{p 4 5 2}{bf:bla bla}{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_section.test")
end

// write_toc_subsection
mata:
totest = smclpres()
totest.slide = strslide(10)
totest.settings.other.l2 = "{p 8 9 2}"
totest.slide[5].subsection = "bla bla"
unlink("bench/write_toc_subsection.test")
fh = fopen("bench/write_toc_subsection.test", "w")
totest.write_toc_subsection(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_subsection.test"', "r")
assert(fget(fh)==`"{* tocline }{p 8 9 2}bla bla{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subsection.test")

totest = smclpres()
totest.slide = strslide(10)
totest.settings.other.l2 = "{p 8 9 2}"
totest.slide[5].subsection = "bla bla"
totest.settings.toc.link = "subsection"
unlink("bench/write_toc_subsection.test")
fh = fopen("bench/write_toc_subsection.test", "w")
totest.write_toc_subsection(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_subsection.test"', "r")
assert(fget(fh)==`"{* tocline }{p 8 9 2}{view slide5.smcl : bla bla}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subsection.test")

totest = smclpres()
totest.slide = strslide(10)
totest.settings.other.l2 = "{p 8 9 2}"
totest.slide[5].subsection = "bla bla"
totest.settings.toc.subsecit = "italic"
unlink("bench/write_toc_subsection.test")
fh = fopen("bench/write_toc_subsection.test", "w")
totest.write_toc_subsection(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_subsection.test"', "r")
assert(fget(fh)==`"{* tocline }{p 8 9 2}{it:bla bla}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subsection.test")
end

// write_toc_title()
mata:
totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "regular"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p 12 12 2}foo{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.settings.toc.link = "subsubsection"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "regular"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p 12 12 2}{view slide5.smcl : foo}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "notitle"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "regular"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "notitle"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "ancillary"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p  8  8 2}{view slide5.smcl : foo} (ancillary){p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.settings.toc.subsubsecbf = "bold"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "regular"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p 12 12 2}{bf:foo}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.settings.toc.subsubsecit = "italic"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "regular"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p 12 12 2}{it:foo}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsection"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "regular"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p  8  8 2}foo{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsection"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "bibliography"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* tocline }{p  8  8 2}{view slide5.smcl : foo}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsection"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "digression"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p 12 12 2}foo{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "digression"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p 16 16 2}foo{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.settings.toc.nodigr = "nodigr"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "digression"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==J(0,0,""))
fclose(fh)

end