clear all

mata:

void notallowed(string scalar cmd, string scalar opt, string scalar arg, string scalar file, string scalar line) 
{
	string scalar errmsg
	errmsg = "{p}{err}option {res}" + opt
	if (arg != "") {
		errmsg = errmsg +"(" + arg + ")"
	}
	errmsg = errmsg + "{err} not allowed in {res}//layout " + cmd + "{p_end}"
	printf(errmsg)
	errmsg = "{p}{err}This error occured on line " + line + " of  file " + file +"{p_end}"
	printf(errmsg)
	exit(198)
}

option_parse = AssociativeArray()
option_parse.reinit("string", 2)
option_parse.notfound(&notallowed())

key = "toc", "bla"
(*option_parse.get(key))("toc", "bla", "", "blup.mata" , "5")


end