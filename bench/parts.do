cscript
run  smclpres_main.mata

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
end