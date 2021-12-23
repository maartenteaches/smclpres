Readme
======

This .zip file 3 folders:

presentation
------------

This is the folder contains the .smcl presentation. To view this:
o open Stata, 
o use -cd- to change to this directory
o type -view presentation.smcl- 

handout
-------

This contains the .html handout created for this presentation. This 
is particularly useful for quickly looking things up and if you don't 
have Stata installed on your current devise.

source
------

This folder contains the source used to create the presentation. To 
create the presentation from this source:

o open Stata
o Install smclpres by typing -ssc install smclpres-
o use -cd- to change to this directory
o make the presentation by typing 
  -smclpres using presentation.do , dir(../presentation) replace-

