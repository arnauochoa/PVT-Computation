/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nsgpst2gpst.cpp
 *
 * Code generation for function 'nsgpst2gpst'
 *
 */

/* Include files */
#include <cmath>
#include "rt_nonfinite.h"
#include "nsgpst2gpst.h"

/* Function Declarations */
static int div_nde_s32_floor(int numerator, int denominator);
static double rt_roundd_snf(double u);

/* Function Definitions */
static int div_nde_s32_floor(int numerator, int denominator)
{
  int b_numerator;
  if (((numerator < 0) != (denominator < 0)) && (numerator % denominator != 0))
  {
    b_numerator = -1;
  } else {
    b_numerator = 0;
  }

  return numerator / denominator + b_numerator;
}

static double rt_roundd_snf(double u)
{
  double y;
  if (std::abs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = std::floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = std::ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

void nsgpst2gpst(int time, int *tow, int *now)
{
  /*  Some declarations */
  time = (int)rt_roundd_snf((double)time / 1.0E+9);

  /*  now */
  *now = 0;

  /*  tow */
  *tow = time - div_nde_s32_floor(time, 604800) * 604800;
}

/* End of code generation (nsgpst2gpst.cpp) */
