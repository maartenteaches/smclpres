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
assert(allof(strlower(totest.source[.,2]), pwd + "bench\minimalist.do"))
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
J(8,1,pwd + "bench\incl_main.do") \ 
J(15,1,pwd + "bench\incl_child.do") \ 
J(12,1, pwd + "bench\incl_grandchild1.do") \ 
pwd + "bench\incl_child.do" \ 
J(9,1, pwd + "bench\incl_grandchild2.do") \ 
J(11,1, pwd +  "bench\incl_child.do")
assert(strlower(totest.source[.,2]) == true)

true = (2..9, 1, 3..16, 2..13, 18, 1..9, 20..30)'
true = strofreal(true)
assert(totest.source[.,3]==true)

end

// ---------------------------------------------------------------------- sp_fopen & sp_fclose
local using "bench/incl_main.do"
local replace ""
mata:
totest = smclpres()
totest.parsedirs()
fh1 = totest.sp_fopen("bench\incl_main.do", "r")
unlink("bench/test/foo.do")
fh2 = totest.sp_fopen("bench\test\foo.do", "w")

notfound = totest.files.notfound()
for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "open") 
}

fput(fh2, "bla")
fput(fh2, "blup")
totest.sp_fclose(fh2)
fget(fh1)
totest.sp_fclose(fh1)

for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "closed") 
}

end
// no replace 
rcof `"mata: fh2 = totest.sp_fopen("bench\test\foo.do", "w")"' == 602

// replace
local using "bench/incl_main.do"
local replace "replace"
mata:
totest = smclpres()
totest.parsedirs()
fh2 = totest.sp_fopen("bench\test\foo.do", "w")
totest.sp_fclose(fh2)
end

// sp_fcloseall
local using "bench/incl_main.do"
local replace "replace"
mata:
totest = smclpres()
totest.parsedirs()
fh1 = totest.sp_fopen("bench\incl_main.do", "r")
fh2 = totest.sp_fopen("bench\test\foo.do", "w")
for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "open") 
}
totest.sp_fcloseall()
for (val=totest.files.firstval(); val!=notfound; val=totest.files.nextval()) {
    assert(val == "closed") 
}
end

// ------------------------------------------------------------------- version
// parse_version

local using "bench/incl_main.do"
local replace "replace"
mata:
totest = smclpres()
assert(totest.parse_version("4.0.0") == (4,0,0))
assert(totest.parse_version("3.14.0") == (3,14,0))
assert(totest.parse_version("2.3.35") == (2,3,35))
assert(totest.parse_version("4.0.") == (4,0,0))
assert(totest.parse_version("4.0") == (4,0,0))
assert(totest.parse_version("4.") == (4,0,0))
assert(totest.parse_version("4") == (4,0,0))

end

// version

local using "bench/incl_main.do"
local replace "replace"

mata:
totest = smclpres()
totest.parsedirs()
totest.read_file()
assert(totest.smclpres_version == (4,0,0))
true = J(9,1,(4,0,0))   \  // incl_main
       J(14,1,(3,1,0))  \  // incl_child
       J(12,1, (2,0,0)) \  // incl_grandchild1
       J(21,1,(3,1,0))     // incl_grandchild2 and incl_child
assert(totest.source_version == true)
end
