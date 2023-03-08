mata:

void smclpres::chk_slideopen(string scalar what, real scalar sopen, real scalar aopen, 
                             real scalar dopen, real scalar bopen, real scalar where)
{
	if (sopen == 1) {
		printf("{p}{err}Tried openening a " + what +" but a slide was already open{p_end}")
		where_err(where)
		exit(198)
	}
	if (aopen == 1) {
		printf("{p}{err}Tried openening a " + what +" but an ancillary slide was already open{p_end}")
		where_err(where)
		exit(198)
	}
	if (dopen == 1) {
		printf("{p}{err}Tried openening a " + what +" but a digression slide was already open{p_end}")
		where_err(where)
		exit(198)
	}
	if (bopen == 1) {
		printf("{p}{err}Tried openening a " + what +" but a bibliography slide was already open{p_end}")
		where_err(where)
		exit(198)
	}
}							 

void smclpres::chk_slideclose(string scalar what, real scalar sopen, real scalar aopen, 
                             real scalar dopen, real scalar bopen, real scalar where)
{
	if (sopen == 0 & what == "slide") {
		printf("{p}{err}Tried closing a slide but no slide was open{p_end}")
		where_err(where)
		exit(198)
	}
	if (sopen == 1 & what != "slide") {
		printf("{p}{err}Tried closing a " + what + " but a slide was open{p_end}") 
		where_err(where)
		exit(198)
	}
	if (aopen == 0 & what == "ancillary slide") {
		printf("{p}{err}Tried closing a ancillary slide but no ancillary slide was open{p_end}")
		where_err(where)
		exit(198)
	}
	if (aopen == 1 & what != "ancillary slide") {
		printf("{p}{err}Tried closing a " + what + " but a ancillary slide was open{p_end}") 
		where_err(where)
		exit(198)
	}
	if (dopen == 0 & what == "digression slide") {
		printf("{p}{err}Tried closing a digression slide but no digression slide was open{p_end}")
		where_err(where)
		exit(198)
	}
	if (dopen == 1 & what != "digression slide") {
		printf("{p}{err}Tried closing a " + what + " but a digression slide was open{p_end}") 
		where_err(where)
		exit(198)
	}	
	if (bopen == 0 & what == "bibliography slide") {
		printf("{p}{err}Tried closing a bibliography slide but no bibliography slide was open{p_end}")
		where_err(where)
		exit(198)
	}
	if (bopen == 1 & what != "bibliography slide") {
		printf("{p}{err}Tried closing a " + what + " but a bibliography slide was open{p_end}") 
		where_err(where)
		exit(198)
	}	
}

void smclpres::chk_anyopen(real scalar sopen, real scalar aopen, 
                             real scalar dopen, real scalar bopen, real scalar where)
{
	string scalar what 
	real scalar problem
	problem = 0
	if (sopen == 1) {
		what = "a slide"
		problem = 1
	}
	if (aopen == 1) {
		what = "an ancillary slide"
		problem = 1
	}
	if (dopen == 1) {
		what = "a digression slide" 
		problem = 1
	}
	if (bopen == 1) {
		what = "a bibliography slide"
		problem = 1
	}
	if (problem == 1) {
		printf("{p}{err}" + what +" was opened, but never closed{p_end}")
		printf("{p}{err}the unclosed slide was opened on line {res}" + source[where,3] + " {err}in {res}" + source[where,2] + "{p_end}")
		exit(198)
	}
}
void smclpres::count_slides() {
	real scalar i, snr, regsl, sopen, dopen, aopen, bopen, where
	string rowvector line

	snr   = 0
	regsl = 0
	sopen = 0
	dopen = 0
	aopen = 0
	bopen = 0
	for(i=1; i<=rows_source; i++) {
		line = tokens(source[i,1])
		if (cols(line) > 0) {
			if (line[1]== "//slide") {
				chk_slideopen("slide", sopen, aopen, dopen, bopen, i)
				sopen = 1
				where = i
			}
			else if (line[1]== "//anc"){
				chk_slideopen("ancillary slide", sopen, aopen, dopen, bopen, i)
				aopen = 1
				where = i
			}
			else if (line[1]=="//digr") {
				chk_slideopen("digression slide", sopen, aopen, dopen, bopen, i)
				dopen = 1
				where = i
			}
			else if (line[1]=="//bib") {
				chk_slideopen("bibliography slide", sopen, aopen, dopen, bopen, i)
				bopen = 1
				where = i
			}
			else if (line[1]=="//endslide") {
				chk_slideclose("slide", sopen, aopen, dopen, bopen, i)
				sopen = 0
				snr = snr + 1
				regsl = regsl + 1
			}
			else if (line[1]=="//endanc") {
				chk_slideclose("ancillary slide", sopen, aopen, dopen, bopen, i)
				aopen = 0
				snr = snr + 1
			}
			else if (line[1]=="//enddigr") {
				chk_slideclose("digression slide", sopen, aopen, dopen, bopen, i)
				dopen = 0
				snr = snr + 1
			}
			else if (line[1]== "//endbib") {
				chk_slideclose("bibliography slide", sopen, aopen, dopen, bopen, i)
				bopen = 0
				snr = snr + 1
			}
		}
	}

	chk_anyopen(sopen, aopen, dopen, bopen, where)
	settings.other.regslides = J(1,regsl,.)
	slide=strslide(snr)
}

void smclpres::where_err(real scalar rownr)
{
	string scalar errmsg
	errmsg = "{p}{err}This error occured on line {res}" + source[rownr,3] + " {err}in {res}" + source[rownr,2] + "{p_end}"
	printf(errmsg)
}

void smclpres::find_structure() {
	real   scalar snr, regsl, titleopen, rownr
	string scalar section, subsection, err , argument
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
                argument = tokenget(t)
                if (argument != "continue") {
                    if (regsl > 1) {
					    slide[snr].prev    = settings.other.regslides[regsl-1]
                    }
                }
                else {
                    if (slide[snr-1].type != "digression") {
                        err = "{p}{err}tried to create a follow up digression slide when the previous slide wasn't a digression{p_end}"
                        printf(err)
                        where_err(rownr)
                        exit(198)
                    }
                    slide[snr].prev = snr-1
                    slide[snr].regprev = settings.other.regslides[regsl-1]
                    slide[snr-1].forw = snr
                    slide[snr].cont = "continue"
                }
			}
			if (left=="//enddigr") {
				snr = snr + 1
			}
			if (left=="//anc") {
				slide[snr].type       = "ancillary"
                argument = tokenget(t)
                if (argument == "continue") {
                    if (slide[snr-1].type != "ancillary") {
                        err = "{p}{err}tried to create a follow up ancillary slide when the previous slide wasn't a ancillary{p_end}"
                        printf(err)
                        where_err(rownr)
                        exit(198)
                    }
                    slide[snr].prev = snr-1
                    slide[snr-1].forw = snr
                    slide[snr].cont = "continue"
                }
			}
			if (left=="//endanc") {
				snr = snr + 1
			}
			if (left == "//titlepage") {
				titleopen = 1
				settings.other.titlepage = 1
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
		destfile = pathjoin(settings.other.destdir , "index.smcl")
		settings.other.index = "index.smcl"
	}
	else {
		destfile = pathjoin(settings.other.destdir,  settings.other.stub + ".smcl")	
		settings.other.index = settings.other.stub + ".smcl"
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
		write_pres_settings(dest)
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
				fput(dest, "")
				if (settings.title.hline.top == "hline") {
					fput(dest, "{hline}")
				}
			}
			else if (left == "toctitle*/") {
				titleopen = 0
				if (settings.title.hline.bottom == "hline") {
					fput(dest, "{hline}")
				}
				fput(dest,"")
			}
			else if (titleopen& left != "/*toctitle"){
				write_title(source[rownr,1],dest, "multiline")
			}
			else if (left == "/*toctxt") {
				textopen = 1
			}
			else if (left == "toctxt*/") {
				textopen = 0
			}
			else if (textopen & left != "/*toctext") {
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
	if (settings.toc.subtitlehline.top == "hline"){
		fput(dest, "{hline}")
	}
	if (which == "slides") {
		temp = settings.toc.subtitle
	}
	if (which == "files" ) {
		temp = settings.tocfiles.name
	}
	if (settings.toc.subtitlefont == "bold") {
		temp = "{bf:" + temp + "}"
	}
	if (settings.toc.subtitlefont == "italic") {
		temp = "{it:" + temp + "}"
	}
	if (settings.toc.subtitlepos == "center") {
		temp = "{center:" + temp + "}"
	}
	else {
		temp = "{p}" + temp + "{p_end}"
	}
	fput(dest, temp)
	if (settings.toc.subtitlehline.bottom == "hline"){
		fput(dest, "{hline}")
	}	
}

void smclpres::write_toc_slides(real scalar dest) {
	real   scalar snr
	string scalar section, subsection
	
	section    = ""
	subsection = ""
	
	for (snr=1; snr <= cols(slide); snr++ ) {
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

void smclpres::write_toc_section(real scalar snr, real scalar dest) {
	string scalar section

	fput(dest, " ")
	
	if (settings.toc.sechline.top == "hline") {
		fput(dest, "{hline}")
	}
	
	section = slide[snr].section
	if (settings.toc.secfont=="bold") {
		section = "{bf:"+section+"}"
	}
	if (settings.toc.secfont=="italic") {
		section = "{it:"+section+"}"
	}
	if (settings.toc.link == "section") {
		section = "{view slide" + strofreal(snr) + ".smcl : " + section + "}"
	}
	section = "{* tocline }" + settings.other.l1 + section + "{p_end}"
	fput(dest, section)
	
	if (settings.toc.sechline.bottom == "hline") {
		fput(dest, "{hline}")
	}
}

void smclpres::write_toc_subsection(real scalar snr, real scalar dest) {
	string scalar subsection
	
	if (settings.toc.title != "subsection") {
		subsection = slide[snr].subsection
		if (settings.toc.subsecfont=="bold") {
			subsection = "{bf:" + subsection + "}"
		}
		if (settings.toc.subsecfont=="italic") {
			subsection = "{it:" + subsection + "}"
		}
		if (settings.toc.link == "subsection") {
			subsection = "{view slide" + strofreal(snr) + ".smcl : " + subsection + "}"
		}
		subsection = "{* tocline }" + settings.other.l2 + subsection + "{p_end}"
		fput(dest, subsection)
	}
}

void smclpres::write_toc_title(real scalar snr, real scalar dest) {
	string scalar title
	
	title = slide[snr].title
	if (slide[snr].type == "bibliography") fput(dest, " ")
	
	if ( (settings.toc.title == "subsection" |
	     (slide[snr].type=="ancillary" & settings.toc.title == "notitle")) &
		 slide[snr].type != "digression" ) {
		if (settings.toc.subsecfont ==  "bold") {
			title = "{bf:" + title + "}"
		}
		if (settings.toc.subsecfont == "italic") {
			title = "{it:" + title + "}"
		}
		if (settings.toc.link == "subsection" | slide[snr].type == "ancillary" | 
		    slide[snr].type == "bibliography") {
			title = "{view slide" + strofreal(snr) + ".smcl : " + title + "}"
		}
		if (slide[snr].type=="ancillary") {
				title = title + " (" + settings.toc.anc +")"
		}
		title = "{* tocline }"+ settings.other.l2 + title + "{p_end}"
		fput(dest,title)
	}
	if (settings.toc.title == "subsubsection" & slide[snr].type != "digression") {
		if (settings.toc.subsubsecfont == "bold") {
			title = "{bf:" + title + "}"
		}
		if (settings.toc.subsubsecfont == "italic") {
			title = "{it:" + title + "}"
		}
		if (settings.toc.link == "subsubsection" | slide[snr].type == "ancillary" | 
		    slide[snr].type == "bibliography") {
			title = "{view slide" + strofreal(snr) + ".smcl : " + title + "}"
		}
		if (slide[snr].type == "ancillary") {
			title = title + " (" + settings.toc.anc +")"
		}
		title = "{* tocline }"+ settings.other.l3 + title + "{p_end}"
		fput(dest, title)
	}
	if (settings.toc.title == "subsection" & slide[snr].type=="digression" & 
	    settings.toc.nodigr != "nodigr") {
		if (settings.toc.subsubsecfont == "bold") {
			title = "{bf:" + title + "}"
		}
		if (settings.toc.subsubsecfont == "italic") {
			title = "{it:" + title + "}"
		}
		if (settings.toc.link == "subsection") {
			title = "{view slide" + strofreal(snr) + ".smcl : " + title + "}"
		}
		title = "{* tocline }"+ settings.other.l3 + title + "{p_end}"
		fput(dest,title)
	}
	if (settings.toc.title == "subsubsection" & slide[snr].type=="digression" & 
	    settings.toc.nodigr != "nodigr") {
		if (settings.toc.subsubsubsecfont == "bold") {
			title = "{bf:" + title + "}"
		}
		if (settings.toc.subsubsubsecfont == "italic") {
			title = "{it:" + title + "}"
		}
		if (settings.toc.link == "subsubsection") {
			title = "{view slide" + strofreal(snr) + ".smcl : " + title + "}"
		}
		title = "{* tocline }"+ settings.other.l4 + title + "{p_end}"
		fput(dest,title)
	}
}
void smclpres::write_toc_files(real scalar dest) {
	real                   scalar    snr, exnr, i, j, rownr
	string                 scalar    lab, left, filename, slidename, row, mark, err, section
	class AssociativeArray scalar    filetoc
	transmorphic           scalar    t
	
	for(i=1; i <= rows(settings.tocfiles.markname); i++) {
			filetoc.put(settings.tocfiles.markname[i,1], J(0,1,""))
	}
	
	fput(dest, "{p2colset " + settings.tocfiles.p2 + "}{...}")
	
	snr    = 0
	exnr   = 0
	
	t = tokeninit(" ")	
	for(rownr = 1; rownr <= rows_source; rownr++) {
		tokenset(t, source[rownr,1])
		if ((left=tokenget(t))!= "") {
			if (left == "//slide" | left == "//anc" | left == "digr" ) {
				snr  = snr + 1
				exnr = 1
			}
			else if (left=="//ex") {
				if ( (lab = ustrltrim(tokenrest(t))) == "") {
					lab = settings.tocfiles.exname + strofreal(exnr)
				}
				filename = "slide" + strofreal(snr) + "ex" + strofreal(exnr) + ".do"
				slidename = "slide" + strofreal(snr) + ".smcl"
				row = buildfilerow(filename,lab,slidename)
				filetoc.put("ex", (filetoc.get("ex") \ row))
				exnr = exnr + 1
			}
			else if (left=="//tocfile") {
				mark = tokenget(t)
				filename = tokenget(t)
				lab = ustrltrim(tokenrest(t))
				if (mark == "" | filename == "" | lab == "") {
					err = "{p}{err}//filetoc command contains an error{p_end}"
					printf(err)
					where_err(rownr)
					exit(198)
				}
				if (filetoc.exists(mark)) {
					slidename = "slide" + strofreal(snr) + ".smcl"
					row = buildfilerow(filename,lab,slidename)
					filetoc.put(mark, (filetoc.get(mark) \ row))
				}
				else {
					err = "{p}{err}mark {res}" + mark + 
					      " {err }in the //filetoc command is not defined{p_end}"
					printf(err)
					where_err(rownr)
					exit(198)
				}
				
			}
		}
	}
	
	for (i = 1 ; i <= rows(settings.tocfiles.markname); i++) {
		mark = settings.tocfiles.markname[i,1]
		if (rows(filetoc.get(mark)) > 0 ) {
			fput(dest, " ")
			
			if (settings.toc.sechline.top == "hline") {
				fput(dest, "{hline}")
			}
			
			section = settings.tocfiles.markname[i,2]
			if (settings.toc.secfont=="bold") {
				section = "{bf:"+section+"}"
			}
			if (settings.toc.secfont=="italic") {
				section = "{it:"+section+"}"
			}
			section = settings.other.l1 + section + "{p_end}"
			fput(dest, section)
			
			if (settings.toc.sechline.bottom == "hline") {
				fput(dest, "{hline}")
			}
			for(j=1; j<=rows(filetoc.get(mark)); j++) {
				fput(dest, filetoc.get(mark)[j])
			}
		}	
	}
}

string scalar smclpres::buildfilerow(string scalar filename,
                           string scalar label, string scalar slide ) {

	string scalar    toreturn
	string rowvector ext
	
	ext = pathsuffix(filename)
	ext = tokens(ext, ".")
	if ( cols(ext) == 2 ) {
		ext = ext[2]
	}
	else {
		ext = ""
	}
	
	toreturn = "{p2col:"
	
	if (anyof(tokens(settings.tocfiles.doedit),ext)) {
		toreturn = toreturn + `"{stata "doedit "' + filename + `"":"' + filename + "}"
	}
	else if (anyof(tokens(settings.tocfiles.view),ext)) {
		toreturn = toreturn + "{view " + filename + "}"
	}
	else if (anyof(tokens(settings.tocfiles.gruse),ext)) {
		toreturn = toreturn + `"{stata "graph use "' + filename + `"":"' + filename + "}"
	}
	else if (anyof(tokens(settings.tocfiles.euse),ext)) {
		toreturn = toreturn + `"{stata "est use "' + filename + `"":"' + filename + "}"
	}
	else if (anyof(tokens(settings.tocfiles.use),ext)) {
		toreturn = toreturn + `"{stata "use "' + filename + `", clear":"' + filename + "}"
	}
	else {
		toreturn = toreturn + filename
	}
	toreturn = toreturn + "}" +	label + settings.tocfiles.where 
	toreturn = toreturn + "{view " + slide + "}{p_end}"
	return(toreturn)
}

void smclpres::write_pres_settings(real scalar dest) {
	real scalar snr
	string scalar app
	string rowvector strslides
	
	app = ""
	strslides = settings.other.stub + ".smcl "
	if (settings.other.titlepage) {
		strslides = strslides + "index.smcl "
	}
	for (snr=1 ; snr <= cols(slide) ; snr++) {
		if (slide[snr].type=="regular") {
			strslides = strslides + "slide" + strofreal(snr) + ".smcl "
		}
		else {
			app = app + "slide" + strofreal(snr) + ".smcl "
		}
	}
	strslides = strslides + app
	strslides = tokens(strslides)
	fput(dest, "{* slides }{...}" )
	for(snr = 1; snr <= cols(strslides); snr++) {
		fput(dest, "{* " + strslides[snr]+ " }{...}")
	}
	fput(dest, "{* bottomstyle " + settings.bottombar.arrow + " }{...}")
}

end
exit