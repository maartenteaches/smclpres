cscript
local drive d
cd "`drive':\mijn documenten\projecten\stata\smclpres"
do smclpres_build.mata

do bench/read.do 
do bench/toc.do
do bench/parts.do
do bench/slides.do
do bench/bib.do
do bench/presentations.do
