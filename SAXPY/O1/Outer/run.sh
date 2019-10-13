#!/bin/sh
module load papi
module load tau

export TAU_MAKEFILE=$TAU/Makefile.tau-intelomp-icpc-papi-ompt-pdt-openmp
export TAU_OPTIONS='-optVerbose'

THREADS=(4 24 28 96)
NSIZES=(5000 10000 40000)

# Remove all previous PAPI file
rm PAPI_*.txt

for THREAD in ${THREADS[*]}; do
    for S in ${NSIZES[*]}; do
        echo "\n\n\n"
        echo "THREAD=$THREAD;SIZE=$S"
        echo "CONFIG----------"
        printf "#define SIZE $S\n#define THREAD $THREAD\n" > size_single_loops.h
        echo "COMPILE---------------------------------------"
        echo "Using optimization O1"
        tau_cc.sh -O1 saxpy_outer_simple.c -o matmul -qopenmp > compile.out
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

