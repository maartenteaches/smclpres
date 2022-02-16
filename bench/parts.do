cscript

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

// write_topbar()
mata:
totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].section = "foo"
totest.slide[5].subsection = "bar"
totest.slide[5].type = "regular"
unlink("bench/write_topbar.test")
fh = fopen("bench/write_topbar.test", "w")
totest.write_topbar(fh,5)
fclose(fh)
fh = fopen(`"bench/write_topbar.test"', "r")
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:foo} {hline 2} bar{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_topbar.test")

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].section = "foo"
totest.slide[5].subsection = "bar"
totest.slide[5].type = "regular"
totest.settings.topbar.subsec = "nosubsec"
unlink("bench/write_topbar.test")
fh = fopen("bench/write_topbar.test", "w")
totest.write_topbar(fh,5)
fclose(fh)
fh = fopen(`"bench/write_topbar.test"', "r")
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:foo}{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].section = "foo"
totest.slide[5].subsection = "bar"
totest.slide[5].type = "regular"
totest.settings.topbar.secbf = "bold"
unlink("bench/write_topbar.test")
fh = fopen("bench/write_topbar.test", "w")
totest.write_topbar(fh,5)
fclose(fh)
fh = fopen(`"bench/write_topbar.test"', "r")
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:foo} {hline 2} bar{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].section = "foo"
totest.slide[5].subsection = "bar"
totest.slide[5].type = "regular"
totest.settings.topbar.secbf = "bold"
totest.settings.topbar.subsecit = "italic"
unlink("bench/write_topbar.test")
fh = fopen("bench/write_topbar.test", "w")
totest.write_topbar(fh,5)
fclose(fh)
fh = fopen(`"bench/write_topbar.test"', "r")
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:foo} {hline 2} {it:bar}{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].section = "foo"
totest.slide[5].subsection = "bar"
totest.slide[5].type = "ancillary"
totest.settings.topbar.secbf = "bold"
totest.settings.topbar.subsecit = "italic"
unlink("bench/write_topbar.test")
fh = fopen("bench/write_topbar.test", "w")
totest.write_topbar(fh,5)
fclose(fh)
fh = fopen(`"bench/write_topbar.test"', "r")
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:ancillary}{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].section = "foo"
totest.slide[5].subsection = "bar"
totest.slide[5].type = "digression"
totest.settings.topbar.secbf = "bold"
totest.settings.topbar.subsecit = "italic"
unlink("bench/write_topbar.test")
fh = fopen("bench/write_topbar.test", "w")
totest.write_topbar(fh,5)
fclose(fh)
fh = fopen(`"bench/write_topbar.test"', "r")
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==`"{p}{bf:digression}{p_end}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

// no header for bibliography, 
// usually the header and title would be duplicates
totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].section = "foo"
totest.slide[5].subsection = "bar"
totest.slide[5].type = "bibliography"
totest.settings.topbar.secbf = "bold"
totest.settings.topbar.subsecit = "italic"
unlink("bench/write_topbar.test")
fh = fopen("bench/write_topbar.test", "w")
totest.write_topbar(fh,5)
fclose(fh)
fh = fopen(`"bench/write_topbar.test"', "r")
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_topbar.test")
end

//write_bottombar()
mata:
totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].forw = 7
totest.slide[5].prev = 4
totest.settings.other.stub = "foo"
totest.settings.other.index = "foo.smcl"
unlink("bench/write_bottombar.test")
fh = fopen("bench/write_bottombar.test", "w")
totest.write_bottombar(fh, 5, "regular")
fclose(fh)
fh = fopen(`"bench/write_bottombar.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{center:{view slide4.smcl:<<}   {view foo.smcl:index}   {view slide7.smcl:>>}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.titleslide = strslide()
totest.titleslide.forw = 2
totest.settings.other.titlepage = 1
totest.settings.other.stub = "foo"
totest.settings.other.index = "slide1.smcl"
unlink("bench/write_bottombar.test")
fh = fopen("bench/write_bottombar.test", "w")
totest.write_bottombar(fh, 1, "title")
fclose(fh)
fh = fopen(`"bench/write_bottombar.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{center:     {view slide1.smcl:index}   {view slide2.smcl:>>}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.tocslide = strslide()
totest.tocslide.forw = 2
totest.settings.other.titlepage = 1
totest.settings.other.stub = "foo"
totest.settings.other.index = "slide1.smcl"
unlink("bench/write_bottombar.test")
fh = fopen("bench/write_bottombar.test", "w")
totest.write_bottombar(fh, 1, "toc")
fclose(fh)
fh = fopen(`"bench/write_bottombar.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{center:{view foo.smcl:<<}   {view slide1.smcl:index}   {view slide2.smcl:>>}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].forw = 7
totest.slide[5].prev = 4
totest.settings.other.stub = "foo"
totest.settings.other.index = "foo.smcl"
totest.settings.bottombar.arrow = "label"
unlink("bench/write_bottombar.test")
fh = fopen("bench/write_bottombar.test", "w")
totest.write_bottombar(fh, 5, "regular")
fclose(fh)
fh = fopen(`"bench/write_bottombar.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{view foo.smcl:index}{right:{view slide7.smcl:next}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].forw = 7
totest.slide[5].prev = 4
totest.settings.other.stub = "foo"
totest.settings.other.index = "foo.smcl"
totest.settings.bottombar.arrow = "label"
totest.settings.bottombar.nextname = "volgende"
unlink("bench/write_bottombar.test")
fh = fopen("bench/write_bottombar.test", "w")
totest.write_bottombar(fh, 5, "regular")
fclose(fh)
fh = fopen(`"bench/write_bottombar.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{view foo.smcl:index}{right:{view slide7.smcl:volgende}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)

totest = smclpres()
totest.slide = strslide(10)
totest.slide[5].forw = 7
totest.slide[5].prev = 4
totest.slide[7].label = "erg interessant"
totest.settings.other.stub = "foo"
totest.settings.other.index = "foo.smcl"
totest.settings.bottombar.arrow = "label"
unlink("bench/write_bottombar.test")
fh = fopen("bench/write_bottombar.test", "w")
totest.write_bottombar(fh, 5, "regular")
fclose(fh)
fh = fopen(`"bench/write_bottombar.test"', "r")
assert(fget(fh)==`" "')
assert(fget(fh)==`" "')
assert(fget(fh)==`"{* /p}{hline}"')
assert(fget(fh)==`"{* bottombar }{view foo.smcl:index}{right:{view slide7.smcl:erg interessant}}"')
assert(fget(fh)==`"{hline}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink("bench/write_bottombar.test")
end