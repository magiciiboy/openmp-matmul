echo "--------------------------------------------------"
echo "Using optimization O1"
icc -O1 saxpy_outer_simple.c -o outer_simple -qopenmp
echo "-------------------------"
./outer_simple
echo "--------------------------------------------------"