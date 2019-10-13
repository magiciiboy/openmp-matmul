#!/bin/sh
module load papi
module load tau

export TAU_MAKEFILE=$TAU/Makefile.tau-intelomp-icpc-papi-ompt-pdt-openmp
export TAU_OPTIONS='-optVerbose'
export MKL_DYNAMIC=FALSE

THREADS=(4 24 48 96)
NSIZES=(5000 10000 40000)

# Remove all previous PAPI file
rm PAPI_*.txt

for THREAD in ${THREADS[*]}; do
    export MKL_NUM_THREADS=$THREAD
    for S in ${NSIZES[*]}; do
        OUTER_THREADS_NAME=OUTER_THREADS_${THREAD}
        eval "OUTER_THREADS=(\"\${${OUTER_THREADS_NAME}[@]}\")"
        # OUTER_THREADS=${!OUTER_THREADS_NAME[@]}
        # echo ${OUTER_THREADS[@]}
        for OUTER_T in ${OUTER_THREADS[*]}; do
            INNER_T=$((THREAD/OUTER_T))
            printf "\n\n\n"
            echo "THREAD=$THREAD;SIZE=$S;OUTER=$OUTER_T;INNER=$INNER_T"
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

