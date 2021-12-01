mata:

void smclpres:: new() {
    defaults()
	files.reinit("real")
    source = J(0,3,"")
	smclpres_version = (4,0,0)
	source_version = J(0,3,.)
}

void smclpres::defaults()
{
    settings.toc.link           = "section"
	settings.toc.title          = "notitle"
	settings.toc.itemize        = "noitemize"
	settings.toc.subtitlepos    = "center"
	settings.toc.subtitlebf     = "bold"
	settings.toc.subtitleit     = "regular"
	settings.toc.subtitlethline = "hline"
	settings.toc.subtitlebhline = "hline"
	settings.toc.subtitle       = "Slide table of contents"
	settings.toc.anc            = "ancillary"
	settings.toc.secthline      = "nohline" 
	settings.toc.secbhline      = "nohline"
	settings.toc.secbf          = "regular"
	settings.toc.secit          = "regular"
	settings.toc.subsecbf       = "regular"
	settings.toc.subsecit       = "regular"
	settings.toc.subsubsecbf    = "regular"
	settings.toc.subsubsecit    = "regular"
	settings.toc.subsubsubsecbf = "regular"
	settings.toc.subsubsubsecit = "regular"
	settings.toc.nodigr         = "digr"

	settings.tocfiles.on        = "off"
	settings.tocfiles.name      = "Supporting materials"
	settings.tocfiles.exname    = "example "
	settings.tocfiles.where     = "; on slide "
	settings.tocfiles.markname  = "ex"    ,"Examples" \
	                              "do"    ,"Do files"  \
	                              "ado"   ,"Ado files" \
	                              "data"  ,"Datasets" \
	                              "class" ,"Classes" \
	                              "style" ,"Styles" \
	                              "graph" ,"Graphs" \
	                              "grec"  ,"Graph editor recordings" \
	                              "irf"   ,"Impulse-response function datasets" \
	                              "mata"  ,"Mata files" \
	                              "bc"    ,"Business calendars" \
	                              "ster"  ,"Saved estimates" \
	                              "trace" ,"Parameter-trace files" \
	                              "sem"   ,"SEM builder files" \
	                              "swm"   ,"Spatial weighting matrices"
	settings.tocfiles.p2        = "5 25 26 0"	
	
	settings.digress.name       = "digression"
	settings.digress.prefix     = ">> "
	
    settings.example.name       = "{it:click to run}"
	
	settings.topbar.on          = "on"
	settings.topbar.thline      = "hline"
	settings.topbar.bhline      = "hline"
	settings.topbar.subsec      = "subsec"
	settings.topbar.secbf       = "bold"
	settings.topbar.secit       = "regular"
	settings.topbar.subsecbf    = "regular"
	settings.topbar.subsecit    = "regular"
	settings.topbar.sep         = " {hline 2} "	
	
	settings.bottombar.thline   = "hline"
	settings.bottombar.bhline   = "hline"
	settings.bottombar.arrow    = "arrow"
	settings.bottombar.index    = "index"
	settings.bottombar.nextname = "next"
	settings.bottombar.next     = "right"
	settings.bottombar.tpage    = "titlepage"
	
	settings.title.thline       = "nohline"
	settings.title.bhline       = "nohline"
	settings.title.pos          = "center"
	settings.title.bold         = "bold"
	settings.title.italic       = "regular"
	
	settings.other.titlepage    = 0
	settings.other.tab          = 4
	
	bib.bibdb.reinit("string",2)
	bib.bibdb.notfound("")
	bib.keys                    = J(0,1,"")
	bib.and                     = "and"
	bib.authorstyle             = "first last"
	bib.refs                    = J(0,1,"")
	bib.write                   = "cited"
}
end
