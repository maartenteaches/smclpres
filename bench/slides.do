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