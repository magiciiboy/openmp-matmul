echo "--------------------------------------------------"
echo "Using optimization O1"
icc -O1 matVecMul_outer_simple.c -o vec_outer -qopenmp
echo "-------------------------"
./vec_outer
echo "--------------------------------------------------"
