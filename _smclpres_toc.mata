mata:
void smclpres::count_slides() {
	real scalar i, snr, regsl
	string rowvector line

	snr   = 0
	regsl = 0
	for(i=1; i<=rows(source); i++) {
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
end