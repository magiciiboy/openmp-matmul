#!/bin/sh
module load papi
module load tau

export TAU_MAKEFILE=$TAU/Makefile.tau-intelomp-icpc-papi-ompt-pdt-openmp
export TAU_OPTIONS='-optVerbose'

THREADS=(4 24 48 96)
NSIZES=(1024 2048)
BLOCK_SIZES=(32 64 128 256 512)

# Remove all previous PAPI file
rm PAPI_*.txt

for THREAD in ${THREADS[*]}; do
    for S in ${NSIZES[*]}; do
        for BLOCK_SIZE in ${BLOCK_SIZES[*]}; do
            printf "\n\n\n"
            echo "THREAD=$THREAD;SIZE=$S;BLOCK_SIZE=$BLOCK_SIZE"
            echo "CONFIG----------"
            printf "#define MATRIX_SIZE $S\n#define THREAD $THREAD\n#define BLOCK_SIZE $BLOCK_SIZE" > config.h
            echo "COMPILE---------------------------------------"
            echo "Running for O0"
            tau_cc.sh -O0 block_mm.c -o matmul -qopenmp > compile.out
            # tau_cc.sh -O1 matVecMul_both_simple.c -o matmul -qopenmp > compile.out
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