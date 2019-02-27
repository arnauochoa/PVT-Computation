/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * elevation_angle.cpp
 *
 * Code generation for function 'elevation_angle'
 *
 */

/* Include files */
#include <cmath>
#include "rt_nonfinite.h"
#include "elevation_angle.h"
#include "norm.h"

/* Function Definitions */
double elevation_angle(const double r_u[3], const double r_s[3])
{
  double c;
  int k;
  double d;
  double b_d[3];

  /*  ELEVATION ANGLE:  Returns the elevation angle of the satellite over */
  /*                    the horizon with respect to the user's position. */
  /*  Input: */
  /*            r_u:    Vector defining the user's position. */
  /*            r_s:    Vector defining the satellite's position. */
  /*  Input: */
  /*            alpha:  Angle expressed in rad of the satellite over */
  /*                    the horizon with respect to the user's position. */
  /*  Vector 'distance' between user and satellite */
  c = 0.0;
  for (k = 0; k < 3; k++) {
    d = r_u[k] - r_s[k];
    c += r_u[k] * d;
    b_d[k] = d;
  }

  /*  Angle between r_u and d */
  return std::acos(c / (norm(r_u) * norm(b_d))) - 1.5707963267948966;
}

/* End of code generation (elevation_angle.cpp) */
