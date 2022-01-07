cd "D:\Mijn documenten\projecten\stata\smclpres\" 
clear all
version 14.2

mata 
mata clear
mata set matastrict on
end

do smclpres_main.mata

lmbuild lsmclpres, replace
lmbuild lsmclpres, replace dir(.)
