clear all
cd h:\
mata: 
mata set matastrict on

class smclpres {
    string matrix source
    real   scalar count_lines()
    void          read_file()
    real   scalar _read_file()
    void          new()
}

void smclpres:: new() {
    source = J(0,3,"")
}

real scalar smclpres::_read_file(string scalar filename, real scalar lnr) {
    string matrix EOF, toadd
    real scalar fh, i, newlines
    string scalar line
    string rowvector parts 
    
    newlines = count_lines(filename)
    toadd = J(newlines,3,"")
    source = source \ toadd
    fh = fopen(filename, "r")
    i = 0
    
    while ((line=fget(fh))!=EOF) {
        i++
        parts = tokens(line)
        if (cols(parts) > 0) {
            if (parts[1] == "//include") {
                source = source[|1,1 \ rows(source)-1,3|]
                lnr = _read_file(parts[2], lnr)
            }
            else {
                source[lnr  ,1] = line
                source[lnr  ,2] = filename
                source[lnr++,3] = strofreal(i)
            }
        }
        else {
            source[lnr  ,1] = line
            source[lnr  ,2] = filename
            source[lnr++,3] = strofreal(i)            
        }
    }
    fclose(fh)
    return(lnr)
}

void smclpres::read_file(string scalar filename) {
    real scalar i
    i = _read_file(filename,1)
}

real scalar smclpres::count_lines(string scalar filename) {
    string matrix EOF
    real scalar fh, i
    
    fh = fopen(filename, "r")
    EOF = J(0,0,"")
    
    i=0
    while (fget(fh)!=EOF) {
       i++ 
    }
    fclose(fh)
    return(i)
}

foo = smclpres()
foo.read_file("amsterdamsegrachten.txt")
foo.source
end