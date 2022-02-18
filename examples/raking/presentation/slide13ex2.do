mata
data1940 = st_matrix("data1940")
row = st_data((1,5),3)
col = st_data((6,10),3)'
n = sum(data1940)
row = row:*n
col = col:*n
row
rowsum(data1940)
col
colsum(data1940)
end
