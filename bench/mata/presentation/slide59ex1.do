sysuse auto, clear
sum price
gen expensive = price > r(mean) if price < .
my_logit foreign i.expensive weight
logit foreign i.expensive weight 
