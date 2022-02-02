cscript
run  smclpres_main.mata

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