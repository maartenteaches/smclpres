mata:

void smclpres:: new() {
    defaults()
    source = J(0,3,"")
    option_parse.reinit("string", 2)
    option_parse.notfound(&notallowed())
    option_parse.put(("toc","link"),&p_toc_sec_sub_sub)
    option_parse.put(("toc","title"),&p_toc_sec_sub_sub)
	option_parse.put(("toc","secbold"),&p_toc_font)
	option_parse.put(("toc","secitalic"),&p_toc_font)
	option_parse.put(("toc","subsecbold"),&p_toc_font)
	option_parse.put(("toc","subsecitalic"),&p_toc_font)
	option_parse.put(("toc","subsubsecbold"),&p_toc_font)
	option_parse.put(("toc","subsubsecitalic"),&p_toc_font)
	option_parse.put(("toc","subsubsubsecbold"),&p_toc_font)
	option_parse.put(("toc","subsubsubsecitalic"),&p_toc_font)
	option_parse.put(("toc","subtitlebold"),&p_toc_font)
	option_parse.put(("toc","subtitleitalic"),&p_toc_font)
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
	settings.tocfiles.doedit    = "do ado dct class scheme style"
	settings.tocfiles.view      = "smcl log hlp sthlp"
	settings.tocfiles.gruse     = "gph"
	settings.tocfiles.euse      = "ster"
	settings.tocfiles.use       = "dta"
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
	
	bib.bibdb                   = asarray_create("string",2)
	bib.bibdb.notfound("")
	bib.style                   = asarray_create()
	bib.keys                    = J(0,1,"")
	bib.and                     = "and"
	bib.authorstyle             = "first last"
	bib.refs                    = J(0,1,"")
	bib.write                   = "cited"
}
end