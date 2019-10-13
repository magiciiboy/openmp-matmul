echo "--------------------------------------------------"
echo "Using optimization O0"
icc -O0 saxpy_outer_critical.c -o outer_critical -qopenmp
echo "-------------------------"
./outer_critical
echo "--------------------------------------------------"
# echo "--------------------------------------------------"
# echo "Using optimization O2"
# icc -O2 saxpy_outer_critical.c -o outer_critical -qopenmp
# echo "-------------------------"
# ./outer_critical
# echo "--------------------------------------------------"
# echo "--------------------------------------------------"
# echo "Using optimization O3"
# icc -O3 saxpy_outer_critical.c -o outer_critical -qopenmp
# echo "-------------------------"
# ./outer_critical
# echo "-------------------------"
# echo "--------------------------------------------------"
