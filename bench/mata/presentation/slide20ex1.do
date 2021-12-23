sysuse nlsw88, clear
reg wage i.union i.race i.south grade ttl_exp

mata:
b = st_matrix("e(b)")
b
end
