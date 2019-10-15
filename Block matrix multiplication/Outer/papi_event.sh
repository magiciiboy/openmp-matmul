# export TAU_MAKEFILE=$TAU/Makefile.tau-intelomp-icpc-papi-ompt-pdt-openmp
export TAU_MAKEFILE=$TAU/Makefile.tau-intelomp-icpc-papi-ompt-pdt-openmp
export TAU_OPTIONS='-optVerbose'
printf  "\n-------------------------------\nEvaluation Begin\n-------------------------------\n"

RunCount=("1", "2", "3")

printf "\nGathering General Metrics\n"
EventArray=("PAPI_SP_OPS" )
for val in ${EventArray[*]}; do
    printf "\nEvaluating code for: $val\n"
    for no in ${RunCount[*]}; do
        export TAU_METRICS=$val
        ./matmul
        # pprof
        pprof > $val.txt
        echo 'Summary'
        python papi_extract.py ${val}.txt >> ${val}_summary.txt
    done
    cat ${val}_summary.txt
	printf "\n---------------------------------------------------------------------------------------\n"
done

printf "\nGathering L1 Cache Behavior\n"
EventArray=("PAPI_L1_TCM")
for val in ${EventArray[*]}; do
	printf "\nEvaluating code for: $val\n"
    for no in ${RunCount[*]}; do
        export TAU_METRICS=$val
        ./matmul
        # pprof
        pprof > $val.txt
        echo 'Summary'
        python papi_extract.py ${val}.txt >> ${val}_summary.txt
    done
    cat ${val}_summary.txt
	printf "\n---------------------------------------------------------------------------------------\n"
done


printf "\nGathering L2 Cache Behavior\n"
EventArray=("PAPI_L2_TCM")
for val in ${EventArray[*]}; do
    printf "\nEvaluating code for: $val\n"
    for no in ${RunCount[*]}; do
        export TAU_METRICS=$val
        ./matmul
        # pprof
        pprof > $val.txt
        echo 'Summary'
        python papi_extract.py ${val}.txt >> ${val}_summary.txt
    done
    cat ${val}_summary.txt
	printf "\n---------------------------------------------------------------------------------------\n"
done


printf "\nGathering L3 Cache Behavior\n"
EventArray=("PAPI_L3_TCM")
for val in ${EventArray[*]}; do
    printf "\nEvaluating code for: $val\n"
    for no in ${RunCount[*]}; do
        export TAU_METRICS=$val
        ./matmul
        # pprof
        pprof > $val.txt
        echo 'Summary'
        python papi_extract.py ${val}.txt >> ${val}_summary.txt
    done
    cat ${val}_summary.txt
	printf "\n---------------------------------------------------------------------------------------\n"
done

printf "\n-------------------------------\nEvaluation Complete\n-------------------------------\n"