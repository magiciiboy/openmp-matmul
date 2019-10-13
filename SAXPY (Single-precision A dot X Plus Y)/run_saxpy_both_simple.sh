echo "--------------------------------------------------"
echo "Using optimization O1"
icc -O1 saxpy_both_simple.c -o both_simple -qopenmp
echo "-------------------------"
./both_simple
echo "--------------------------------------------------"