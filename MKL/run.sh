#!/bin/sh
module load papi
module load tau

export MKL_DYNAMIC=FALSE

# THREADS=(4 24 48 96)
THREADS=(24 48 96)
NSIZES=(5000 10000 40000)

# Remove all previous PAPI file
rm PAPI_*.txt

for THREAD in ${THREADS[*]}; do
    export MKL_NUM_THREADS=$THREAD
    for S in ${NSIZES[*]}; do
        printf "\n\n\n"
        echo "THREAD=$THREAD;SIZE=$S;"
        echo "COMPILE---------------------------------------"
        echo "Using optimization MKL"
        tau_cc.sh -fopenmp -I$MKLROOT/include         \
                -Wl,-L${MKLROOT}/lib/intel64     \
                -lmkl_intel_lp64 -lmkl_core      \
                -lmkl_gnu_thread -lpthread       \
                -lm -ldl mklMul.c -o matmul		\
                -DSIZE=$S > compile.out
        echo "PAPI--------------------"
        sh ./papi_event.sh
        # echo "SUMMARY-----------------------------------------"
        # tau_exec -T OPENMP ./matmul
        # echo "---------------------------"
        # pprof
        echo "RAPL"
        echo "----------------------------"
        icc -Wall -O2 rapl-read.c -o rapl-read
        ./rapl-read | grep package-0
        ./rapl-read | grep package-0
        ./rapl-read | grep package-0
    done
done

