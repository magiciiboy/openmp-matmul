echo "--------------------------------------------------"
echo "Using optimization O1"
icc -O1 matVecMul_both_simple.c -o vec_both -qopenmp
echo "-------------------------"
./vec_both
echo "--------------------------------------------------"
