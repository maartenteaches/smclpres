cscript
run  smclpres_main.mata

// ----------------------------------- parsedirs()
// absolute path
local using "c:\temp\bla.do"
mata:
pwd = strlower(pwd())

totest = smclpres()
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == "c:\temp\")
assert(strlower(totest.settings.other.source) == "c:\temp\bla.do")
assert(strlower(totest.settings.other.stub) == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd)
assert(strlower(totest.settings.other.replace) == "")
end

// current dir
local using "bla.do"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd)
assert(strlower(totest.settings.other.source) == pwd + "bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd)
assert(strlower(totest.settings.other.replace) == "")
end

// relative path
local using "bench/test/bla.do"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd + "bench\test\")
assert(strlower(totest.settings.other.source) == pwd + "bench\test\bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd)
assert(strlower(totest.settings.other.replace) == "")
end

// dir
local using "bla.do"
local dir "bench/test"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd)
assert(strlower(totest.settings.other.source) == pwd + "bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd + "bench\test\")
assert(strlower(totest.settings.other.replace) == "")
end

// replace
local using "bla.do"
local dir "bench/test"
local replace "replace"
mata :
totest.parsedirs()
assert(strlower(totest.settings.other.sourcedir) == pwd)
assert(strlower(totest.settings.other.source) == pwd + "bla.do")
assert(totest.settings.other.stub == "bla")
assert(strlower(totest.settings.other.olddir) == pwd)
assert(strlower(totest.settings.other.destdir) == pwd + "bench\test\")
assert(strlower(totest.settings.other.replace) == "replace")
end

// -------------------------------------- count_lines()
mata:
assert(totest.count_lines("bench/minimalist.do") == 61)
end

// -------------------------------------- read_file()
//basic, all in one file
local using "bench/minimalist.do"
mata:
totest.parsedirs()
totest.read_file()
assert(rows(totest.source)==60) // there is a single //layout command in minimalist.do
assert(allof(totest.source[.,2], "C:\Mijn documenten\projecten\stata\smclpres\bench\minimalist.do"))
assert(totest.source[.,3]==(strofreal((1..4, 6..61)))')
assert(totest.settings.bottombar.arrow == "label")
end

// include
local using "bench/incl_main.do"
mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
assert(rows(totest.source)==56)

true = 
J(8,1,"C:\Mijn documenten\projecten\stata\smclpres\bench\incl_main.do") \ 
J(15,1, "C:\Mijn documenten\projecten\stata\smclpres\bench\incl_child.do") \ 
J(12,1, "C:\Mijn documenten\projecten\stata\smclpres\bench\incl_grandchild1.do") \ 
"C:\Mijn documenten\projecten\stata\smclpres\bench\incl_child.do" \ 
J(9,1, "C:\Mijn documenten\projecten\stata\smclpres\bench\incl_grandchild2.do") \ 
J(11,1, "C:\Mijn documenten\projecten\stata\smclpres\bench\incl_child.do")
assert(totest.source[.,2] == true)

true = (1..8, 1..15, 1..12, 17, 1..9, 19..29)'
true = strofreal(true)
assert(totest.source[.,3]==true)
end