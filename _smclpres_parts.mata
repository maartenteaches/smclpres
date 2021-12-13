mata:
void smclpres::write_title( string scalar line, real scalar dest) {
	fput(dest,"")	
	if (settings.title.thline == "hline") {
		fput(dest, "{hline}")
	}
	if (settings.title.bold == "bold") {
		line = "{bf:" + line + "}"
	}
	if (settings.title.italic == "italic" ) {
		line = "{it:" + line + "}"
	}
	if (settings.title.pos == "center") {
		line = "{center:" + line + "}"
	}
	else {
		line = "{p}" + line + "{p_end}"
	}
	fput(dest, line)
	if (settings.title.bhline == "hline") {
		fput(dest, "{hline}")
	}
	fput(dest,"")
}

void smclpres::write_topbar(real scalar dest, real scalar snr) {
	string scalar line, temp
	
	line = ""
	if (!(slide[snr].section == "" &  ( 
	   slide[snr].subsection == "" | 
	   settings.topbar.subsec=="nosubsec")) & 
	   slide[snr].type == "regular") {
		
		line = "{p}"
		temp = slide[snr].section
		if (settings.topbar.secbf == "bold") {
			temp = "{bf:" + temp + "}"
		}
		if (settings.topbar.secit == "italic") {
			temp = "{it:" + temp + "}"
		}
		line = line + temp
		if (slide[snr].subsection != "" & 
		    settings.topbar.subsec=="subsec") {
			temp = slide[snr].subsection
			if (settings.topbar.subsecbf == "bold") {
				temp = "{bf:" + temp + "}"
			}
			if (settings.topbar.subsecit == "italic") {
				temp = "{it:" + temp + "}"
			}	
			line = line + settings.topbar.sep + temp
		}
		line = line + "{p_end}"

	}
	else if (slide[snr].type == "ancillary") {
		line = settings.toc.anc
		if (settings.topbar.secbf == "bold") {
			line = "{bf:" + line + "}"
		}
		if (settings.topbar.secit == "italic") {
			line = "{it:" + line + "}"
		}
		line = "{p}" + line + "{p_end}"
	}
	else if (slide[snr].type == "digression") {
		line = settings.digress.name
		if (settings.topbar.secbf == "bold") {
			line = "{bf:" + line + "}"
		}
		if (settings.topbar.secit == "italic") {
			line = "{it:" + line + "}"
		}
		line = "{p}" + line + "{p_end}"
	}
	if (line != "") {
		if (settings.topbar.thline=="hline") {
			fput(dest, "{hline}")
		}
		fput(dest,line)
		if (settings.topbar.bhline=="hline") {
			fput(dest, "{hline}")
		}	
	}
}

void smclpres::write_bottombar( real scalar dest, 
                     real scalar snr, string scalar special) {
	string scalar line, forw, back, forwl
	
	if (special == "title" ) {
		forw = "slide" + strofreal(titleslide.forw) + ".smcl"
		forwl = slide[titleslide.forw].label
		if (forwl == "") {
			forwl = settings.bottombar.nextname
		}
	}
	else if (special == "toc") {
		if (settings.other.titlepage) {
			back = settings.other.stub + ".smcl"
		}
		forw = "slide" + strofreal(tocslide.forw) + ".smcl"
		forwl = slide[tocslide.forw].label
		if (forwl == "") {
			forwl = settings.bottombar.nextname
		}
	}
	else {
		if (slide[snr].prev==0) {
			back = settings.other.stub + ".smcl"
		}
		else if (slide[snr].prev != .){
			back = "slide" + strofreal(slide[snr].prev) + ".smcl"
		}
		if (slide[snr].forw != .) {
			forw = "slide" + strofreal(slide[snr].forw) + ".smcl"
			forwl = slide[slide[snr].forw].label
			if (forwl == "") {
				forwl = settings.bottombar.nextname
			}
		}
	}
	
	fput(dest, " ")
	fput(dest, " ")
	if (settings.bottombar.thline == "hline") {
		fput(dest,"{* /p}{hline}")
	}
	line = "{* bottombar }"
	if (settings.bottombar.arrow == "arrow") {
		line = line + "{center:"
		if (back == "") {
			line = line + "     "
		}
		else {
			line = line + "{view " + back + ":<<}   "
		}
		line = line + "{view " + settings.other.index + ":" + 
		       settings.bottombar.index + "}"
		if (forw == "") {
			line = line + "     "
		}
		else {
			line = line + "   {view " + forw + ":>>}"
		}
		line = line + "}"
	}
	else {
		if (settings.bottombar.next == "right") {
			line = line + "{view " + settings.other.index + ":" +
			       settings.bottombar.index + "}"
			if (forw != "") {
				line = line + "{right:{view " + forw + ":" + forwl + "}}"
			}
		}
		else {
			if (forw != "") {
				line = line + "{view " + forw + ":" + forwl + "}"
			}
			line = line + "{right:{view " + settings.other.index + ":" +
			       settings.bottombar.index + "}}"
		}
	}
	fput(dest, line)
	if (settings.bottombar.bhline == "hline") {
		fput(dest,"{hline}")
	}	
}

end
