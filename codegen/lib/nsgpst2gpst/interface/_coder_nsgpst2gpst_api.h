/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_nsgpst2gpst_api.h
 *
 * Code generation for function '_coder_nsgpst2gpst_api'
 *
 */

#ifndef _CODER_NSGPST2GPST_API_H
#define _CODER_NSGPST2GPST_API_H

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_nsgpst2gpst_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void nsgpst2gpst(int32_T time, int32_T *tow, int32_T *now);
extern void nsgpst2gpst_api(const mxArray * const prhs[1], int32_T nlhs, const
  mxArray *plhs[2]);
extern void nsgpst2gpst_atexit(void);
extern void nsgpst2gpst_initialize(void);
extern void nsgpst2gpst_terminate(void);
extern void nsgpst2gpst_xil_terminate(void);

#endif

/* End of code generation (_coder_nsgpst2gpst_api.h) */
