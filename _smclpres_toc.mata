mata:
void smclpres::count_slides() {
	real scalar i, snr, regsl
	string rowvector line

	snr   = 0
	regsl = 0
	for(i=1; i<=rows_source; i++) {
		line = tokens(source[i,1])
		if (cols(line) > 0) {
			if (line[1]=="//endslide") {
				snr = snr + 1
				regsl = regsl + 1
			}
			if (line[1]=="//enddigr"  | line[1]=="//endanc" | line[1]== "//endbib") {
				snr = snr + 1
			}
		}
	}
	settings.other.regslides = J(1,regsl,.)
	slide=strslide(snr)
}

void smclpres::where_err(real scalar rownr)
{
	string scalar errmsg
	errmsg = "{p}{err}This error occured on line " + source[rownr,3] + " in " + source[rownr,2] + "{p_end}"
	printf(errmsg)
}

void smclpres::find_structure() {
	real   scalar snr, regsl, titleopen, rownr
	string scalar section, subsection, err 
	string rowvector left
	transmorphic scalar t

	count_slides()
	
	t = tokeninit(" ")
	snr = 1
	regsl= 1
	titleopen = 0
	for(rownr=1; rownr <=rows_source; rownr++) {
		tokenset(t, source[rownr,1])
		if ((left=tokenget(t)) != "") {
			if (left == "//slide") {
				slide[snr].type       = "regular"
				slide[snr].section    = section
				slide[snr].subsection = subsection
				settings.other.regslides[regsl] = snr
				if (regsl > 1) {
					slide[snr].prev    = settings.other.regslides[regsl-1]
				}
				else if (settings.other.titlepage) {
					slide[snr].prev    = 0
				}
			}
			if (left=="//endslide") {
				if (slide[snr].title == "" ) {
					err = "{p}{err}slide was closed but no title was specified for that slide{p_end}"
					printf(err)
					where_err(rownr)
					exit(198)
				}
				snr = snr + 1
				regsl = regsl + 1
			}
			if (left=="//digr") {
				slide[snr].type       = "digression"
				if (regsl > 1) {
					slide[snr].prev    = settings.other.regslides[regsl-1]
				}
			}
			if (left=="//enddigr") {
				snr = snr + 1
			}
			if (left=="//anc") {
				slide[snr].type       = "ancillary"
			}
			if (left=="//endanc") {
				snr = snr + 1
			}
			if (left == "//titlepage") {
				titleopen = 1
			}
			if (left == "//endtitlepage") {
				titleopen = 0
			}
			if (left == "//bib") {
				slide[snr].type      = "bibliography"
				bib.bibslide         = snr
			}
			if (left == "//endbib") {
				snr = snr + 1
			}
			
			if (left=="//section") {
				section = ustrltrim(tokenrest(t))
				subsection = ""
			}
			if (left=="//subsection") {
				subsection = ustrltrim(tokenrest(t))
			}
			if (left=="//title") {
				if (titleopen) {
					titleslide.title = ustrltrim(tokenrest(t))
				}
				else {
					slide[snr].title = ustrltrim(tokenrest(t))
				}
			}
			if (left=="//label") {
				if (titleopen) {
					titleslide.label = ustrltrim(tokenrest(t))
				}
				else {
					slide[snr].label = ustrltrim(tokenrest(t))
				}
			}
		}
	}
	
	regsl = 1
	for (snr=1 ; snr <=cols(slide) ; snr++) {
		if (slide[snr].type == "regular") {
			regsl = regsl + 1
			if (regsl <= cols(settings.other.regslides)) {
				slide[snr].forw = settings.other.regslides[regsl]
			}
		}
	}
	
	tocslide.forw = settings.other.regslides[1]
	if (settings.other.titlepage) {
		tocslide.prev = 0
		settings.other.index = "index.smcl"
	}
	else {
		settings.other.index = settings.other.stub + ".smcl"
	}
	titleslide.forw = settings.other.regslides[1]
}

void smclpres::write_toc() {
	real scalar dest
	string scalar destfile
	
	if (settings.other.titlepage) {
		destfile = pathjoin(settings.other.destdir , "/index.smcl")
	}
	else {
		destfile = pathjoin(settings.other.destdir,  settings.other.stub + ".smcl")	
	}
	dest = sp_fopen(destfile,"w")

	write_toc_top(dest)
	if (settings.tocfiles.on == "on") {
		write_toc_subtitle("slides", dest)	
	}
	write_toc_slides(dest)
	if (settings.tocfiles.on=="on") {
		write_toc_subtitle("files", dest)
		write_toc_files(dest)
	}
	if (settings.bottombar.toc == "toc") {
		write_bottombar(dest,0,"toc")
	}
	if (settings.other.titlepage == 0) {
		write_pres_settings(pres,dest)
	}
	sp_fclose(dest)
}

void smclpres::write_toc_top(real scalar dest) {
	real   scalar    titleopen, textopen, rownr
	string scalar left
	transmorphic scalar t

	t = tokeninit(" ")	
	titleopen = 0
	textopen  = 0
	fput(dest, "{smcl}")
	for(rownr = 1; rownr <= rows_source; rownr++) {
		tokenset(t, source[rownr,1])
		if ((left=tokenget(t))!= "") {
			if (left == "//toctitle") {
				write_title(ustrltrim(tokenrest(t)), dest)
			}
			else if (left == "/*toctitle") {
				titleopen = 1
				if (settings.title.thline == "hline") {
					fput(dest, "{hline}")
				}
			}
			else if (left == "toctitle*/") {
				titleopen = 0
				if (settings.title.bhline == "hline") {
					fput(dest, "{hline}")
				}
			}
			else if (titleopen) {
				write_title(ustrltrim(tokenrest(t)),dest)
			}
			else if (left == "/*toctxt") {
				textopen = 1
			}
			else if (left == "toctxt*/") {
				textopen = 0
			}
			else if (textopen) {
				fput(dest, source[rownr,1])
			}
		}
		else {
			if ( textopen ) {
				fput(dest, " ")
			}
			if (titleopen) {
				fput(dest, " ")
			}
		}
    }
	if (textopen | titleopen) {
		printf("{p}{err}a /*toctext or /*toctitle was opened but never closed{p_end}")
		exit(198)
	}
}

void smclpres::write_toc_subtitle(string scalar which, real scalar dest) {
	string scalar temp
	
	fput(dest,"")
	fput(dest,"")
	fput(dest,"")
	if (settings.toc.subtitlethline == "hline"){
		fput(dest, "{hline}")
	}
	if (which == "slides") {
		temp = settings.toc.subtitle
	}
	if (which == "files" ) {
		temp = settings.tocfiles.name
	}
	if (settings.toc.subtitlebf == "bold") {
		temp = "{bf:" + temp + "}"
	}
	if (settings.toc.subtitleit == "italic") {
		temp = "{it:" + temp + "}"
	}
	if (settings.toc.subtitlepos == "center") {
		temp = "{center:" + temp + "}"
	}
	else {
		temp = "{p}" + temp + "{p_end}"
	}
	fput(dest, temp)
	if (settings.toc.subtitlebhline == "hline"){
		fput(dest, "{hline}")
	}	
}

void sp_write_toc_slides(real scalar dest) {
	real   scalar snr
	string scalar section, subsection
	
	section    = ""
	subsection = ""
	
	for (snr=1; snr <= cols(pres.slide); snr++ ) {
		if (slide[snr].section != section & slide[snr].type=="regular") {
			section = slide[snr].section
			write_toc_section(snr, dest)
			
		}
		if (slide[snr].subsection != subsection & slide[snr].type=="regular" & 
		    slide[snr].subsection != "") {
			subsection = slide[snr].subsection
			write_toc_subsection(snr, dest)
		}
		write_toc_title(snr, dest)
	}
}

end