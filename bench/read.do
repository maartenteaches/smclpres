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