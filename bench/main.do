cscript
local drive c
cd "`drive':\mijn documenten\projecten\stata\smclpres"
run smclpres_main.mata

do bench/read.do 