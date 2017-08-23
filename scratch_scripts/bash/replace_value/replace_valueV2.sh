for file in $(ls *.cfg)
do
  awk 'NR==FNR {a[$1]=$2;next} {for ( i in a) gsub(i,a[i])}1' template $file >temp.txt
  mv temp.txt $file
done
