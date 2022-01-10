cscript
run  smclpres_main.mata
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