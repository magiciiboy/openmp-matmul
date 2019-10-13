#!/bin/sh
module load papi
module load tau

export TAU_MAKEFILE=$TAU/Makefile.tau-intelomp-icpc-papi-ompt-pdt-openmp
export TAU_OPTIONS='-optVerbose'

THREADS=(4 24 48 96)
NSIZES=(5000 10000 40000)

OUTER_THREADS_4=(2)
OUTER_THREADS_24=(1 4 24)
OUTER_THREADS_48=(1 8 48)
OUTER_THREADS_96=(1 4 96)

for THREAD in ${THREADS[*]}; do
    for S in ${NSIZES[*]}; do
        OUTER_THREADS_NAME=OUTER_THREADS_${THREAD}
        eval "OUTER_THREADS=(\"\${${OUTER_THREADS_NAME}[@]}\")"
        # OUTER_THREADS=${!OUTER_THREADS_NAME[@]}
        # echo ${OUTER_THREADS[@]}
        for OUTER_T in ${OUTER_THREADS[*]}; do
            INNER_T=$((THREAD/OUTER_T))
            printf "\n\n\n"
            echo "THREAD=$THREAD;SIZE=$S;OUTER=$OUTER_T;INNER=$INNER_T"
            echo "CONFIG----------"
            printf "#define SIZE $S\n#define THREAD $THREAD\n#define OUTER_THREADS $OUTER_T\n#define INNER_THREADS $INNER_T" > size_both_loops.h
            echo "COMPILE---------------------------------------"
            echo "Using optimization O1"
            tau_cc.sh icc -O1 saxpy_both_simple.c -o matmul -qopenmp > compile.out
            echo "PAPI--------------------"
            sh ./papi_event.sh
            echo "SUMMARY-----------------------------------------"
            tau_exec -T OPENMP ./matmul
            echo "---------------------------"
            pprof
            echo "RAPL"
            echo "----------------------------"
            icc -Wall -O2 rapl-read.c -o rapl-read
            ./rapl-read | grep package-0
            ./rapl-read | grep package-0
            ./rapl-read | grep package-0
        done
    done
done

