#define SIZE 40000					//Matrix/vector size
int THREADS[] = {96};				//Number of threads
#define TH_CNT 1					//Number of cases for threads (length of "THREADS" array above.)
#define OUTER_THREADS 48			//Threads for outer loop
#define INNER_THREADS 48			//Threads for inner loop