#!/bin/bash
if [ $# -eq 0 ]; then
    n_request=1
    maxload=100
elif [ $# -eq 1 ]; then
    n_request=$1
    maxload=100
elif [ $# -eq 2 ]; then
    n_request=$1
    maxload=$2
else
    echo "Usage: free_node.sh <N nodes> <Max Load>"
    exit
fi
list=$(qhost | sed '1,3d'  | sed 's/[[:blank:]]\{1,\}/,/g' | sed '/,-,/d' | sed 's/$/;/g' | sed '/ln0[1,2]/d' \
| sed '/^c[[:digit:]]\{5\}/d' \
| sed '/submit/d'  \
| sed '/io01/d'  \
| sed '/c0105/d' \
| sed '/c0119/d' \
| sed '/c0209/d' \
| sort -t ',' -k 4 -n  | head -n $n_request)
nodelist=""
count=0
for item in $(echo "$list" | sed 's/;/\n/g') ; do
    node=$(echo "$item" |  cut -d ',' -f 1)
    load=$(echo "$item" |  cut -d ',' -f 4)
    res=$(echo "$load>$maxload" | bc)
    if [ $res -ge 1 ]; then  ##if load > maxload
        break
    fi
    nodelist=${nodelist}${node}"\n"
    count=$(($count + 1))
done
nodelist=$nodelist"DONE of list free nodes: $count nodes is available"
echo -e $nodelist


