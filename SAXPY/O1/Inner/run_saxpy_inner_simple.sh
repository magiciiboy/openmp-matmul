echo "--------------------------------------------------"
echo "Using optimization O1"
icc -O1 saxpy_inner_simple.c -o inner_simple -qopenmp
echo "-------------------------"
./inner_simple
echo "--------------------------------------------------"