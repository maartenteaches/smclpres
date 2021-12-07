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
smclpres using "bench\minimalist.do", debug dir(bench/test)

local pres sp__presentation_class_instance
mata:
assert(`pres'.settings.other.regslides == (1, 2, 3))

assert(`pres'.slide[1].type=="regular")
assert(`pres'.slide[1].section == "First section")
assert(`pres'.slide[1].subsection == "First subsection")
assert(`pres'.slide[1].prev == .)
assert(`pres'.slide[1].forw==2)
assert(`pres'.slide[1].title=="First slide")

assert(`pres'.slide[2].type=="regular")
assert(`pres'.slide[2].section == "First section")
assert(`pres'.slide[2].subsection == "Second subsection")
assert(`pres'.slide[2].prev == 1)
assert(`pres'.slide[2].forw == 3)
assert(`pres'.slide[2].title == "Second slide")

assert(`pres'.slide[3].type == "regular")
assert(`pres'.slide[3].section == "Second section")
assert(`pres'.slide[3].subsection == "")
assert(`pres'.slide[3].prev == 2)
assert(`pres'.slide[3].forw == .)
assert(`pres'.slide[3].title == "Third slide")

assert(`pres'.tocslide.forw == 1)
assert(`pres'.settings.other.index == "minimalist.smcl")
assert(`pres'.titleslide.forw == 1)
end