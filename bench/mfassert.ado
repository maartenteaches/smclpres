*! version 1.0.0 20Jan2021 MLB
program define mfassert
    version 11
    syntax using/
    tempname fh
    di _asis `"fh = fopen(`"`using'"', "r")"'
    file open `fh' using `"`using'"', read
    file read `fh' line
    while r(eof) == 0 {
        di _asis `"assert(fget(fh)==`"`line'"')"'
        file read `fh' line
    }
    di _asis `"assert(fget(fh)==J(0,0,""))"'
    file close `fh'
    di _asis `"fclose(fh)"'

end