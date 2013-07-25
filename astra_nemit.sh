#!/bin/bash

ARGN=$#
ARGV=("$@")
# ${ARGV[0]}=$1

RT=1
RH=0

g_mec2=511000
g_mec22=511000**2

if [ $ARGN -eq 0 ];then 
  echo "Error: no input file!"
  exit
else
  if [ $ARGN -ge 1 ];then
    FNAME=${ARGV[0]}
  fi
  if [ $ARGN -ge 2 ];then
    RT=${ARGV[1]}
  fi
  if [ $ARGN -ge 3 ];then
    RH=${ARGV[2]}
  fi
fi

CNT=`expr 10000*$RT`
CNH=`expr 10000*$RH`

#echo $FNAME,$CNT,$CNH

awk '{if(NR==1) {zc=$3} else if(NR>=2) {$3+=zc;printf "%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E\n",$1,$2,$3,$4,$5,$6}}' $FNAME \
| sort -g -r -k 3 \
| awk 'BEGIN{cc=0;x2=0;y2=0;bgx2=0;bgy2=0;xbgx=0;ybgy=0} {if(NR>='$CNH' && NR<='$CNT') {cc++;x2+=$1*$1;y2+=$2*$2;bgx2+=$4*$4/'$g_mec22';bgy2+=$5*$5/'$g_mec22';xbgx+=$1*$4/'$g_mec2';ybgy+=$2*$5/'$g_mec2'}} END{x2=x2/cc;y2=y2/cc;bgx2=bgx2/cc;bgy2=bgy2/cc;xbgx=xbgx/cc;ybgy=ybgy/cc;xn=1e6*sqrt(x2*bgx2-xbgx*xbgx);yn=1e6*sqrt(y2*bgy2-ybgy*ybgy);printf "%12.4E%12.4E",xn,yn}'
