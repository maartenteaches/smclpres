cd "d:\mijn documenten\onderwijs\konstanz\stata\mata\source"
cscript

// known to be true results
sysuse auto, clear
my_logit foreign
sum foreign, meanonly
assert reldif(_b[_cons], logit(r(mean))) < 1e-8

// if condition
sysuse auto, clear
keep if rep78 < 5
my_logit foreign weight
storedresults save mustbetrue e()

sysuse auto, clear
my_logit foreign weight if rep78 < 5
storedresults compare mustbetrue e()

storedresults drop mustbetrue

// weights
sysuse auto, clear
expand rep78
my_logit foreign weight
storedresults save mustbetrue e()

sysuse auto, clear
replace rep78 = 1 if rep78 == .
my_logit foreign weight [fweight=rep78]
storedresults compare mustbetrue e(), exclude(matrices: ml_scale ml_h gradient ilog) tolerance(1e-8)

storedresults drop mustbetrue

