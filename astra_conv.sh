#!/bin/bash

ARGN=$#
ARGV=("$@")
# ${ARGV[0]}=$1

if [ $ARGN == 0 ]
then 
  echo "Error: no input file!"
  exit
elif [ $ARGN == 1 ]
then
  FNAME0=${ARGV[0]}
  FNAME1=${ARGV[0]}
elif [ $ARGN == 2 ]
then
  FNAME0=${ARGV[0]}
  FNAME1=${ARGV[1]}
elif [ $ARGN >2 ]
then
  echo "Error: two many input files!"
  exit
fi

echo $FNAME0,$FNAME1

TMP="tmp.dat"

awk '{if(NR==1) {zc=$3;pc=$6;tc=$7;printf "%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%4d%4d\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10} else if(NR>=2) {$3+=zc;$6+=pc;$7+=tc;printf "%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%4d%4d\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10}}' $FNAME0 > $TMP

(head -n 1 $TMP && tail -n +2 $TMP | sort -g -r -k 3) > $FNAME1
