echo "Running for O0"
icc -O0 block_mm.c -o block -qopenmp
./block