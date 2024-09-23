function remDuplicates() {
sha256sum $1*.jpg -b | awk 'BEGIN{FS="*"} {if (counts[$1]>=1){system("rm \""$2"\"")} else {counts[$1]++; names[$1]=$2}} END {for (key in counts) print counts[key], key, names[key]}'
}
export -f remDuplicates