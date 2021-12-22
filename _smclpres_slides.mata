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

struct strstate scalar smclpres::start_ex(struct strstate scalar state) {
	string scalar destfile
	
	exopen(state, "new example")
	noslideopen(state, "example")
	state.exopen = 1
	state.exnr = state.exnr + 1
	state.exname = "slide" + strofreal(state.snr) + "ex" + strofreal(state.exnr)
	fput(state.dest, " ")
	fput(state.dest,"{* ex " + state.exname  + " }{...}")
	fput(state.dest,"{cmd}")

	destfile = pathjoin(settings.other.destdir, "slide" + strofreal(state.snr) + "ex" + strofreal(state.exnr) + ".do")	
	state.exdest = sp_fopen(destfile,"w")
	return(state)
}

struct strstate scalar smclpres::end_ex(struct strstate scalar state)
{
	string scalar err, command
	if (state.exopen == 0) {
		err = "{p}{err}tried to close an example when none was open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
	fput(state.dest, "{txt}{...}")
	command = `"""'+ "do " + state.exname + ".do" + `"""'
	fput(state.dest, "{pstd}({stata " +  command +  ":" + 
		             settings.example.name + "}){p_end}")
	fput(state.dest,"")
	fput(state.dest,"")
	fput(state.dest,"{* endex }{...}")
	sp_fclose(state.exdest)
	state.exopen = 0
	return(state)
}

struct strstate scalar smclpres::digr_replace(struct strstate scalar state) 
{
    real scalar snrp1
    string scalar err, lab, rep

    if ( ustrpos(state.line, "/*digr*/") )  {
		snrp1 = state.snr + 1
		if (slide[snrp1].type != "digression") {
			err = "{p}{err}a link to a digression was included but the next slide is not a digression{p_end}"
			printf(err)
            where_err(state.rownr)
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
			  ".smcl:" + settings.digress.prefix +
			  lab + "}{* /digr}"

		state.line = usubinstr(state.line, "/*digr*/", rep, .)
	}
    return(state)
}

struct strstate scalar smclpres::write_db(struct strstate scalar state)
{
	string scalar err, db, db2, command, dofile, dofile2
	string rowvector tline
	
	tline = tokens(state.line)
	exopen(state, "dialogbox")
	noslideopen(state, "dialogbox")
	notxtopen(state, "dialogbox")
	if (cols(tline) != 4) {
		err = "{p}{err}the //db command must specify 1 dialog box, 1 do file, and a label{p_end}"
		printf(err)
		where_err(state.rownr)
		exit(198)
	}
	db = pathjoin(settings.other.sourcedir, tline[2] + ".dlg")
	if (!fileexists(db)) {
		err = "{p}{err}file {res}" + db + "{err} specified after //db does not exist{p_end}"
		printf(err)
		where_err(state.rownr)
		exit(198)
	}
	db2 = pathjoin(settings.other.destdir, tline[2] + ".dlg")
	if (!fileexists(db2)) {
		command = `"copy ""' + db + `"" ""' + db2 + `"""'
		stata( command, 1)
	}
	dofile = pathjoin(settings.other.sourcedir, tline[3])
	if (!fileexists(dofile)){
		err = "{p}{err}file {res}" + dofile + "{err} specified after //db does not exist{p_end}"
		printf(err)
		where_err(state.rownr)
		exit(198)
	}
	dofile2 =  pathjoin(settings.other.destdir, tline[3])
	if (!fileexists(dofile2)) {
		command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
		stata( command, 1)
	}
	state.line = "{* dofile " + tline[3] + " }" + 
		  "{pstd}{stata " + `"""' + "db " + tline[2] + `"""' + 
		  ":" + tline[4] + "}{p_end}"'
	return(state)
}					  

struct strstate scalar smclpres::write_dofiles(string scalar what, struct strstate scalar state)
{
	string scalar err, command, dofile, dofile2
	string rowvector tline

	what = usubinstr(what,"//","", 1)
	tline = tokens(state.line)

	exopen(state, "dofile")
	noslideopen(state, "dofile")
	notxtopen(state, "dofile")
	if (cols(tline) == 0 | cols(tline) > 2) {
		err = "{p}{err}the //dofile command must specify 1 file and a label{p_end}"
		printf(err)
		where_err(state.rownr)
		exit(198)
	}
	dofile = pathjoin(settings.other.sourcedir , tline[1])
	if (!fileexists(dofile)) {
		err = "{p}{err}file {res}" + dofile + "{err} specified after //dofile" +
		      " does not exist{p_end}"
		printf(err)
		where_err(state.rownr)
		exit(198)
	}
	dofile2 = pathjoin(settings.other.destdir, tline[2])
	if (!fileexists(dofile2)) {
		command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
		stata( command, 1)
	}
	if (cols(tline) == 2) {
		state.line = "{* " + what + " " + tline[2] + " }{...}"
	}
	else {
		state.line = "{* " + what + " " + tline[2] + " }" + 
	 		   "{pstd}{stata " + `"""' + "doedit " + tline[2] + `"""' + 
			   ":" + tline[3] + "}{p_end}"'
	}
	return(state)
}

struct strstate scalar smclpres::end_titlepage(struct strstate scalar state)
{	
	string scalar err
	if (state.slideopen == 0) {
		err = "{p}{err}tried to close a slide when none is open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
	if (state.exopen) {
		err = "{p}{err}tried to close a slide when an example was still open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)				
	}
	if (state.txtopen) {
		err = "{p}{err}tried to close a slide when a textblock was still open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
	write_bottombar(state.dest, state.snr, "title")
	write_pres_settings(state.dest)
	sp_fclose(state.dest)
	state.slideopen = 0
	return(state)			
}
struct strstate scalar smclpres::begin_slide(struct strstate scalar state)
{
	state.snr  = state.snr + 1
	state.exnr = 0
	slideopen(state, "new slide")
	state.slideopen = 1
	state.dest = start_slide(state.snr, "")
	write_topbar(state.dest, state.snr)
	return(state)
}
struct strstate scalar smclpres::end_slide(struct strstate scalar state)
{
	string scalar err

	if (state.slideopen == 0) {
		err = "{p}{err}tried to close a slide when none is open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
	if (state.exopen) {
		err = "{p}{err}tried to close a slide when an example was still open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)				
	}
	if (state.txtopen) {
		err = "{p}{err}tried to close a slide when a textblock was still open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
	write_bottombar(state.dest, state.snr, "regular")
	sp_fclose(state.dest)
	state.slideopen = 0
	return(state)
}
void smclpres::noslideopen(struct strstate scalar state, string scalar what)
{
	string scalar err
	if (state.slideopen == 0 & state.titlepageopen == 0) {
		err = "{p}{err}tried adding a " + what + " when no slide was open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
} 
void smclpres::slideopen(struct strstate scalar state, string scalar what)
{
	string scalar err
	if (state.slideopen == 1 | state.titlepageopen == 1) {
		err = "{p}{err}tried adding a " + what + " when a slide was open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
}
void smclpres::notxtopen(struct strstate scalar state, string scalar what)
{
	string scalar err
	if (state.txtopen == 0 ) {
		err = "{p}{err}tried adding a " + what + " when no text block was open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
} 
void smclpres::txtopen(struct strstate scalar state, string scalar what)
{
	string scalar err
	if (state.txtopen == 1 ) {
		err = "{p}{err}tried adding a " + what + " when a text block was open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
} 

void smclpres::exopen(struct strstate scalar state, string scalar what)
{
	string scalar err
	if (state.exopen) {
		err = "{p}{err}tried adding a " + what + " when example was open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
}
struct strstate scalar smclpres::begin_txt(struct strstate scalar state)
{	
	string scalar err
	if (state.txtopen == 1) {
		err = "{p}{err}tried to open a textblock when one was already open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
	exopen(state, "textblock")
-	noslideopen(state, "textblock")
	state.txtopen = 1
	return(state)
}
struct strstate scalar smclpres::end_txt(struct strstate scalar state)
{
	string scalar err
	if (state.txtopen == 0 ) {
		err = "{p}{err}tried to close a textblock when no textblock was open{p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}
	state.txtopen = 0
	return(state)
}

void smclpres::write_oneline_text(struct strstate scalar state, | string scalar left)
{
	if (left == "/*txt") return
	noslideopen(state, "single line text")
	exopen(state, "single line text")
	state = digr_replace(state)
	state = ref_replace(state)
	fput(state.dest, state.line)
}
void smclpres::write_ex(struct strstate scalar state, string scalar left)
{
	if (left != "//ex") {
		fput(state.dest, "        " + state.line)
		fput(state.exdest, state.line)
	}
}

void smclpres::write_file(struct strstate scalar state, string scalar right)
{
	string scalar dofile, dofile2, err , command
	if (right == "") {
		err = "{p}{err}1 file must be specified after //file{p_end}"
		printf(err)
		where_err(state.rownr)
		exit(198)
	}
	dofile = pathjoin(settings.other.sourcedir, right)
	if(!fileexists(dofile)){
		err = "{p}{err}file {res}" + dofile + "{err} specified after //file does not exist{p_end}"
		printf(err)
		where_err(state.rownr)
        exit(198)
	}
	dofile2 = pathjoin(settings.other.destdir, right)
	if (!fileexists(dofile2)) {
		command = `"copy ""' + dofile + `"" ""' + dofile2 + `"""'
		stata( command, 1)
	}	
}

void smclpres::write_dir(struct strstate scalar state, string scalar right)
{
	string scalar err, dir
	if (right == "") {
		err = "{p}{err}1 directory must be specified after //dir {p_end}"
		printf(err)
        where_err(state.rownr)
		exit(198)
	}	
	dir = pathjoin(settings.other.destdir, right) 
	if (!direxists(dir)) mkdir(dir)
}

void smclpres::slides_done(struct strstate scalar state)
{
	string scalar err
	if (state.txtopen) {
		err = "{p}{err}reached end of sourcefile, but a textblock is still open{p_end}"
		printf(err)
		exit(198)
	}
	if (state.exopen) {
		err = "{p}{err}reached end of sourcefile, but an example is still open{p_end}"
		printf(err)
		exit(198)
	}
	if (state.slideopen | state.titlepageopen) {
		err = "{p}{err}reached end of sourcefile, but a slide is still open{p_end}"
		printf(err)
		exit(198)
	}	
}

struct strstate scalar smclpres::write_graph(struct strstate scalar state, string scalar right)
{
	string scalar err
	exopen(state,"graph comment")
	noslideopen(state, "graph comment")
	if (right == "") {
		err = "{p}{err}no graph name(s) mentioned after //graph {p_end}"
        printf(err)
        where_err(state.rownr)
        exit(198)
	}
	state.line = "{* graph " + right + " }{...}"
	if (state.txtopen == 0) {
		fput(state.dest, state.line )
	}
	return(state)
}

struct strstate scalar smclpres::write_ho_ignore(struct strstate scalar state)
{
	exopen(state, "ho_ignore comment")
	noslideopen(state, "ho_ignore comment")
	notxtopen(state, "ho_ignore comment")
	state.line = "{* ho_ignore }" + subinstr(state.line, "//ho_ignore", "", 1)
	return(state)
}

void smclpres::write_slides() {
	real scalar  rownr 
	string scalar left
    transmorphic scalar t
	struct strstate scalar state
	
	state.snr  = 0
	state.exnr = 0
	state.slideopen = 0
	state.titlepageopen = 0
	state.exopen = 0
	state.txtopen = 0
	
    t = tokeninit(" ")	
	for(rownr = 1; rownr <= rows_source; rownr++) {
		state.line = source[rownr,1]
		tokenset(t, source[rownr,1])
		state.rownr = rownr
		left = tokenget(t)

		if (left == "//slide" | left == "//anc" | left == "//digr" | left == "//bib" ) {
			state = begin_slide(state)
		}
		else if (left == "//endslide" | left == "//endanc" | left == "//enddigr" | left == "//endbib") {
			state = end_slide(state)
		}
		else if (left == "//title") {
			noslideopen(state, "title")
			exopen(state, "title")
			write_title(tokenrest(t), state.dest)
		}
		else if (left == "//titlepage") {
			noslideopen(state, "new slide")
			state.slideopen = 1
			state.dest = start_slide(state.snr, "titlepage")
		}
		else if (left == "//endtitlepage") {
			state=end_titlepage(state)
		}
		else if (left == "/*txt") {
			state = begin_txt(state)
		}
		else if (left == "txt*/") {
			state = end_txt(state)
		}
		else if (left == "//txt") {
			state.line = tokenrest(t)
			txtopen(state, "single line text")
			write_oneline_text(state)
		}
		else if (left == "//ex") {
			state = start_ex(state)
		}
		else if (left == "//endex") {
			state = end_ex(state)
		}
		else if (left == "//graph") {
			state = write_graph(state, tokenrest(t))
		}
		else if (left == "//file") {
			write_file(state, tokenrest(t))
		}
		else if (left == "//dir") {
			write_dir(state,tokenrest(t))
		}
		else if (left == "//dofile" | left == "apdofile" | left == "codefile" | left == "apcodefile") {
			state.line = tokenrest(t)
			state = write_dofiles(left, state)
		}
		else if (left == "//db") {
			state.line = tokenrest(t)
			state = write_db(state)
		}			
		else if (left == "//ho_ignore") {
			state = write_ho_ignore(state)
		}
		else if (left == "//bib_here" | left == "/*bib") {
			write_bib(state)
		}	

		if (state.txtopen) {
			write_oneline_text(state, left)
		}
		if (state.exopen) {
			write_ex(state,left)
		}
	}
	slides_done(state)
}


end