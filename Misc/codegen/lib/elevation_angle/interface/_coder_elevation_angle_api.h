/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_elevation_angle_api.h
 *
 * Code generation for function '_coder_elevation_angle_api'
 *
 */

#ifndef _CODER_ELEVATION_ANGLE_API_H
#define _CODER_ELEVATION_ANGLE_API_H

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_elevation_angle_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern real_T elevation_angle(real_T r_u[3], real_T r_s[3]);
extern void elevation_angle_api(const mxArray * const prhs[2], int32_T nlhs,
  const mxArray *plhs[1]);
extern void elevation_angle_atexit(void);
extern void elevation_angle_initialize(void);
extern void elevation_angle_terminate(void);
extern void elevation_angle_xil_terminate(void);

#endif

/* End of code generation (_coder_elevation_angle_api.h) */
