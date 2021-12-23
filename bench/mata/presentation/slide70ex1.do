mata:
bib = AssociativeArray()
bib.reinit("string",2)

bib.put(("gould18","author"), "William W. Gould")
bib.put(("gould18","year"), 2018)
bib.put(("gould18","title"), "The Mata Book: A Book for Serious Programmers and Those Who Want to Be")
bib.put(("gould18","publisher"), "Stata Press")
bib.put(("gould18","address"), "College Station, TX")

bib.put(("buis14","author"), "Maarten L. Buis")
bib.put(("buis14","year"), 2014)
bib.put(("buis14","title"), "Stata tip 120: Certifying subroutines")
bib.put(("buis14","journal"), "The Stata Journal")
bib.put(("buis14","volume"), 14)
bib.put(("buis14","number"), 2)
bib.put(("buis14","pages"), "449-450")

bib.get(("gould18","title"))

end
