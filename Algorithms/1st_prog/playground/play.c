#include <stdint.h>
#include<stdio.h>
#include<stdlib.h>

int main()
{	int N,K,sum=0,limit;
	long long r=0;
	int32_t **a,temp;
	char c;
    
    if (  scanf("%d %d",&N,&K) < 0 ) {
    	printf("Error reading values from file 1");
    	return -1;
    }  

    a = (int32_t**)malloc(N*sizeof(int32_t*)); // 2d array
    if (a == NULL) {
    	printf("Not enough Memory for array A\n");
    	return -1;
    }   
    
	a[0] = (int32_t*)malloc(N*sizeof(int32_t));
    if (a[0] == NULL) {
    	printf("Not enough Memory for array B\n");
    	return -1;
    }
    if (scanf("%c",&c) < 0){
    	printf("Error reading values from file 1.5");
    	return -1;
    } 
	while(((int)c)==10) scanf("%c", &c);  
    a[0][0] =(int) (c - '0');
    if (a[0][0]==K) r++;    
    for (int j=1; j<N; j++){
    	if (scanf("%c",&c) < 0){
    		printf("Error reading values from file 2");
    		return -1;
    	}
		while(((int)c)==10) scanf("%c", &c);    	
		temp = c - '0';     	
    	a[0][j]=temp + a[0][j-1];
    	if (a[0][j]==K) r++;	 
	}
	
    for (int i=1; i<N; i++){
		a[i] = (int32_t*)malloc(N*sizeof(int32_t));
    	if (a[i] == NULL) {
    		printf("Not enough Memory for array B\n");
    		return -1;
    	}
    	if (scanf("%c",&c) < 0){
    		printf("Error reading values from file 2.5");
    		return -1;
    	} 
		while(((int)c)==10) scanf("%c", &c);   
    	a[i][0] = c - '0'; 
    	a[i][0]+=a[i-1][0];
    	if (a[i][0]==K) r++;
    	for (int j=1; j<N; j++){
    		if (scanf("%c",&c) < 0){
    			printf("Error reading values from file 3");
    			return -1;
    		}
    		while(((int)c)==10) scanf("%c", &c);
			temp =c - '0';     	
    		a[i][j]=temp + a[i-1][j] + a[i][j-1] - a[i-1][j-1];	
    		if (a[i][j]==K) r++;
    	}
    }
	// end of input

	for(int upj=1; upj<N; upj++){
		limit=N;
		for (int downi=0; downi<N; downi++){
			int downj=upj;
			while (downj<limit){
				sum = a[downi][downj] - a[downi][upj-1];
				if (sum == K) r++;
				else if (sum > K){ limit = downj; break;}
				downj++;			
			}
		if (limit==upj) break;		
		}
	}	
	for (int upi=1; upi<N; upi++){
		limit=N;
		for (int downi=upi; downi<N; downi++){
			int downj=0;
			while(downj<limit) {
				sum = a[downi][downj] - a[upi-1][downj];
				if (sum == K) r++;
				else if (sum > K){ limit = downj; break;}
				downj++;			
			}
			if (limit==0) break;				
		}
		for(int upj=1; upj<N; upj++){
			limit=N;
			for (int downi=upi; downi<N; downi++){
				int downj=upj; 
				while (downj<limit)	{
					sum = a[downi][downj] - a[downi][upj-1] - a[upi-1][downj] + a[upi-1][upj-1];
					if (sum == K) r++;	
					else if (sum > K){ limit = downj; break;}
					downj++;		
				}
			if (limit==upj ) break;		
			}
		}		
	}	
	//start of output
	printf("%lld\n",r);
	for (int i=0; i<N; i++)
		free(a[i]);
	free(a);	
	return 0;	
}