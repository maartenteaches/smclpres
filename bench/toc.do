//countslides
local using "bench/minimalist.do"
mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
totest.count_slides()
assert(cols(totest.slide) == 3)
assert(cols(totest.settings.other.regslides) == 3)

totest = smclpres()
sourcemat = "//slide ", "file", "1" \
            "//title foo", "file", "2" \
            "//endlside", "file", "3"
totest.source = sourcemat
totest.rows_source = 3
end
rcof "noisily mata: totest.count_slides()" == 198

mata:
totest = smclpres()
sourcemat = "//digr ", "file", "1" \
            "//title foo", "file", "2" \
            "//edndigr", "file", "3"
totest.source = sourcemat
totest.rows_source = 3
end
rcof "noisily mata: totest.count_slides()" == 198

mata:
totest = smclpres()
sourcemat = "//anc ", "file", "1" \
            "//title foo", "file", "2" \
            "//ednanc", "file", "3"
totest.source = sourcemat
totest.rows_source = 3
end
rcof "noisily mata: totest.count_slides()" == 198

mata:
totest = smclpres()
sourcemat = "//bib ", "file", "1" \
            "//title foo", "file", "2" \
            "//ednbib", "file", "3"
totest.source = sourcemat
totest.rows_source = 3
end
rcof "noisily mata: totest.count_slides()" == 198

mata:
totest = smclpres()
sourcemat = "//slide ", "file", "1" \
            "//title foo", "file", "2" \
            "//endlside", "file", "3" \
            "//slide", "file", "4"
totest.source = sourcemat
totest.rows_source = 4
end
rcof "noisily mata: totest.count_slides()" == 198

mata:
totest = smclpres()
sourcemat = "//digr ", "file", "1" \
            "//title foo", "file", "2" \
            "//edndigr", "file", "3" \
            "//slide", "file", "4"
totest.source = sourcemat
totest.rows_source = 4
end
rcof "noisily mata: totest.count_slides()" == 198

mata:
totest = smclpres()
sourcemat = "//anc ", "file", "1" \
            "//title foo", "file", "2" \
            "//ednanc", "file", "3" \
            "//slide", "file", "4"
totest.source = sourcemat
totest.rows_source = 4
end
rcof "noisily mata: totest.count_slides()" == 198

mata:
totest = smclpres()
sourcemat = "//bib ", "file", "1" \
            "//title foo", "file", "2" \
            "//ednbib", "file", "3" \
            "//slide", "file", "4"
totest.source = sourcemat
totest.rows_source = 4
end
rcof "noisily mata: totest.count_slides()" == 198

//chk_anyopen
mata:
totest = smclpres()
sourcemat = "foo", "file", "1"
totest.source = sourcemat
totest.rows_source = 1
totest.chk_anyopen(0, 0,0,0, 1)
end
rcof "noisily mata: totest.chk_anyopen(1, 0,0,0, 1)" == 198
rcof "noisily mata: totest.chk_anyopen(0, 1,0,0, 1)" == 198
rcof "noisily mata: totest.chk_anyopen(0, 0,1,0, 1)" == 198
rcof "noisily mata: totest.chk_anyopen(0, 0,0,1, 1)" == 198

//chk_slideopen()
mata:
totest = smclpres()
sourcemat = "foo", "file", "1"
totest.source = sourcemat
totest.rows_source = 1
totest.chk_slideopen("slide",0, 0,0,0, 1)
end
rcof `"noisily mata: totest.chk_slideopen("slide", 1, 0,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideopen("slide", 0, 1,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideopen("slide", 0, 0,1,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideopen("slide", 0, 0,0,1, 1)"' == 198

//chk_slideclose()
mata:
totest = smclpres()
sourcemat = "foo", "file", "1"
totest.source = sourcemat
totest.rows_source = 1
totest.chk_slideclose("slide",1, 0,0,0, 1)
totest.chk_slideclose("ancillary slide",0, 1,0,0, 1)
totest.chk_slideclose("digression slide",0, 0,1,0, 1)
totest.chk_slideclose("bibliography slide",0, 0,0,1, 1)
end
rcof `"noisily mata: totest.chk_slideclose("slide", 0, 0,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("slide", 1, 1,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("slide", 1, 0,1,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("slide", 1, 0,0,1, 1)"' == 198

rcof `"noisily mata: totest.chk_slideclose("ancillary slide", 0, 0,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("ancillary slide", 1, 1,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("ancillary slide", 0, 1,1,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("ancillary slide", 0, 1,0,1, 1)"' == 198

rcof `"noisily mata: totest.chk_slideclose("digression slide", 0, 0,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("digression slide", 1, 0,1,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("digression slide", 0, 1,1,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("digression slide", 0, 0,1,1, 1)"' == 198

rcof `"noisily mata: totest.chk_slideclose("bibliography slide", 0, 0,0,0, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("bibliography slide", 1, 0,0,1, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("bibliography slide", 0, 1,0,1, 1)"' == 198
rcof `"noisily mata: totest.chk_slideclose("bibliography slide", 0, 0,1,1, 1)"' == 198

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

//find_structure() with long digression
local using "bench/longdigr.do"
mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
totest.find_structure()

assert(totest.slide[1].type == "regular")
assert(totest.slide[1].prev == .)
assert(totest.slide[1].forw == 4)
assert(totest.slide[1].regprev ==.)
assert(totest.slide[1].cont == "")

assert(totest.slide[2].type == "digression")
assert(totest.slide[2].prev == 1)
assert(totest.slide[2].forw == 3)
assert(totest.slide[2].regprev == .)
assert(totest.slide[2].cont == "")

assert(totest.slide[3].type == "digression")
assert(totest.slide[3].prev == 2)
assert(totest.slide[3].forw == .)
assert(totest.slide[3].regprev == 1)
assert(totest.slide[3].cont == "continue")

assert(totest.slide[4].type == "regular")
assert(totest.slide[4].prev == 1)
assert(totest.slide[4].forw == .)
assert(totest.slide[4].regprev == .)
assert(totest.slide[4].cont == "")

assert(totest.slide[5].type == "ancillary")
assert(totest.slide[5].prev == .)
assert(totest.slide[5].forw == 6)
assert(totest.slide[5].regprev == .)
assert(totest.slide[5].cont == "")

assert(totest.slide[6].type == "ancillary")
assert(totest.slide[6].prev == 5)
assert(totest.slide[6].forw == .)
assert(totest.slide[6].regprev == .)
assert(totest.slide[6].cont == "continue")
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
totest.settings.toc.subtitlefont="italic"
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
totest.settings.toc.subtitlehline.top="nohline"
totest.settings.toc.subtitlehline.bottom="nohline"
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
totest.settings.title.hline.top = "hline"
totest.settings.title.hline.bottom = "hline"
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
totest.settings.title.font = "italic"
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
totest.settings.title.font = "italic"
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
assert(fget(fh)==`"{* tocline }{p 4 5 2}{view slide5.smcl :bla bla}{p_end}"')
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
totest.settings.toc.secfont = "bold"
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
totest.settings.toc.secfont = "bold"
totest.settings.toc.sechline.bottom = "hline"
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
assert(fget(fh)==`"{* tocline }{p 8 9 2}{view slide5.smcl :bla bla}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_subsection.test")

totest = smclpres()
totest.slide = strslide(10)
totest.settings.other.l2 = "{p 8 9 2}"
totest.slide[5].subsection = "bla bla"
totest.settings.toc.subsecfont = "italic"
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


// bold_italic()
mata:
totest = smclpres()
result = totest.bold_italic("bold", "de lucht hangt er laag")
assert(result == "{bf:de lucht hangt er laag}")
result = totest.bold_italic("italic", "de lucht hangt er laag")
assert(result == "{it:de lucht hangt er laag}")
result = totest.bold_italic("regular", "de lucht hangt er laag")
assert(result == "de lucht hangt er laag")
end

// format_toc_line()
mata:
totest = smclpres()
totest.settings.toc.title = "subsection"
totest.settings.toc.subsecfont = "italic"
totest.slide = strslide(10)
totest.slide[5].type = "ancillary"
result = totest.format_toc_line(totest.slide[5].type, "de lucht hangt er laag")
assert(result == "{it:de lucht hangt er laag}")
assert(totest.slide[5].type == "ancillary")
end

// write_toc_title()
mata:
totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.settings.toc.anctitle = "subsubsection"
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
end

mata:
totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.settings.toc.anctitle = "subsubsection"
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
assert(fget(fh)==`"{* tocline }{p 12 12 2}{view slide5.smcl :foo}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
end

mata:
totest = smclpres()
totest.settings.toc.title = "notitle"
totest.settings.toc.anctitle = "subsection"
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
end

mata:
totest = smclpres()
totest.settings.toc.title = "notitle"
totest.settings.toc.anctitle = "subsection"
totest.slide = strslide(10)
totest.slide[5].title = "foo"
totest.slide[5].type = "ancillary"
totest.toc_indent_settings()
unlink("bench/write_toc_title.test")
fh = fopen("bench/write_toc_title.test", "w")
totest.write_toc_title(5,fh)
fclose(fh)
fh = fopen(`"bench/write_toc_title.test"', "r")
assert(fget(fh)==`"{* tocline }{p  8  8 2}{view slide5.smcl :foo} (ancillary){p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.settings.toc.subsubsecfont = "bold"
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
totest.settings.toc.subsubsecfont = "italic"
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
assert(fget(fh)==`"{* tocline }{p  8  8 2}{view slide5.smcl :foo}{p_end}"')
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

// buildfilerow()
mata:
totest = smclpres()
totest.p_tocfiles_howdisplay_default()
assert(totest.buildfilerow("foo.do", "bla bla", "slide4.smcl") == `"{p2col:{stata "doedit foo.do":foo.do}}bla bla; on slide {view slide4.smcl}{p_end}"')
end

//write_toc_files
mata:
sourcemat = "//slide", "file", "1" \
           "line 1", "file", "2" \
           "line 2", "file", "3" \
           "//endslide", "file", "4" \
            "//slide", "file", "5" \
           "line 1", "file", "6" \
           "line 2", "file", "7" \
           "//ex", "file", "8" \
           " sysuse auto, clear", "file", "9" \
           " reg price mpg i.rep78", "file", "10" \
           "//endex", "file", "11" \
           "//endslide", "file", "12" \
            "//slide", "file", "13" \
           " //tocfile do foo.do interesting stuff", "file", "14" \
           "line 1", "file", "15" \
           "line 2", "file", "16" \
           "//endslide", "file", "17" 
totest = smclpres() 
totest.source = sourcemat 
totest.rows_source = 17   
totest.toc_indent_settings()      
unlink("bench/write_toc_files.test")
fh = fopen("bench/write_toc_files.test", "w")
totest.write_toc_files(fh)
fclose(fh)
fh = fopen(`"bench/write_toc_files.test"', "r")
assert(fget(fh)==`"{p2colset 5 25 26 0}{...}"')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{p  4  4 2}Examples{p_end}"')
assert(fget(fh)==`"{p2col:slide2ex1.do}example 1; on slide {view slide2.smcl}{p_end}"')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{p  4  4 2}Do files{p_end}"')
assert(fget(fh)==`"{p2col:foo.do}interesting stuff; on slide {view slide3.smcl}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

sourcemat = "//slide", "file", "1" \
           "line 1", "file", "2" \
           "line 2", "file", "3" \
           "//endslide", "file", "4" \
            "//slide", "file", "5" \
           "line 1", "file", "6" \
           "line 2", "file", "7" \
           "//ex", "file", "8" \
           " sysuse auto, clear", "file", "9" \
           " reg price mpg i.rep78", "file", "10" \
           "//endex", "file", "11" \
           "//endslide", "file", "12" \
            "//slide", "file", "13" \
           " //tocfile do foo.do interesting stuff", "file", "14" \
           "line 1", "file", "15" \
           "line 2", "file", "16" \
           "//endslide", "file", "17" 
totest = smclpres() 
totest.source = sourcemat 
totest.rows_source = 17   
totest.toc_indent_settings()  
totest.settings.toc.secfont = "bold"    
unlink("bench/write_toc_files.test")
fh = fopen("bench/write_toc_files.test", "w")
totest.write_toc_files(fh)
fclose(fh)
fh = fopen(`"bench/write_toc_files.test"', "r")
assert(fget(fh)==`"{p2colset 5 25 26 0}{...}"')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{p  4  4 2}{bf:Examples}{p_end}"')
assert(fget(fh)==`"{p2col:slide2ex1.do}example 1; on slide {view slide2.smcl}{p_end}"')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{p  4  4 2}{bf:Do files}{p_end}"')
assert(fget(fh)==`"{p2col:foo.do}interesting stuff; on slide {view slide3.smcl}{p_end}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_toc_files.test")
end

// write_pres_settings()
mata:
totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.slide = strslide(10)
totest.slide[1].type = "regular"
totest.slide[2].type = "regular"
totest.slide[3].type = "regular"
totest.slide[4].type = "regular"
totest.slide[5].type = "digression"
totest.slide[6].type = "regular"
totest.slide[7].type = "ancillary"
totest.slide[8].type = "regular"
totest.slide[9].type = "regular"
totest.slide[10].type = "bibliography"
totest.toc_indent_settings()
totest.settings.other.stub = "foo"
unlink("bench/write_pres_settings.test")
fh = fopen("bench/write_pres_settings.test", "w")
totest.write_pres_settings(fh)
fclose(fh)
fh = fopen(`"bench/write_pres_settings.test"', "r")
assert(fget(fh)==`"{* slides }{...}"')
assert(fget(fh)==`"{* foo.smcl }{...}"')
assert(fget(fh)==`"{* slide1.smcl }{...}"')
assert(fget(fh)==`"{* slide2.smcl }{...}"')
assert(fget(fh)==`"{* slide3.smcl }{...}"')
assert(fget(fh)==`"{* slide4.smcl }{...}"')
assert(fget(fh)==`"{* slide6.smcl }{...}"')
assert(fget(fh)==`"{* slide8.smcl }{...}"')
assert(fget(fh)==`"{* slide9.smcl }{...}"')
assert(fget(fh)==`"{* slide5.smcl }{...}"')
assert(fget(fh)==`"{* slide7.smcl }{...}"')
assert(fget(fh)==`"{* slide10.smcl }{...}"')
assert(fget(fh)==`"{* bottomstyle arrow }{...}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.settings.toc.title = "subsubsection"
totest.slide = strslide(10)
totest.slide[1].type = "regular"
totest.slide[2].type = "regular"
totest.slide[3].type = "regular"
totest.slide[4].type = "regular"
totest.slide[5].type = "digression"
totest.slide[6].type = "regular"
totest.slide[7].type = "ancillary"
totest.slide[8].type = "regular"
totest.slide[9].type = "regular"
totest.slide[10].type = "bibliography"
totest.toc_indent_settings()
totest.settings.other.stub = "foo"
totest.settings.other.titlepage = 1
unlink("bench/write_pres_settings.test")
fh = fopen("bench/write_pres_settings.test", "w")
totest.write_pres_settings(fh)
fclose(fh)
fh = fopen(`"bench/write_pres_settings.test"', "r")
assert(fget(fh)==`"{* slides }{...}"')
assert(fget(fh)==`"{* foo.smcl }{...}"')
assert(fget(fh)==`"{* index.smcl }{...}"')
assert(fget(fh)==`"{* slide1.smcl }{...}"')
assert(fget(fh)==`"{* slide2.smcl }{...}"')
assert(fget(fh)==`"{* slide3.smcl }{...}"')
assert(fget(fh)==`"{* slide4.smcl }{...}"')
assert(fget(fh)==`"{* slide6.smcl }{...}"')
assert(fget(fh)==`"{* slide8.smcl }{...}"')
assert(fget(fh)==`"{* slide9.smcl }{...}"')
assert(fget(fh)==`"{* slide5.smcl }{...}"')
assert(fget(fh)==`"{* slide7.smcl }{...}"')
assert(fget(fh)==`"{* slide10.smcl }{...}"')
assert(fget(fh)==`"{* bottomstyle arrow }{...}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_pres_settings.test")
end
