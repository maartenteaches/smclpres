*! version 3.3.1 MLB 05Aug2019
*  rewrite as a Mata class
*  allow source files to include other source files
*  fix to allow for very long presentations  

program define smclpres, rclass
	version 14.2
	syntax using, [debug] *
	
	local olddir = c(pwd)
	
	local pres sp__presentation_struct
	mata: `pres' = smclpres()	
	
	capture noisily smclpres_main `using', `options' pres(`pres')
	
	if _rc {
		if `"`olddir'"' != `"`c(pwd)'"' {
			qui cd `olddir'
		}
		//mata : `pres'.fcloseall()
		if "`debug'" == "" {
			mata: mata drop `pres'
		}
		exit _rc
	}
	if "`debug'" == "" {
		mata: mata drop `pres'
	}
end

program define smclpres_main, rclass
	version 14.2
	syntax using/, pres(string) [replace dir(string)]
	
	mata: `pres'.run()
	
	/*
	mata: sp_find_structure(`pres')
	
	mata: sp_write_toc(`pres')
	
	mata: sp_init_bib(`pres')
	
	mata: sp_write_slides(`pres')
	*/
	Closingmsg, pres(`pres')
end

program define Closingmsg
	syntax, pres(string)
	
	mata st_local("dir", `pres'.settings.other.destdir)
	mata st_local("stub", `pres'.settings.other.stub)
	
	di as txt "{p}to view the presentation:{p_end}"
    di as txt "{p}first change the directory to where the presentation is stored:{p_end}"
    di `"{p}{stata `"cd "`dir'""'}{p_end}"'
	di as txt "{p}Then type:{p_end}"
	di `"{p}{stata "view `stub'.smcl"}{p_end}"'
end
