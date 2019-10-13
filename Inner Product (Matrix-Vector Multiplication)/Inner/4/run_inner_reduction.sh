echo "--------------------------------------------------"
echo "Using optimization O1"
icc -O1 matVecMul_inner_reduction.c -o vec_red -qopenmp
echo "-------------------------"
./vec_red
echo "--------------------------------------------------"
