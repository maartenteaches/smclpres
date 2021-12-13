mata:

real scalar smclpres::start_slide(real scalar snr, string scalar title) {
	string scalar destfile
	real scalar dest
	
	if (title == "titlepage") {
		destfile = pathjoin(settings.other.destdir, settings.other.stub + ".smcl")
	}
	else {
		destfile = pathjoin(settings.other.destdir, "slide" + strofreal(snr) + ".smcl")	
	}
	dest = sp_fopen(destfile,"w")
	fput(dest, "{smcl}")
	fput(dest, "{* " +  st_strscalar("c(current_date)") + "}{...}")
	return(dest)
	
}

real scalar smclpres::start_ex(real scalar snr, real scalar exnr) {
	string scalar destfile
	real scalar dest
	
	destfile = pathjoin(settings.other.destdir, "slide" + strofreal(snr) + "ex" + strofreal(exnr) + ".do")	
	dest = sp_fopen(destfile,"w")
	return(dest)
}

string scalar smclpres::digr_replace(string sclar line, real scalar snr, real scalar rownr) 
{
    string rowvector tline
    real scalar snrp1
    string scalar err, lab, rep

    tline = tokens(line)
    if ( anyof(tline,"/*digr*/") )  {
		snrp1 = snr + 1
		if (slide[snrp1].type != "digression") {
			err = "{p}{err}a link to a digression was included but the next slide is not a digression{p_end}"
			printf(err)
            where_err(rownr)
			exit(198)
		}
		if (slide[snrp1].label == "") {
			lab = settings.digress.name
		}
		else {
			lab = slide[snrp1].label
		}
		rep = (settings.digress.prefix == ">> " ? "&gt;&gt; ": settings.digress.prefix ) + lab
		rep = "{* digr <a href=" + `""#slide"' + strofreal(snrp1) + `".smcl">"' +
			  rep + "</a>}{view slide" + strofreal(snrp1) +
			  ".smcl:" + pres.settings.digress.prefix +
			  lab + "}{* /digr}"
		line = usubinstr(line, "/*digr*/", rep)
	}
    return(line)
}

void smclpres::write_slides() {
	real scalar snr, exnr, rownr, snrp1, i
	real scalar slideopen, titlepageopen, exopen, txtopen
	real scalar source, dest, exdest
	string scalar left, right, exname, command, err, rep, lab, dofile, dofile2, db, db2, dir
	string rowvector dirs
    transmorphic scalar t
	
	snr  = 0
	exnr = 0
	slideopen = 0
	titlepageopen = 0
	exopen = 0
	txtopen = 0
	
    t = tokeninit(" ")	
	for(rownr = 1; rownr <= rows_source; rownr++) {
		tokenset(t, source[rownr,1])
		if ((left=tokenget(t))!= "") {
			if (left == "//slide" | left == "//anc" | left == "//digr" | left == "//bib" ) {
				snr  = snr + 1
				exnr = 0
				if (slideopen | titlepageopen ) {
					err = "{p}{err}tried to open a new slide when a slide was already open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				slideopen = 1
				dest = start_slide(snr, "")
				write_topbar(dest, snr)
			}
			else if (left == "//endslide" | left == "//endanc" | left == "//enddigr" | left == "//endbib") {
				if (slideopen == 0) {
					err = "{p}{err}tried to close a slide when none is open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (exopen) {
					err = "{p}{err}tried to close a slide when an example was still open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)				
				}
				if (txtopen) {
					err = "{p}{err}tried to close a slide when a textblock was still open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				write_bottombar(dest, snr, "regular")
				sp_fclose(dest)
				slideopen = 0
			}
			else if (left == "//title") {
				if (slideopen == 0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a title when no slide was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (exopen) {
					err = "{p}{err}tried adding a title when example was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				write_title(tline, dest, 0)
			}
			else if (left == "//titlepage") {
				if (slideopen | titlepageopen ) {
					err = "{p}{err}tried to open a new slide when a slide was already open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				slideopen = 1
				dest = start_slide(snr, "titlepage")
			}
			else if (left == "//endtitlepage") {
			if (slideopen == 0) {
					err = "{p}{err}tried to close a slide when none is open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (exopen) {
					err = "{p}{err}tried to close a slide when an example was still open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)				
				}
				if (txtopen) {
					err = "{p}{err}tried to close a slide when a textblock was still open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				write_bottombar(dest, snr, "title")
				rite_pres_settings(dest)
				sp_fclose(dest)
				slideopen = 0
			}
			else if (left == "/*txt") {
				if (txtopen == 1) {
					err = "{p}{err}tried to open a textblock when one was already open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (exopen == 1) {
					err = "{p}{err}tried to open a textblock when an example was already open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (slideopen == 0 & titlepageopen == 0) {
					err = "{p}{err}tried to open a textblock when no slide was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				txtopen = 1
			}
			else if (left == "txt*/") {
				if (txtopen == 0 ) {
					err = "{p}{err}tried to close a textblock when no textblock was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				txtopen = 0
			}
			else if (left == "//txt") {
				if (slideopen == 0 & titlepageopen == 0) {
					err = "{p}{err}tried to open a single line text when no slide was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (txtopen == 1) {
					err = "{p}{err}tried adding a single line text when a textblock was already open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (exopen == 1) {
					err = "{p}{err}tried to open a single line text when an example was already open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				line = digr_replace(tokenrest(t), snr, rownr)
				line = ref_replace(line, snr, rownr)
				fput(dest, line)
			}
			else if (left == "//ex") {
				if (exopen) {
					err = "{p}{err}tried to open a new example when one was already open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried to open an example when no slide was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				exopen = 1
				exnr = exnr + 1
				exname = "slide" + strofreal(snr) + "ex" + strofreal(exnr)
				fput(dest, " ")
				fput(dest,"{* ex " + exname  + " }{...}")
				fput(dest,"{cmd}")
				exdest = start_ex(snr,exnr)
			}
			else if (left == "//endex") {
				if (exopen == 0) {
					err = "{p}{err}tried to close an example when none was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				fput(dest, "{txt}{...}")
				command = `"""'+ "do " + exname + ".do" + `"""'
				fput(dest, "{pstd}({stata " +  command +  ":" + 
				             settings.example.name + "}){p_end}")
				fput(dest,"")
				fput(dest,"")
				fput(dest,"{* endex }{...}")
				sp_fclose(pres,exdest)
				exopen = 0
			}
			else if (left == "//graph") {
				if (exopen) {
					err = "{p}{err}tried adding a graph comment when an example was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a graph comment when no slide was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if ((right=tokenrest(t)) == "") {
					err = "{p}{err}no graph name(s) mentioned after //graph {p_end}"
                    printf(err)
                    where_err(rownr)
                    exit(198)
				}
				line = "{* graph " + right + " }{...}"
				if (txtopen == 0) {
					fput(dest, line )
				}
			}
			else if (left == "//file") {
				if ((right=tokenrest(t)) == "") {
					err = "{p}{err}1 file must be specified after //file {p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				dofile = pathjoin(other.sourcedir , right)
				if (!fileexists(dofile)) {
					err = "{p}{err}file {res}" + dofile + "{err} specified after //file does not exist{p_end}"
					printf(err)
					where_err(rownr)
                    exit(198)
				}
				dofile2 = pathjoin(other.destdir, right)
				if (!fileexists(dofile2)) {
					command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
					stata( command, 1)
				}
			}
			else if (left == "//dir") {
				if ((right=tokenrest(t)) == "") {
					err = "{p}{err}1 directory must be specified after //dir {p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}	
				dir = pathjoin(settings.other.destdir, right) 
				if (!direxists(dir)) mkdir(dir)
			}
			else if (left == "//dofile") {
				if (exopen) {
					err = "{p}{err}tried adding a link to a dofile when an example was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a link to a dofile when no slide was open{p_end}"
					printf(err)
                    where_err(rownr)
					exit(198)
				}
				if (txtopen == 0) {
					err = "{p}{err}tried adding a link to a dofile when no text block was open{p_end}"
                    printf(err)
                    where_err(rownr)
                    exit(198)
				}
				if (cols(tline) == 1 | cols(tline) > 3) {
					err = "{p}{err}the //dofile command on line {res}" + strofreal(lnr) +
					      " {err}must specify 1 file and a label{p_end}"
					printf(err)
					exit(198)
				}
				dofile = pres.settings.other.sourcedir + "/" + tline[2]
				if (!fileexists(dofile)) {
					err = "{p}{err}file {res}" + dofile + "{err} specified after //dofile" +
					      " on line {res}" + strofreal(lnr) + " {err}does not exist{p_end}"
					printf(err)
					exit(198)
				}
				dofile2 = pres.settings.other.destdir + "/" + tline[2]
				if (!fileexists(dofile2)) {
					command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
					stata( command, 1)
				}
				if (cols(tline) == 2) {
					line = "{* dofile " + tline[2] + " }{...}"
				}
				else {
					line = "{* dofile " + tline[2] + " }" + 
						  "{pstd}{stata " + `"""' + "doedit " + tline[2] + `"""' + 
						  ":" + tline[3] + "}{p_end}"'
				}
			}
			else if (tline[1] == "//apdofile") {
				if (exopen) {
					err = "{p}{err}tried adding a link to a dofile on line {res}" + strofreal(lnr) +
					      " {err}when an example was open{p_end}"
					printf(err)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a link to a dofile on line {res}" + strofreal(lnr) +
					      " {err}when no slide was open{p_end}"
					printf(err)
					exit(198)
				}
				if (txtopen == 0) {
					err = "{p}{err}tried adding a link to a dofile on line {res}" + strofreal(lnr) + 
					    "{err}when no text block was open{p_end}"
				}
				if (cols(tline) == 1 | cols(tline) > 3) {
					err = "{p}{err}the //apdofile command on line {res}" + strofreal(lnr) +
					      " {err}must specify 1 file and a label{p_end}"
					printf(err)
					exit(198)
				}				
				dofile = pres.settings.other.sourcedir + "/" + tline[2]
				if (!fileexists(dofile)) {
					err = "{p}{err}file {res}" + dofile + "{err} specified after //apdofile" +
					      " on line {res}" + strofreal(lnr) + " {err}does not exist{p_end}"
					printf(err)
					exit(198)
				}
				dofile2 = pres.settings.other.destdir + "/" + tline[2]
				if (!fileexists(dofile2)) {
					command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
					stata( command, 1)
				}
				if (cols(tline) == 2) {
					line = "{* apdofile " + tline[2] + " }{...}"
				}
				else {
					line = "{* apdofile " + tline[2] + " " + tline[3] + " }" + 
						   "{pstd}{stata " + `"""' + "doedit " + tline[2] + `"""' + 
						  ":" + tline[3] + "}{p_end}"'
				}
			}
			else if (tline[1] == "//codefile") {
				if (exopen) {
					err = "{p}{err}tried adding a link to a codefile on line {res}" + strofreal(lnr) +
					      " {err}when an example was open{p_end}"
					printf(err)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a link to a codefile on line {res}" + strofreal(lnr) +
					      " {err}when no slide was open{p_end}"
					printf(err)
					exit(198)
				}
				if (txtopen == 0) {
					err = "{p}{err}tried adding a link to a codefile on line {res}" + strofreal(lnr) + 
					    "{err}when no text block was open{p_end}"
				}
				if (cols(tline) == 1 | cols(tline) > 3) {
					err = "{p}{err}the //codefile command on line {res}" + strofreal(lnr) +
					      " {err}must specify 1 file and a label{p_end}"
					printf(err)
					exit(198)
				}				
				dofile = pres.settings.other.sourcedir + "/" + tline[2]
				if (!fileexists(dofile)) {
					err = "{p}{err}file {res}" + dofile + "{err} specified after //codefile" +
					      " on line {res}" + strofreal(lnr) + " {err}does not exist{p_end}"
					printf(err)
					exit(198)
				}
				dofile2 = pres.settings.other.destdir + "/" + tline[2]
				if (!fileexists(dofile2)) {
					command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
					stata( command, 1)
				}
				if (cols(tline) == 2) {
					line = "{* codefile " + tline[2] + " }{...}"
				}
				else {
					line = "{* codefile " + tline[2] + " }" + 
						   "{pstd}{stata " + `"""' + "doedit " + tline[2] + `"""' + 
						  ":" + tline[3] + "}{p_end}"'	
				}
			}
			else if (tline[1] == "//apcodefile") {
				if (exopen) {
					err = "{p}{err}tried adding a link to a codefile on line {res}" + strofreal(lnr) +
					      " {err}when an example was open{p_end}"
					printf(err)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a link to a codefile on line {res}" + strofreal(lnr) +
					      " {err}when no slide was open{p_end}"
					printf(err)
					exit(198)
				}
				if (txtopen == 0) {
					err = "{p}{err}tried adding a link to a codefile on line {res}" + strofreal(lnr) + 
					    "{err}when no text block was open{p_end}"
				}
				if (cols(tline) == 1 | cols(tline) > 3) {
					err = "{p}{err}the //apcodefile command on line {res}" + strofreal(lnr) +
					      " {err}must specify 1 file and a label{p_end}"
					printf(err)
					exit(198)
				}				
				dofile = pres.settings.other.sourcedir + "/" + tline[2]
				if (!fileexists(dofile)) {
					err = "{p}{err}file {res}" + dofile + "{err} specified after //apcodefile" +
					      " on line {res}" + strofreal(lnr) + " {err}does not exist{p_end}"
					printf(err)
					exit(198)
				}
				dofile2 = pres.settings.other.destdir + "/" + tline[2]
				if (!fileexists(dofile2)) {
					command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
					stata( command, 1)
				}
				if (cols(tline) == 2) {
					line = "{* apcodefile " + tline[2] + " }{...}"
				}
				else {
					line = "{* apcodefile " + tline[2] + " " + tline[3] + " }" +
						   "{pstd}{stata " + `"""' + "doedit " + tline[2] + `"""' + 
						  ":" + tline[3] + "}{p_end}"'
				}
			}
			else if (tline[1] == "//db") {
				if (exopen) {
					err = "{p}{err}tried adding a link to a dialogbox on line {res}" + strofreal(lnr) +
					      " {err}when an example was open{p_end}"
					printf(err)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a link to a dialogbox on line {res}" + strofreal(lnr) +
					      " {err}when no slide was open{p_end}"
					printf(err)
					exit(198)
				}
				if (txtopen == 0) {
					err = "{p}{err}tried adding a link to a dialogbox on line {res}" + strofreal(lnr) + 
					    "{err}when no text block was open{p_end}"
				}
				if (cols(tline) != 4) {
					err = "{p}{err}the //db command on line {res}" + strofreal(lnr) +
					      " {err}must specify 1 dialog box, 1 do file, and a label{p_end}"
					printf(err)
					exit(198)
				}
				db = pres.settings.other.sourcedir + "/" + tline[2] + ".dlg"
				if (!fileexists(db)) {
					err = "{p}{err}file {res}" + db + "{err} specified after //db" +
					      " on line {res}" + strofreal(lnr) + " {err}does not exist{p_end}"
					printf(err)
					exit(198)
				}
				db2 = pres.settings.other.destdir + "/" + tline[2] + ".dlg"
				if (!fileexists(db2)) {
					command = `"copy ""' + db + `"" ""' + db2 + `"""'
					stata( command, 1)
				}
				dofile =  pres.settings.other.sourcedir + "/" + tline[3]
				if (!fileexists(dofile)){
					err = "{p}{err}file {res}" + dofile + "{err} specified after //db" +
					      "on line {res} " + strofreal(lnr) + "{err} does not exist{p_end}"
					printf(err)
					exit(198)
				}
				dofile2 =  pres.settings.other.destdir + "/" + tline[3]
				if (!fileexists(dofile2)) {
					command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
					stata( command, 1)
				}
				line = "{* dofile " + tline[3] + " }" + 
					  "{pstd}{stata " + `"""' + "db " + tline[2] + `"""' + 
					  ":" + tline[4] + "}{p_end}"'

			}			
			else if (tline[1] == "//ho_ignore") {
				if (exopen) {
					err = "{p}{err}tried adding a ho_ignore comment on line {res}" + strofreal(lnr) +
					      " {err}when an example was open{p_end}"
					printf(err)
					exit(198)
				}
				if (slideopen==0 & titlepageopen == 0) {
					err = "{p}{err}tried adding a ho_ignore comment on line {res}" + strofreal(lnr) +
					      " {err}when no slide was open{p_end}"
					printf(err)
					exit(198)
				}
				if (txtopen == 0) {
					err = "{p}{err}tried adding a ho_ignore comment on line {res}" + strofreal(lnr) +
					      " {err}when no textblock was open{p_end}"
					printf(err)
					exit(198)
				}
				line = "{* ho_ignore }" + subinstr(line, "//ho_ignore", "", 1)
			}
			else if (tline[1] == "//bib_here" | tline[1] == "/*bib") {
				if (exopen) {
					err = "{p}{err}tried adding a bibliography on line {res}" + strofreal(lnr) +
					      " {err}when an example was open{p_end}"
					printf(err)
					exit(198)
				}
				if (slideopen==0 ) {
					err = "{p}{err}tried adding a bibliography on line {res}" + strofreal(lnr) +
					      " {err}when no slide was open{p_end}"
					printf(err)
					exit(198)
				}
				if (txtopen == 1) {
					err = "{p}{err}tried adding a bibliography on line {res}" + strofreal(lnr) +
					      " {err}when an textblock was open{p_end}"
					printf(err)
					exit(198)
				}
				if (snr != pres.bib.bibslide) {
					err = "{p}{err}tried adding a bibliography on line {res}" + strofreal(lnr) +
					      " {err}on a non bibliography slide{p_end}"
					printf(err)
					exit(198)
				}
				sp_write_bib(pres, dest)
			}	
		}
		if (txtopen) {
			if (cols(tline) > 0) {
				if (tline[1] != "/*txt") {
					if ( anyof(tline, "/*digr*/") ) {
						snrp1 = snr + 1
						if (pres.slide[snrp1].type != "digression") {
							err = "{p}{err}a link to a digression was included on line {res}" +
							      strofreal(lnr) + " {err}but the next slide is not " + 
								  "a digression{p_end}"
							printf(err)
							exit(198)
						}
						if (pres.slide[snrp1].label == "") {
							lab = pres.settings.digress.name
						}
						else {
							lab = pres.slide[snrp1].label
						}
						rep = (pres.settings.digress.prefix == ">> " ? 
				             "&gt;&gt; ": pres.settings.digress.prefix ) + lab
						rep = "{* digr <a href=" +
						      `""#slide"' + strofreal(snrp1) + `".smcl">"' +
							  rep + "</a>}{view slide" + strofreal(snrp1) +
							  ".smcl:" + pres.settings.digress.prefix +
							  lab + "}{* /digr}"
						line = subinstr(line, "/*digr*/", rep)
					}
					if (anyof(tline, "/*cite")) {
						line = sp_replaceref(pres, line, snr)
					}
					fput(dest, line)
				}
			}
			else {
				fput(dest,line)
			}
		}
		if (exopen) {
			if (cols(tline)>0) {
				if (tline[1] != "//ex") {
					fput(dest, "        " + line)
					fput(exdest, line)
				}
			}
			else {
				fput(dest, line)
				fput(exdest, line)
			}
		}
	}
	sp_fclose(pres,source)
	if (txtopen) {
		err = "{p}{err}reached end of sourcefile, but a textblock is still open{p_end}"
		printf(err)
		exit(198)
	}
	if (exopen) {
		err = "{p}{err}reached end of sourcefile, but an example is still open{p_end}"
		printf(err)
		exit(198)
	}
	if (slideopen | titlepageopen) {
		err = "{p}{err}reached end of sourcefile, but a slide is still open{p_end}"
		printf(err)
		exit(198)
	}	
}


end