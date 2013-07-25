#!/bin/bash

# $0 is the current script/function name
# $1 is obtained by ${ARGV[0]}

fish2astra(){
    ARGN=$#
    ARGV=("$@")

    if [ $ARGN == 0 ];then
        IN="OUTSF7.TXT"
    else
        if [ $ARGN == 1 ];then
            IN=${ARGV[0]}
        elif [ $ARGN > 1 ];then
            echo "Error: two many input files!"
            exit
        fi
    fi
    #echo $FNAME
    if [ -s $IN ];then
        #awk '{printf "%lf  %lf\n",$1/100,$3}' $IN | tail -n +35 | head -n -1 | awk 'BEGIN{max=0}{for(i=1;i<=NF;i++){a[NR,i]=$i} if($2>max) max=$2;}END{for(i=1;i<NR;i++){printf "%lf  %lf  \n",a[i,1],a[i,2]/max}}'
        tail -n +34 $IN | head -n -1 | awk 'BEGIN{max=0}{a[NR,1]=$1;a[NR,2]=$3;if($3>max) max=$3;}END{for(i=1;i<=NR;i++){printf "%lf  %lf  \n",a[i,1]/100,a[i,2]/max}}'
    fi
}
