This directory has following contents:
1. Directory: Block matrix multiplication - Contains block matrix multiplication code.
2. Directory: Inner Product (Matrix-Vector Multiplication) - Contains inner product formulation codes along with necessary README's.
3. Directory: SAXPY (Single-precision A dot X Plus Y) - Contains SAXPY codes along with necessary README's.
4. mklMul.c : Intel MKL code.
5. compile_mkl.sh : Script to compile mklMul.c

-------------------------------------------------------
Comparison of your code's performance with MKL
-------------------------------------------------------

In the assignment you are required to compare the performance of your codes with that of MKL.

This requires you to get performance (FLOPs) and Power measurement of MKL for different number of threads. You can gather these values just once and use them for comparison.

IMPORTANT NOTE: MKL utilizes the number of threads defined in the environment variable: MKL_NUM_THREADS
=> To set the number of threads that MKL should use:
	[cXYZ-ABC]$ export MKL_NUM_THREADS=<NUM_THREADS>

-------------------
Getting SP_OPS for MKL:
-------------------

	> Set the number of MKL threads using the method mentioned above.

	> Configure TAU_MAKEFILE and TAU_METRICS as required.
	
	> Compile mklMul.c using TAU. Replace the "gcc" call in "compile_mkl.sh" with "tau_cc.sh".

	> Run the TAU generated executable as:
		[cXYZ-ABC]$ tau_exec -T OPENMP ./<executable>

	> The generated profiles can be read using "pprof".

	> You are to report the INCLUSIVE COUNTS for "OpenMP_IMPLICIT_TASK" from the section "FUNCTION SUMMARY (total)".

-------------------
Power Measurement
-------------------
>> As we know, the nodes on Stampede2 have 2 sockets, each containing a skylake processor with 24 cores (48 threads with hyperthreading).
	
	> So, we will run the thread cases with threads less than or equal to 48 on just one socket using process pinning for easily measuring power.
		- We will use "numactl" command for process pinning instead of "taskset" to pin our process on Socket 0.
		
		- You will report power consumption for only the package (package-0 in this case) you pinned your process on, as shown in the example below.

	> For case with 96 threads, set the environment variable MKL_NUM_THREADS=96 to use all available 96 threads, hence no process pinning is required.
		- Modify the call to "system()" in rapl-read.c to just contain: system("./<executable>")
		
		- You will report power consumption for both packages in this case.

>> Example: to use process pinning
	
	> Set the number of MKL threads using the method mentioned above.

	> Compile mklMul.c using "compile_mkl.sh".

	> Now modify the call to "system()" in rapl-read.c" at line 858 to include process pinning command as follows:
		- system("numactl --cpunodebind=0 --membind=0 ./mkl");

	> Now compile "rapl-read.c":
		- [cXYZ-ABC]$ icc -Wall -O2 rapl-read.c -o rapl-read

	> Run "rapl-read":
		- [cXYZ-ABC]$ ./rapl-read

	> rapl-read will now run your program on Socket 0, and the energy consumption of "package-0" is the consumption of your program.


sbatch -p skx-normal -N 1 -n 48 -t 30 -o ./output_1A.txt ./run.sh

4 threads: 2/2
24 threads: 1/24, 4/6, 24/1
48 threads: 1/48, 8/6, 48/1
96 threads: 1/96, 4/24, 96/1