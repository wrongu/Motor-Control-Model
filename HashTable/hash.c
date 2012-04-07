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
#include "mex.h"

 void retrieve_key( const mxArray* matptr, int& key){
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("missing third parameter (element index)\n");

	if( 1 != mxGetM(matptr) || !mxIsNumeric(matptr) || 1 != mxGetN(matptr) )
		mexErrMsgTxt("second parameter should be a unique integer array index\n");

	// retrieve index
	key = (int) mxGetScalar(matptr);
}
 
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
   
    
    int key1;
	retrieve_key( prhs[0], key1 );
    /*
	//Retrieve the arguments
    mxArray *keyPtr;
    int key1;
    keyPtr =  prhs[0];
    key1 = (int)(mxGetScalar(keyPtr));
  
	int key2;
    keyPtr =  prhs[1];
    key2 = (int)(mxGetScalar(keyPtr));
   
    //Convert two keys into one string
    unsigned char buffer[8];
    sprintf(buffer,"%d%d",key1key2);
    
    unsigned long hash = 5381;
    int c;

    while (c = *buffer++){
        hash = ((hash << 5) + hash) + c; 
    }

    //Return hash value as output
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*mxGetPr(plhs[0]) = hash;
    
    //Declarations
    mxArray *zData;
    int Num;

    //Copy input pointer z
    zData = prhs[0];

    //Get the Integer
    Num = (int)(mxGetScalar(zData));
    */
        
    //print it out on the screen
    printf("Your favorite integer is: %d",key1);
    
    
    return;
 }
#endif