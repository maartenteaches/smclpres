cd "c:\mijn documenten\projecten\stata\smclpres"
cscript
do smclpres_main.mata

local using "c:\temp\bla.do"
mata:
totest = smclpres()
totest.parsedirs()
end

local using "bla.do"
mata :
totest.parsedirs()
totest.settings.other.sourcedir
totest.settings.other.source
totest.settings.other.stub
end