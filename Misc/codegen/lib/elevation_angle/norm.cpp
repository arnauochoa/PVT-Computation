/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * norm.cpp
 *
 * Code generation for function 'norm'
 *
 */

/* Include files */
#include <cmath>
#include "rt_nonfinite.h"
#include "elevation_angle.h"
#include "norm.h"

/* Function Definitions */
double norm(const double x[3])
{
  double y;
  double scale;
  int k;
  double absxk;
  double t;
  y = 0.0;
  scale = 3.3121686421112381E-170;
  for (k = 0; k < 3; k++) {
    absxk = std::abs(x[k]);
    if (absxk > scale) {
      t = scale / absxk;
      y = 1.0 + y * t * t;
      scale = absxk;
    } else {
      t = absxk / scale;
      y += t * t;
    }
  }

  return scale * std::sqrt(y);
}

/* End of code generation (norm.cpp) */
