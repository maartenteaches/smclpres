mata:
mata clear

real rowvector my_mean(string scalar varn)
{
    varn = tokens(varn)
    k = cols(varn)
    mean = J(1,k,.)
    for (i=1; i<=k; i++) {
        if (st_isnumvar(varn[i])==0) exit(error(108))
        x = st_data(.,varn[i],0)
        mean[i] = sum(x)/rows(x)
    }
    return(mean)
}

end

sysuse auto
mata: my_mean("price mpg foreign rep78")
sum price mpg foreign rep78