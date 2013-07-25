#!/bin/bash

ARGN=$#
ARGV=("$@")
# ${ARGV[0]}=$1

RT=1
RH=0

RT_list="1 0.9 0.8 0.6"

printf "%12s" z
for i in $RT_list
do
  r=`echo "scale=0;$i*100/1"|bc -l`
  printf "%12s%12s" "xem"$r "yem"$r
done
printf "\n"

#for var in `ls ast.*.001`
for i in {2..200..2}
do
  var=`printf "ast.%04d.001" $i`

  z=`head -n 1 $var | awk '{print $3}'`
  printf "%12s" $z

  for RT in $RT_list
  do
   r=`./astra_nemit.sh $var $RT $RH` 
   for x in $r
   do
     printf "%12s" $x
   done
  done
  printf "\n"  
done
