*! version 4.0.1 MLB 23Feb2022
*  check if opening a slide is matched with closing a slide
*  and give appropriate error message when that is not the case  

program define smclpres, rclass
	version 14.2
	syntax using, [debug] *
	
	local olddir = c(pwd)
	
	local pres sp__presentation_class_instance
	mata: `pres' = smclpres()	
	
	capture noisily smclpres_main `using', `options' pres(`pres')
	
	if _rc {
		if `"`olddir'"' != `"`c(pwd)'"' {
			qui cd `olddir'
		}
		mata : `pres'.sp_fcloseall()
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
	
	Closingmsg, pres(`pres')
end

program define Closingmsg
	version 14.2
	syntax, pres(string)
	
	mata st_local("dir", `pres'.settings.other.destdir)
	mata st_local("stub", `pres'.settings.other.stub)
	
	di as txt "{p}to view the presentation:{p_end}"
    di as txt "{p}first change the directory to where the presentation is stored:{p_end}"
    di `"{p}{stata `"cd "`dir'""'}{p_end}"'
	di as txt "{p}Then type:{p_end}"
	di `"{p}{stata "view `stub'.smcl"}{p_end}"'
end
