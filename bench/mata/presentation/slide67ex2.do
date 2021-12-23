mata:
data = st_data(.,"ego alter sign")

friends = J(16,1,&J(1,0,.))
enemies = J(16,1,&J(1,0,.))
for(i=1; i<=rows(data); i++) {
    if (data[i,3] == 1) {
        friends[data[i,1]] = &(*friends[data[i,1]], data[i,2])
        friends[data[i,2]] = &(*friends[data[i,2]], data[i,1])
    }
    else {
        enemies[data[i,1]] = &(*enemies[data[i,1]], data[i,2])
        enemies[data[i,2]] = &(*enemies[data[i,2]], data[i,1])
    }
}

*enemies[1]
*friends[1]
*enemies[16]
*friends[16]
end
