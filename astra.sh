#!/bin/bash

# $0 is the current script/function name
# $1 is obtained by ${ARGV[0]}

astra_conv(){ # return a file named FNAME1
    ARGN=$#
    ARGV=("$@")

    if [ $ARGN == 0 ];then
        echo "Error: no input file!"
        exit
    else
        if [ $ARGN == 1 ];then
            FNAME0=${ARGV[0]}
            FNAME1=${ARGV[0]}
        elif [ $ARGN == 2 ];then
            FNAME0=${ARGV[0]}
            FNAME1=${ARGV[1]}
        elif [ $ARGN >2 ];then
            echo "Error: two many input files!"
            exit
        fi
    fi

    #echo $FNAME0,$FNAME1

    TMP="tmp.dat"

    awk '{if(NR==1) {zc=$3;pc=$6;tc=$7;printf "%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%4d%4d\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10} else if(NR>=2) {$3+=zc;$6+=pc;$7+=tc;printf "%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%4d%4d\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10}}' $FNAME0 > $TMP

    (head -n 1 $TMP && tail -n +2 $TMP | sort -g -r -k 3) > $FNAME1
}

astra_forward(){ # return a file named FNAME1
    ARGN=$#
    ARGV=("$@")

    if [ $ARGN == 0 ];then
        echo "Error: no input file!"
        exit
    else
        if [ $ARGN == 1 ];then
            FNAME=${ARGV[0]}
        else
            echo "Error: two many input files!"
            exit
        fi
    fi

    #TMP="tmp.dat"
    #printf "%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%12.4E%4d%4d\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10
    awk 'BEGIN{cc=0}{if(NR==1) {zc=$3;pc=$6;tc=$7;} else if(NR>=2) {$3+=zc;$6+=pc;$7+=tc;if($6>0&&$3>0.1) cc++;}}END{print cc}' $FNAME
    #(head -n 1 $TMP && tail -n +2 $TMP | sort -g -r -k 3) > $FNAME1
}

astra_nemit(){ # return (xemit yemit)
    ARGN=$#
    ARGV=("$@")

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
}

astra_nemit_post(){ # return (z xem100 yem100 ...)
    ARGN=$#
    ARGV=("$@")

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

    #for var in `ls ast.0*.001`
    for i in {2..200..2}
    do
        var=`printf "ast.%04d.001" $i`

        if [ ! -f $var ];
        then
            continue
        fi

        z=`head -n 1 $var | awk '{print $3}'`
        printf "%12s" $z

        for RT in $RT_list
        do
            r=`astra_nemit $var $RT $RH` 
            for x in $r
            do
                printf "%12s" $x
            done
        done
        printf "\n"  
    done
}
