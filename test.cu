#include <stdio.h>
#include <stdint.h>
#include "sha1.cu"

#define HASH_SIZE 20
#define MESSAGE_SIZE 2

__global__
void cudaHash(
	unsigned char* hash,
	const unsigned char* message,
	int length
)
{	
	printf("in kernel\n");
	SHA1(hash,message,length);
	printf("Message: %s\n",message);
	printf("Hash: ");
	for(int i=0;i<20;i++)
		printf("%02x",hash[i]);
	printf("\n");
	printf("leaving kernel\n");
}



int main(){
	//computing the hash with verified libraries for error checking
	const unsigned char *message = (const unsigned char *)"aa";
	unsigned char hash[HASH_SIZE];

	unsigned char* d_message,*d_hash;
	cudaMalloc( &d_message,MESSAGE_SIZE*sizeof(unsigned char) );
	cudaMalloc( &d_hash,HASH_SIZE*sizeof(unsigned char) );
	cudaMemcpy(d_message,message,MESSAGE_SIZE*sizeof(unsigned char),
		cudaMemcpyHostToDevice);

	cudaHash<<<1,1>>>(d_hash,d_message,MESSAGE_SIZE);

	cudaMemcpy(hash,d_hash,HASH_SIZE*sizeof(unsigned char),
		cudaMemcpyDeviceToHost);
	cudaFree(d_hash);
	cudaFree(d_message);

	//SHA1(hash,message, MESSAGE_SIZE);
	printf("Message: %s\n",message);
	printf("Hash: ");
	for(int i=0;i<20;i++)
		printf("%02x",hash[i]);
	printf("\n");


	return 0;
}