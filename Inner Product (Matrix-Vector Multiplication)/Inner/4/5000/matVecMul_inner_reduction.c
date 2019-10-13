#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>
#include "size_single_loops.h"
#define N SIZE
float matrix_a[N][N];
float vector_b[N];
float vector_c[N];

void init_array()
{
    int i, j;

    for (i = 0; i < N; i++) {
     	vector_b[i] = (1+(i)%1024)/2.0;
	for (j = 0; j < N; j++) {
            matrix_a[i][j] = (1+(i*j)%1024)/2.0;
        }
    }
}

void display()
{
    int i, j;

    for (i = 0; i < N; i++) {
        for(j = 0; j < N; j++){
                printf("%f ",matrix_a[i][j]);
        }
        printf("\n");
    }
    printf("B\n");
    for(i=0; i<N; i++){
        printf("%f ",vector_b[i]);
    }
    printf("\nC\n");
    for(i=0; i<N; i++){
        printf("%f ",vector_c[i]);
    }
    printf("\n");
}

void classic_vec_matmul()
{       
        int i;
	
        for (i = 0; i < N; i++) {
		vector_c[i]=0.0;
		float sum=0.0;
		#pragma omp parallel
		{	
			int j;
			#pragma omp for reduction(+:sum)
			for (j = 0; j < N; j++) {
                        	sum += matrix_a[i][j] * vector_b[j];
			}
			vector_c[i] = sum;
		}
        }
}

int main(){
    init_array();
    printf("Running for %d threads\n",THREAD);
    omp_set_num_threads(THREAD);
    double start = omp_get_wtime(); 
    classic_vec_matmul();
    double end = omp_get_wtime();
    printf("Time:%1.9f\n",end-start);
}
