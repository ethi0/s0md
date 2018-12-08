sed -i '/limit_conn_zone $binary_remote_addr zone=two:10m;/s/^#\+//' $1
sed -i '/limit_zone two $binary_remote_addr 10m;/s/^/#/' $1
sed -i '/#limit_conn_zone $binary_remote_addr zone=twoB:10m;/s/^#\+//' $1
sed -i '/limit_zone twoB $binary_remote_addr 10m;/s/^/#/' $1
