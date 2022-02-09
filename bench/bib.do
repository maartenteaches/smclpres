cscript
run smclpres_main.mata

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
assert(totest.bib.refs == ("buis01" \  "buis02" \ "cox22"))

end