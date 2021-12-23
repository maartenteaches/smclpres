mata:
mata clear

real scalar my_mean(string scalar varn)
{
    if (st_isnumvar(varn)==0) exit(error(108))
    x = st_data(.,varn,0)
    return(sum(x)/rows(x))
}

end

sysuse auto
mata: my_mean("price")
sum price