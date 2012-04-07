//==============================================================================
// Name        : pq_pushMin.cpp
// Author      : Andrea Tagliasacchi
// Version     : 1.0
// Copyright   : 2009 (c) Andrea Tagliasacchi
// Description : inserts a new element in the priority queue
// May 22, 2009: Created
// Modified by Divya Gunasekaran on May 2, 2011 to push onto a min priority queue
//==============================================================================

#include "MyHeap.h"

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
#include "mex.h"

void retrieve_heap( const mxArray* matptr, MinHeap<double>* & heap){
    // retrieve pointer from the MX form
    double* pointer0 = mxGetPr(matptr);
    // check that I actually received something
    if( pointer0 == NULL )
        mexErrMsgTxt("vararg{1} must be a valid priority queue pointer\n");
    // convert it to "long" datatype (good for addresses)
    long pointer1 = (long) pointer0[0];
    // convert it to "KDTree"
    heap = (MinHeap<double>*) pointer1;
    // check that I actually received something
    if( heap == NULL )
        mexErrMsgTxt("vararg{1} must be a valid priority queue pointer\n");
}
void retrieve_index( const mxArray* matptr, int& index){
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("missing second parameter (element index)\n");

	if( 1 != mxGetM(matptr) || !mxIsNumeric(matptr) || 1 != mxGetN(matptr) )
		mexErrMsgTxt("second parameter should be a unique integer array index\n");

	// retrieve index
	index = (int) mxGetScalar(matptr);

	if( index % 1 != 0 )
		mexErrMsgTxt("the index should have been an integer!\n");
}
void retrieve_cost( const mxArray* matptr, double& cost){
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("missing third or fourth parameter (element index)\n");

	if( 1 != mxGetM(matptr) || !mxIsNumeric(matptr) || 1 != mxGetN(matptr) )
		mexErrMsgTxt("second parameter should be a unique integer array index\n");

	// retrieve cost
	cost = (double) mxGetScalar(matptr);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	if( nrhs!=4 )
		mexErrMsgTxt("This function requires 3 arguments\n");
	if( !mxIsNumeric(prhs[0]) )
		mexErrMsgTxt("parameter 1 missing!\n");
	if( !mxIsNumeric(prhs[1]) )
		mexErrMsgTxt("parameter 2 missing!\n");
	if( !mxIsNumeric(prhs[2]) )
		mexErrMsgTxt("parameter 3 missing!\n");
    if( !mxIsNumeric(prhs[3]) )
		mexErrMsgTxt("parameter 3 missing!\n");

	// retrieve the heap
	MinHeap<double>*  heap;
	retrieve_heap( prhs[0], heap);
	// retrieve the parameters
	int index;
	retrieve_index( prhs[1], index );
	double key1;
	retrieve_cost( prhs[2], key1);
    double key2;
    retrieve_cost( prhs[3], key2);

	// push in the PQ
	try{
        heap->push( key1, key2, index-1 );
    } 
    catch( InvalidKeyIncreaseException exc ){
        return;
    }
	// return control to matlab
	return;
}
#endif
