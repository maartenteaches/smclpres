mata:
mata clear

real scalar my_mean(string scalar varn)
{
    x = st_data(.,varn,0)
    return(sum(x)/rows(x))
}

end

sysuse auto
mata: my_mean("price")
sum price