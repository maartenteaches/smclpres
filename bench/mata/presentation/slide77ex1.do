mata:
mata clear
mata set matastrict on

hist = AssociativeArray()
hist.notfound(0)
fh = fopen("spd.txt", "r")

while ((line=fget(fh))!=J(0,0,"")) {
    line = tokens(line)
    for (i=1; i <= cols(line); i++) {
        freq = hist.get(line[i]) + 1
        hist.put(line[i], freq)
    }
}
fclose(fh)

hist.keys()[1..10,.]
hist.get("SPD")
end
