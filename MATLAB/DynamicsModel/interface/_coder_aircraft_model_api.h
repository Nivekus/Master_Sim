//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_aircraft_model_api.h
//
// Code generation for function 'aircraft_model'
//

#ifndef _CODER_AIRCRAFT_MODEL_API_H
#define _CODER_AIRCRAFT_MODEL_API_H

// Include files
#include "emlrt.h"
#include "tmwtypes.h"
#include <algorithm>
#include <cstring>

// Variable Declarations
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

// Function Declarations
void aircraft_model(real_T X[9], real_T U[5], real_T Xdot[9]);

void aircraft_model_api(const mxArray *const prhs[2], const mxArray **plhs);

void aircraft_model_atexit();

void aircraft_model_initialize();

void aircraft_model_terminate();

void aircraft_model_xil_shutdown();

void aircraft_model_xil_terminate();

#endif
// End of code generation (_coder_aircraft_model_api.h)
