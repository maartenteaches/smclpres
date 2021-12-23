tempname realnumber
local nirv "here we are now, entertain us"
mata:
st_local("nirv")
st_local("greetings", "Hello")
st_local("number", strofreal(42))
st_numscalar(st_local("realnumber"), 42)
end
di "`greetings'"
di `number'
di `realnumber'
