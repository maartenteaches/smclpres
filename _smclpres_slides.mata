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

end