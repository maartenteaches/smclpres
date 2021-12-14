mata:
struct strtoc {
	string              scalar    link
	string              scalar    title
	string              scalar    itemize
	string              scalar    subtitlepos
	string              scalar    subtitlebf
	string              scalar    subtitleit
	string              scalar    subtitlethline
	string              scalar    subtitlebhline
	string              scalar    subtitle
	string              scalar    anc
	string              scalar    secthline
	string              scalar    secbhline
	string              scalar    secbf
	string              scalar    secit
	string              scalar    subsecbf
	string              scalar    subsecit
	string              scalar    subsubsecbf
	string              scalar    subsubsecit
	string              scalar    subsubsubsecbf
	string              scalar    subsubsubsecit
	string              scalar    nodigr
}
struct strtocfiles {
	string              scalar    on        
	string              scalar    name      
	string              scalar    where  
	string              scalar    exname
	string              matrix    markname
	string              scalar    doedit
    string              scalar    view
	string              scalar    gruse     
	string              scalar    euse      
	string              scalar    use       
	string              scalar    p2        
}
struct strdigress {
	string              scalar    name  
	string              scalar    prefix
}
struct strexample {
	string              scalar    name
}
struct strtopbar {
	string              scalar    on          
	string              scalar    thline      
	string              scalar    bhline      
	string              scalar    subsec      
	string              scalar    secbf       
	string              scalar    secit       
	string              scalar    subsecbf    
	string              scalar    subsecit    
	string              scalar    sep         	
}
struct strbottombar {
	string              scalar    thline   
	string              scalar    bhline   
	string              scalar    arrow    
	string              scalar    index    
	string              scalar    nextname 
	string              scalar    next     
	string              scalar    tpage    
	string              scalar    toc
}
struct strtitle {
	string              scalar    thline    
	string              scalar    bhline    
	string              scalar    pos       
	string              scalar    bold      
	string              scalar    italic    
}
struct strother {
	real                rowvector regslides
	real                rowvector allslides
	string              scalar    index
	real                scalar    titlepage
	string              scalar    stub
	string              scalar    source
	string              scalar    sourcedir
	string              scalar    destdir
	string              scalar    olddir
	string              scalar    replace
	string              scalar    l1
	string              scalar    l2
	string              scalar    l3
	string              scalar    l4
	real                scalar    tab
}
struct strsettings {
	struct strtoc       scalar    toc
	struct strtocfiles  scalar    tocfiles
	struct strdigress   scalar    digress
	struct strexample   scalar    example
	struct strtopbar    scalar    topbar
	struct strbottombar scalar    bottombar
	struct strtitle     scalar    title
	struct strother     scalar    other
}
struct strslide {
	string              scalar    type 
	string              scalar    title
	string              scalar    section
	string              scalar    subsection
	string              scalar    label
	real                scalar    prev
	real                scalar    forw         
}
struct strbib {
	class AssociativeArray scalar    bibdb
	class AssociativeArray scalar    style
	string                 colvector keys
	string                 scalar    and
	string                 scalar    authorstyle 
	string                 scalar    stylefile
	string                 scalar    bibfile
	real                   scalar    bibslide
	string                 colvector refs
	string                 scalar    write
}

struct strstate {
	real                   scalar    snr  
	real                   scalar    exnr 
	real                   scalar    slideopen 
	real                   scalar    titlepageopen 
	real                   scalar    exopen 
	real                   scalar    txtopen
	real                   scalar    dest
	real                   scalar    exdest
	real                   scalar    rownr
	string                 scalar    line
}
end
