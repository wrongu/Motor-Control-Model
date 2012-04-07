//==============================================================================
// Name        : pq_removeMin.cpp
// Author      : Divya Gunasekaran
// Description : Based on priority queue implementation by Andrea Tagliasacchi
//               Removes element with given index from the priority queue
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

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	if( nrhs!=2 )
		mexErrMsgTxt("This function requires 3 arguments\n");
	if( !mxIsNumeric(prhs[0]) )
		mexErrMsgTxt("parameter 1 missing!\n");
	if( !mxIsNumeric(prhs[1]) )
		mexErrMsgTxt("parameter 2 missing!\n");

	// retrieve the heap
	MinHeap<double>*  heap;
	retrieve_heap( prhs[0], heap);
	// retrieve the parameters
	int index;
	retrieve_index( prhs[1], index );

	// remove from the PQ
	try{
        heap->remove( index-1 );
    } 
    catch( InvalidKeyIncreaseException exc ){
        return;
    }
	// return control to matlab
	return;
}
#endif
