#!/bin/bash
# wrote by: yangbing 
# date:20230707 
# version:1 
for fa in $(cat faList.txt)
do
  dir=`basename $fa .pep.all.fa`
  mkdir -p result/$dir
  for rbd in $(cat hmmList.txt)
  do
        echo "=============================================processing $rbd============================================================"
        name=`basename $rbd .hmm`
        hmmsearch --cut_tc --cpu 20 --domtblout $name\.out ./hmmAlign/$name\.hmm ./fa/$fa
        grep -v "#" $name\.out | awk '($7 + 0) < 0.01'|cut -f1 -d  " "|sort -u > $name\_qua_id.txt
        seqtk subseq ./fa/$fa $name\_qua_id.txt > $name\_qua.fa
        mkdir -p result/$dir/$name
        mv $name* result/$dir/$name
        echo "===========================================$rbd done!==================================================================="
        echo "                   "
        echo "                   "
  done
  echo "================================================$fa done!====================================================================="
  echo "                  "
  echo "                  "
done
