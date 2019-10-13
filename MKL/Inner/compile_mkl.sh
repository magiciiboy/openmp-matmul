gcc -fopenmp -I$MKLROOT/include         \
          -Wl,-L${MKLROOT}/lib/intel64     \
          -lmkl_intel_lp64 -lmkl_core      \
          -lmkl_gnu_thread -lpthread       \
          -lm -ldl mklMul.c -o mkl1			\
          -DSIZE=40000
