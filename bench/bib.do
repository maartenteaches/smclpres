cscript
run smclpres_main.mata

//collect_bib()
mata:
sourcemat = "//bib", "file", "1" \
"//title bibliograph", "file", "2" \
"/*bib", "file", "3" \
"@Article {gould01,", "file", "4" \
"	author = {William W. Gould},", "file", "5" \
"	title = {Statistical software certification},", "file", "6" \
"	journal = {Stata Journal},", "file", "7" \
"	volume = {1},", "file", "8" \
"	number = {1},", "file", "9" \
"	year = {2001},", "file", "10" \
"	pages = {29-50},", "file", "11" \
"}", "file", "12" \
"", "file", "13" \
"@Book {gould18, ", "file", "14" \
"    author = {William W. Gould},", "file", "15" \
"    title = {The Mata Book: A Book for Serious Programmers and Those Who Want to Be},", "file", "16" \
"    publisher = {Stata Press},", "file", "17" \
"    address = {College Station, TX},", "file", "18" \
"    year = {2018},", "file", "19" \
"}", "file", "20" \
"bib*/", "file", "21" \
"//endbib", "file", "22" 

totest = smclpres()
totest.source = sourcemat
totest.rows_source = 22
totest.bib.bibfile = pathjoin(pwd(),"bench/collect_bib.test")
unlink(totest.bib.bibfile)
totest.collect_bib()
fh = fopen(`"bench/collect_bib.test"', "r")
assert(fget(fh)==`"@Article {gould01,"')
assert(fget(fh)==`"       author = {William W. Gould},"')
assert(fget(fh)==`"       title = {Statistical software certification},"')
assert(fget(fh)==`"       journal = {Stata Journal},"')
assert(fget(fh)==`"       volume = {1},"')
assert(fget(fh)==`"       number = {1},"')
assert(fget(fh)==`"       year = {2001},"')
assert(fget(fh)==`"       pages = {29-50},"')
assert(fget(fh)==`"}"')
assert(fget(fh)==`"@Book {gould18, "')
assert(fget(fh)==`"    author = {William W. Gould},"')
assert(fget(fh)==`"    title = {The Mata Book: A Book for Serious Programmers and Those Who Want to Be},"')
assert(fget(fh)==`"    publisher = {Stata Press},"')
assert(fget(fh)==`"    address = {College Station, TX},"')
assert(fget(fh)==`"    year = {2018},"')
assert(fget(fh)==`"}"')
assert(fget(fh)==J(0,0,""))
fclose(fh)
unlink(totest.bib.bibfile)
end

// nbraces
mata:
totest = smclpres()
test = "jkl(sdf[kid{dkdk { {kdkd [ kdep ()})]} ]"
assert(totest.nbrace(test,"[")==2)
assert(totest.nbrace(test,"{")==3)
assert(totest.nbrace(test,"(")==2)
assert(totest.nbrace(test,"]")==2)
assert(totest.nbrace(test,"}")==2)
assert(totest.nbrace(test,")")==2)
end

// stripbraces
mata:
totest=smclpres()
test = "  {bla } "
assert(totest.stripbraces(test) == "bla ")
test = "  {bla {foo}} "
assert(totest.stripbraces(test) == "bla {foo}")
test = " d{bla }"
assert(totest.stripbraces(test)==test)
test = "{bla} d"
assert(totest.stripbraces(test)==test)
end

// stripbrackets
mata:
totest=smclpres()
test = "  [bla ] "
assert(totest.stripbrackets(test) == "bla ")
test = "  [bla [foo]] "
assert(totest.stripbrackets(test) == "bla [foo]")
test = " d[bla ]"
assert(totest.stripbrackets(test)==test)
test = "[bla] d"
assert(totest.stripbrackets(test)==test)
end

//remove_all_braces
mata:
totest=smclpres()
test = "  {bla } "
assert(totest.remove_all_braces(test) == "  bla  ")
test = "  {bla {foo}} "
assert(totest.remove_all_braces(test) == "  bla foo ")
test = " d{bla }"
assert(totest.remove_all_braces(test)==" dbla ")
test = "{bla} d"
assert(totest.remove_all_braces(test)=="bla d")
end

//collect_entries()
mata:
totest = smclpres()
totest.bib.bibfile = "bench/mata/source/mata.bib"
true = "@Article {buis14,author = {Maarten L. Buis},title = {Stata tip 120: Certifying subroutines},journal = {Stata Journal},volume = {14},number = {2},year = {2014},pages = {449-450},}" \
       "@Article {gould01,author = {William W. Gould},title = {Statistical software certification},journal = {Stata Journal},volume = {1},number = {1},year = {2001},pages = {29-50},}" \
       "@Book {gould18, author = {William W. Gould},title = {The Mata Book: A Book for Serious Programmers and Those Who Want to Be},publisher = {Stata Press},address = {College Station, TX},year = {2018},}" \
       "@Book {gould_etal10, author = {William W. Gould and Jeffrey Pitblado and Brian Poi},title = {Maximum Likelihood Estimation with Stata, Fourth Edition},publisher = {Stata Press},address = {College Station, TX},year = {2010},}"
assert(totest.collect_entries() == true)
end

//parse_entry()
mata:
totest = smclpres()
entry = "@Article {buis14,author = {Maarten L. Buis},title = {Stata tip 120: Certifying subroutines},journal = {Stata Journal},volume = {14},number = {2},year = {2014},pages = {449-450},}"
totest.parse_entry(entry)
assert(totest.bib.bibdb.get(("buis14","author")) == "Maarten L. Buis")
assert(totest.bib.bibdb.get(("buis14","title")) == "Stata tip 120: Certifying subroutines")
assert(totest.bib.bibdb.get(("buis14","journal")) == "Stata Journal")
assert(totest.bib.bibdb.get(("buis14","volume")) == "14")
assert(totest.bib.bibdb.get(("buis14","number")) == "2")
assert(totest.bib.bibdb.get(("buis14","pages")) == "449-450")
end

// split_on_and
mata:
totest = smclpres()
authors = "M.L. Buis"
assert(totest.split_on_and(authors)==authors)
authors = "M.L. Buis and N.J. Cox"
assert(totest.split_on_and(authors) == ("M.L. Buis" \ "N.J. Cox"))
authors = "M.L. Buis and N.J. Cox and S. Jenkins"
assert(totest.split_on_and(authors) == ("M.L. Buis" \ "N.J. Cox" \ "S. Jenkins"))
end

// parse_name()
mata:
totest = smclpres()
author = "M.L. Buis"
assert(totest.parse_name(author) == ("M.L.", "Buis"))
author = "Maarten L. Buis"
assert(totest.parse_name(author) == ("Maarten L.", "Buis"))
author = "Buis, Maarten L."
assert(totest.parse_name(author) == ("Maarten L.", "Buis"))
author = "{van Buis}, Maarten L."
assert(totest.parse_name(author) == ("Maarten L.", "van Buis"))

end
exit
//key_not_found
mata:
totest = smclpres()
totest.bib.bibdb.put(("bla", "author"), "blup")
totest.source = "bla", "file", "1"
totest.key_not_found("bla",1)
end
rcof `"noi mata:totest.key_not_found("buis",1)"' == 198

// extract_rawrefs()
mata:
totest = smclpres()
sourcemat = "bla /*cite buis01 buis02*/ blup /*cite cox22*/ blabla", "file", "1"
totest.source = sourcemat
totest.rows_source = 1
assert(totest.extract_rawrefs(1) == ("buis01 buis02" \ "cox22"))
end

// extract_refs()
mata:
totest = smclpres()
sourcemat = "bla /*cite buis01 buis02*/ blup /*cite cox22*/ blabla", "file", "1"
totest.source = sourcemat
totest.rows_source = 1
assert(totest.extract_refs(1) == ("buis01" \  "buis02" \ "cox22"))
end

// collect_refs()
mata:
totest = smclpres()
sourcemat = "/*txt", "file", "1" \
"bla /*cite buis01 buis02*/ blup /*cite cox22*/ blabla", "file", "2" \
"blup /*cite buis02*/ blup blup", "file", "3" \
"txt*/", "file", "4"
totest.source = sourcemat
totest.rows_source = 4
totest.collect_refs() 
assert(totest.bib.refs == ("buis02" \  "buis01" \ "cox22"))

end