mata:

void smclpres:: new() {
    defaults()
	files.reinit("real")
    source = J(0,3,"")
	smclpres_version = (4,0,2)
	source_version = J(0,3,.)
}

void smclpres::defaults()
{
    settings.toc.link                  = "section"
	settings.toc.title                 = "notitle"
	settings.toc.itemize               = "noitemize"
	settings.toc.subtitlepos           = "center"
	settings.toc.subtitlefont          = "bold"
	settings.toc.subtitlehline.top     = "hline"
	settings.toc.subtitlehline.bottom  = "hline"
	settings.toc.subtitle              = "Slide table of contents"
	settings.toc.anc                   = "ancillary"
	settings.toc.sechline.top          = "nohline" 
	settings.toc.sechline.bottom       = "nohline"
	settings.toc.secfont               = "regular"
	settings.toc.subsecfont            = "regular"
	settings.toc.subsubsecfont         = "regular"
	settings.toc.subsubsubsecfont      = "regular"
	settings.toc.nodigr                = "digr"

	settings.tocfiles.on               = "off"
	settings.tocfiles.name             = "Supporting materials"
	settings.tocfiles.exname           = "example "
	settings.tocfiles.where            = "; on slide "
	settings.tocfiles.markname         = "ex"    ,"Examples" \
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
	settings.tocfiles.p2              = "5 25 26 0"	
	
	settings.digress.name             = "digression"
	settings.digress.prefix           = ">> "
	
    settings.example.name             = "{it:click to run}"
	
	settings.topbar.on                = "on"
	settings.topbar.hline.top         = "hline"
	settings.topbar.hline.bottom      = "hline"
	settings.topbar.subsec            = "subsec"
	settings.topbar.secfont           = "bold"
	settings.topbar.subsecfont        = "regular"
	settings.topbar.sep               = " {hline 2} "	
	
	settings.bottombar.hline.top      = "hline"
	settings.bottombar.hline.bottom   = "hline"
	settings.bottombar.arrow          = "arrow"
	settings.bottombar.index          = "index"
	settings.bottombar.nextname       = "next"
	settings.bottombar.next           = "right"
	settings.bottombar.tpage          = "titlepage"
	
	settings.title.hline.top          = "nohline"
	settings.title.hline.bottom       = "nohline"
	settings.title.pos                = "center"
	settings.title.font               = "bold"
		
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
