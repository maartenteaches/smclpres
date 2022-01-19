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
end

// still need to look at /*toctitle
// in particular how it deals thline and bhline
