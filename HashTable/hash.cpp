//Divya Gunasekaran
//May 16, 2011
//Hash function


//------------------------------- MATLAB -------------------------------------//
 #define toSysout(...) printf(__VA_ARGS__)
 #define exit_with_error(...)           \
 do {                                   \
		 fprintf(stdout, "Error: ");    \
		 fprintf(stdout, __VA_ARGS__ ); \
		 fprintf(stdout, "\n" );        \
		 exit(1);                       \
 } while(0)
#ifdef MATLAB_MEX_FILE
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "mex.h"

 void retrieve_num( const mxArray* matptr, int& num){
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("missing third parameter (element index)\n");

	if( 1 != mxGetM(matptr) || !mxIsNumeric(matptr) || 1 != mxGetN(matptr) )
		mexErrMsgTxt("second parameter should be a unique integer array index\n");

	// retrieve index
	num = (int) mxGetScalar(matptr);
}
 
//Compute hash index given 2 integer keys and size of hash table
//Hash function is the djb2 algorithm, first reported by Dan Bernstein in comp.lang.c
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
   
    //Make sure number of inputs is correct
    if( nrhs!=3 )
		mexErrMsgTxt("This function requires 3 arguments\n");
    
    //Retrieve inputs
    int key1;
	retrieve_num( prhs[0], key1 );
    
    int key2;
    retrieve_num( prhs[1], key2 );
    
    int numSlots;
    retrieve_num( prhs[2], numSlots );
  
    //Convert two keys into one string
    char* buffer = (char *)malloc(8);
    sprintf(buffer,"%d %d",key1,key2);
    
    //djb2 algorithm -- first reported by Dan Bernstein in comp.lang.c
    unsigned long hash = 5381;
    int c;

    while ((c = *buffer++)!=0){
        hash = ((hash << 5) + hash) + c; 
    }
    
    int index = hash % numSlots;
    
    // return output
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*mxGetPr(plhs[0]) = index;

    return;
 }
#endif