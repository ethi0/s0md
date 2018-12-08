ls $(dirname $0) | egrep -v '(enc.sh|dec.sh|salt)' > list
for i in `cat list`; do
	r="$(dirname $0)/$i"
openssl enc -aes-256-cbc -salt -in $(dirname $0)/salt -out $r.enc -k improve
rm $r
done

