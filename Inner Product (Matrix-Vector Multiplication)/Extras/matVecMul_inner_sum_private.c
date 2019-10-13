#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>
#include "size_m.h"
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
        int i, k;
	
        for (i = 0; i < N; i++) {
		vector_c[i]=0.0;
		#pragma omp parallel
		{	
			int j,id,nthrds;
			float sum;
			id = omp_get_thread_num();
			nthrds = omp_get_num_threads();
			for (j = id, sum=0.0; j < N; j+=nthrds) {
                        	sum += matrix_a[i][j] * vector_b[j];
			}
		
			#pragma omp critical
			vector_c[i] += sum;
		}
        }
}

int main(){
        int i,j;
        init_array();
	for(i=0; i<TH_CNT; i++){
                printf("Running for %d threads\n",THREADS[i]);
                omp_set_num_threads(THREADS[i]);
		double start = omp_get_wtime(); 
        	classic_vec_matmul();
		double end = omp_get_wtime();
//		display();
		printf("Time:%1.9f\n",end-start);
	}
}
