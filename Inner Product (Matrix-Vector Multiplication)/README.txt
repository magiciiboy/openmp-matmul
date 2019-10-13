This directory has following contents:
1. matVecMul.c : Matrix-vector multiplication without any parallelization.
2. matVecMul_both_simple.c : Matrix-vector multiplication with both loops parallelized.
3. matVecMul_inner_reduction.c : Matrix-vector multiplication with inner loop parallelized.
4. matVecMul_outer_simple.c : Matrix-vector multiplication with outer loop parallelized.
5. run_*.sh : Scripts that compile and run the above codes.
6. size_single_loops.h : Header file that defines the matrix/vector size, thread cases for single loop parallelization case.
6. size_both_loops.h : Header file that defines the matrix/vector size, thread case for both loops parallelization case.
7. Extras (directory) : Contains Matrix-vector multiplication with some advanced openMP clauses.
8. rapl-read.c

-----------------------------------------------------------------------------------------------------+
-----------------------------------------------------------------------------------------------------+
Getting Execution time

=>> Execution time can be gathered using the scripts provided for all thread cases in one execution.
-----------------------------------------------------------------------------------------------------+

>> To get execution times, run the scripts named as 
	> "run_<parallelization_strategy>.sh"

	These scripts compile the code and run the codes for the Matrix size and ALL thread cases defined in "size_*.h".

>> For the code with parallelizing both loops, you will need to change the number of threads for inner and outer loops based on the thread strategy defined in assignment doc:
	
	> To do this: Just modify the values for "OUTER_THREADS" and "INNER_THREADS" inside the "size_both_loops.h" header.

	> IMPORTANT: OpenMP does not by default execute nested parallel regions. To get nested parallel regions to work, set the environment variable OMP_NESTED to 1 as:
		- [cXYZ-ABC]$ export OMP_NESTED=1


----------------------------------------------------------------------------------------------------------------------------+
----------------------------------------------------------------------------------------------------------------------------+
Getting Single precision ops and cache behavior

=>> For getting these metrics, you will run the codes for each thread case individually, unlike running for all thread cases while gathering execution time.
----------------------------------------------------------------------------------------------------------------------------+

>> You will use TAU as an interface to PAPI events just like previous assignments.
 
>> Configure TAU_MAKEFILE and TAU_METRICS and other TAU environment variables just like previous assignments.

>> As said above, you will gather metrics for each thread case individually, for example: if you want the above mentioned metrics for "matVecMul_outer_simple.c":

	> Just have ONE thread case inside "size_single_loops.h" as:
		- #define SIZE 10000
		- int THREADS[] = {48};
		- #define TH_CNT 1

	> Now compile the code using TAU with "-fopenmp" flag:
		- [cXYZ-ABC]$ tau_cc.sh -fopenmp matVecMul_outer_simple.c -o out_simple_tau

	> Running the generated executable:
		- [cXYZ-ABC]$ tau_exec -T OPENMP ./out_simple_tau

	> Reading the generated profiles:
		- TAU will generate "X" number of profiles. Where "X" is the number of threads used. Each profile will contain metrics measurements for one thread.

		- You can read all profiles in one go using the "pprof" command.

		- You are to report the INCLUSIVE COUNTS for "OpenMP_IMPLICIT_TASK" from the section "FUNCTION SUMMARY (total)".

----------------------------------------------------------------------------------------------------------------------------+
----------------------------------------------------------------------------------------------------------------------------+
Getting power measurements

=>> Again for power measurements as well, you will run the codes for each thread case individually
----------------------------------------------------------------------------------------------------------------------------+

>> As we know, the nodes on Stampede2 have 2 sockets, each containing a skylake processor with 24 cores (48 threads with hyperthreading).
	
	> So, we will run the thread cases with threads less than or equal to 48 on just one socket using process pinning for easily measuring power.
		- We will use "numactl" command for process pinning instead of "taskset" to pin our process on Socket 0.
		
		- You will report power consumption for only the package (package-0 in this case) you pinned your process on, as shown in the example below.

	> For case with 96 threads, the code will automatically try to use all available 96 threads, hence no process pinning is required.
		- Modify the call to "system()" in rapl-read.c to just contain: system("./<executable>")
		
		- You will report power consumption for both packages in this case.

>> Example: to use process pinning, for "matVecMul_outer_simple.c":
	
	> Again, just have ONE thread case inside "size_single_loops.h" as:
		- #define SIZE 10000
		- int THREADS[] = {48};
		- #define TH_CNT 1

	> Compile your code just like normal:
		- [cXYZ-ABC]$ icc -O1 matVecMul_outer_simple.c -o out_simple

	> Now modify the call to "system()" in rapl-read.c" at line 858 to include process pinning command as follows:
		- system("numactl --cpunodebind=0 --membind=0 ./out_simple");

	> Now compile "rapl-read.c":
		- [cXYZ-ABC]$ icc -Wall -O2 rapl-read.c -o rapl-read

	> Run "rapl-read":
		- [cXYZ-ABC]$ ./rapl-read

	> rapl-read will now run your program on Socket 0, and the energy consumption of "package-0" is the consumption of your program.