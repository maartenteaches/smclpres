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
end