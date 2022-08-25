//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// aircraft_dynamics.cpp
//
// Code generation for function 'aircraft_dynamics'
//

// Include files
#include "aircraft_dynamics.h"
#include "rt_nonfinite.h"
#include "rt_defines.h"
#include <cmath>


// Function Declarations
static double rt_atan2d_snf(double u0, double u1);

static double rt_powd_snf(double u0, double u1);

// Function Definitions
static double rt_atan2d_snf(double u0, double u1)
{
  double y;
  if (std::isnan(u0) || std::isnan(u1)) {
    y = rtNaN;
  } else if (std::isinf(u0) && std::isinf(u1)) {
    int b_u0;
    int b_u1;
    if (u0 > 0.0) {
      b_u0 = 1;
    } else {
      b_u0 = -1;
    }
    if (u1 > 0.0) {
      b_u1 = 1;
    } else {
      b_u1 = -1;
    }
    y = std::atan2(static_cast<double>(b_u0), static_cast<double>(b_u1));
  } else if (u1 == 0.0) {
    if (u0 > 0.0) {
      y = RT_PI / 2.0;
    } else if (u0 < 0.0) {
      y = -(RT_PI / 2.0);
    } else {
      y = 0.0;
    }
  } else {
    y = std::atan2(u0, u1);
  }
  return y;
}

static double rt_powd_snf(double u0, double u1)
{
  double y;
  if (std::isnan(u0) || std::isnan(u1)) {
    y = rtNaN;
  } else {
    double d;
    double d1;
    d = std::abs(u0);
    d1 = std::abs(u1);
    if (std::isinf(u1)) {
      if (d == 1.0) {
        y = 1.0;
      } else if (d > 1.0) {
        if (u1 > 0.0) {
          y = rtInf;
        } else {
          y = 0.0;
        }
      } else if (u1 > 0.0) {
        y = 0.0;
      } else {
        y = rtInf;
      }
    } else if (d1 == 0.0) {
      y = 1.0;
    } else if (d1 == 1.0) {
      if (u1 > 0.0) {
        y = u0;
      } else {
        y = 1.0 / u0;
      }
    } else if (u1 == 2.0) {
      y = u0 * u0;
    } else if ((u1 == 0.5) && (u0 >= 0.0)) {
      y = std::sqrt(u0);
    } else if ((u0 < 0.0) && (u1 > std::floor(u1))) {
      y = rtNaN;
    } else {
      y = std::pow(u0, u1);
    }
  }
  return y;
}

aircraft_dynamics::aircraft_dynamics() = default;

aircraft_dynamics::~aircraft_dynamics() = default;



void aircraft_dynamics::aircraft_model(double X[9], double U[5],
                                       double Xdot[9]) const
{
  static const double b[9]{-11.0, 0.0, 1.7, 0.0,  -14.006420569329665,
                           0.0,   5.0, 0.0, -11.5};
  static const double c_a[9]{4.8084E+6, 0.0, -251075.99999999997, 0.0,
                             7.68E+6,   0.0, -251075.99999999997, 0.0,
                             1.19904E+7};
  static const double d_a[9]{-0.6, 0.0,  0.0, 0.0,  -2.8673193473193477,
                             0.0,  0.22, 0.0, -0.63};
  static const double e_a[9]{
      2.0819702800230834E-7, 0.0, 4.3595940921666669E-9, 0.0,
      1.3020833333333334E-7, 0.0, 4.3595940921666669E-9, 0.0,
      8.3491342194275013E-8};
  double c_C_bs_tmp[9];
  double FA_b[3];
  double FE1_b[3];
  double FE2_b[3];
  double V_b[3];
  double dv[3];
  double wbe_b[3];
  double y[3];
  double C_bs_tmp;
  double H_phi_tmp;
  double Va;
  double a;
  double alpha;
  double b_C_bs_tmp;
  double b_a;
  double b_g_b_tmp;
  double beta;
  double d;
  double g_b_tmp;
  double qdach;
  double u1;
  double u2;
  double u3;
  double u4;
  double u5;
  double wbe_b_idx_0;
  double wbe_b_idx_1;
  double wbe_b_idx_2;
  //  STATES
  // INPUTS
  u1 = U[0];
  u2 = U[1];
  u3 = U[2];
  u4 = U[3];
  u5 = U[4];
  // PARMETER AIRCRAFT
  // PARAMETER ENGINE
  // PARAMETER AERODYNAMICS
  // d epsilon/ d alpha
  // CONTROLL LIMITS-----------------------------------------------------------
  if (U[0] > 0.43633231299858238) {
    u1 = 0.43633231299858238;
  } else if (U[0] < -0.43633231299858238) {
    u1 = -0.43633231299858238;
  }
  if (U[1] > 0.17453292519943295) {
    u2 = 0.17453292519943295;
  } else if (U[1] < -0.43633231299858238) {
    u2 = -0.43633231299858238;
  }
  if (U[2] > 0.52359877559829882) {
    u3 = 0.52359877559829882;
  } else if (U[2] < -0.52359877559829882) {
    u3 = -0.52359877559829882;
  }
  if (U[3] > 0.17453292519943295) {
    u4 = 0.17453292519943295;
  } else if (U[3] < 0.0087266462599716477) {
    u4 = 0.0087266462599716477;
  }
  if (U[4] > 0.17453292519943295) {
    u5 = 0.17453292519943295;
  } else if (U[4] < 0.0087266462599716477) {
    u5 = 0.0087266462599716477;
  }
  // VARIABLES-----------------------------------------------------------
  Va = std::sqrt((X[0] * X[0] + X[1] * X[1]) + X[2] * X[2]);
  alpha = rt_atan2d_snf(X[2], X[0]);
  beta = std::asin(X[1] / Va);
  qdach = 0.6125 * (Va * Va);
  wbe_b_idx_0 = X[3];
  wbe_b_idx_1 = X[4];
  wbe_b_idx_2 = X[5];
  // AERO FORCE
  // COEFFS-----------------------------------------------------------
  //  Lift wing body
  //  Lift tail
  //  Total Lift
  // Drag
  a = 5.5 * alpha + 0.654;
  // Side Force
  // AERO FORCES-----------------------------------------------------------
  // ROTATION Experimentel --> Flugzeug
  C_bs_tmp = std::sin(alpha);
  b_C_bs_tmp = std::cos(alpha);
  c_C_bs_tmp[0] = b_C_bs_tmp;
  c_C_bs_tmp[3] = 0.0;
  c_C_bs_tmp[6] = -C_bs_tmp;
  c_C_bs_tmp[1] = 0.0;
  c_C_bs_tmp[4] = 1.0;
  c_C_bs_tmp[7] = 0.0;
  c_C_bs_tmp[2] = C_bs_tmp;
  c_C_bs_tmp[5] = 0.0;
  c_C_bs_tmp[8] = b_C_bs_tmp;
  d = alpha - 0.25 * (alpha - -0.20071286397934787);
  // AERO MOMENT
  // COEFF-----------------------------------------------------------
  b_a = 6.6 / Va;
  // AERO MOMENT -----------------------------------------------------------
  // AERO MOMENT at CG
  // ----------------------------------------------------------- Engine force
  // and moment
  FE1_b[0] = u4 * 120000.0 * 9.81;
  FE1_b[1] = 0.0;
  FE1_b[2] = 0.0;
  FE2_b[0] = u5 * 120000.0 * 9.81;
  FE2_b[1] = 0.0;
  FE2_b[2] = 0.0;
  // GRAVITY
  u5 = std::sin(X[6]);
  g_b_tmp = std::cos(X[6]);
  b_g_b_tmp = std::cos(X[7]);
  // STATE
  // DERIVATIVES-----------------------------------------------------------
  H_phi_tmp = std::tan(X[7]);
  wbe_b[0] = X[2] * X[4] - X[1] * X[5];
  wbe_b[1] = X[0] * X[5] - X[2] * X[3];
  wbe_b[2] = X[1] * X[3] - X[0] * X[4];
  V_b[0] = -1.4 * beta;
  V_b[1] = -0.59 - 2.8673193473193477 * d;
  V_b[2] = (1.0 - alpha * 180.0 / 47.123889803846893) * beta;
  b_C_bs_tmp = -(0.07 * (a * a) + 0.13) * 260.0 * qdach;
  C_bs_tmp = (-1.6 * beta + 0.24 * u3) * 260.0 * qdach;
  if (alpha <= 0.2530727415391778) {
    alpha = 5.5 * (alpha - -0.20071286397934787);
  } else {
    alpha = ((-768.5 * rt_powd_snf(alpha, 3.0) + 609.2 * (alpha * alpha)) +
             -155.2 * alpha) +
            15.212;
  }
  d = -(alpha + 0.7630769230769231 * ((d + u2) + 1.3 * X[4] * 24.8 / Va)) *
      260.0 * qdach;
  for (int i{0}; i < 3; i++) {
    y[i] = (c_a[i] * wbe_b_idx_0 + c_a[i + 3] * wbe_b_idx_1) +
           c_a[i + 6] * wbe_b_idx_2;
    FA_b[i] = (c_C_bs_tmp[i] * b_C_bs_tmp + c_C_bs_tmp[i + 3] * C_bs_tmp) +
              c_C_bs_tmp[i + 6] * d;
    dv[i] =
        (V_b[i] + ((b_a * b[i] * wbe_b_idx_0 + b_a * b[i + 3] * wbe_b_idx_1) +
                   b_a * b[i + 6] * wbe_b_idx_2)) +
        ((d_a[i] * u1 + d_a[i + 3] * u2) + d_a[i + 6] * u3);
  }
  V_b[0] = 120000.0 * (-9.81 * std::sin(X[7])) + FA_b[0];
  V_b[1] = 120000.0 * (9.81 * b_g_b_tmp * u5) + FA_b[1];
  V_b[2] = 120000.0 * (9.81 * std::cos(X[7]) * g_b_tmp) + FA_b[2];
  b_C_bs_tmp =
      (dv[0] * qdach * 260.0 * 6.6 + (FA_b[1] * 0.66 - FA_b[2] * 0.0)) -
      (y[2] * X[4] - y[1] * X[5]);
  u4 = ((2.56 * FE1_b[0] + 2.56 * FE2_b[0]) +
        (dv[1] * qdach * 260.0 * 6.6 +
         (FA_b[2] * 0.72600000000000009 - FA_b[0] * 0.66))) -
       (y[0] * X[5] - y[2] * X[3]);
  C_bs_tmp = (((0.0 - -7.94 * FE1_b[0]) + (0.0 - 7.94 * FE2_b[0])) +
              (dv[2] * qdach * 260.0 * 6.6 +
               (FA_b[0] * 0.0 - FA_b[1] * 0.72600000000000009))) -
             (y[1] * X[3] - y[0] * X[4]);
  c_C_bs_tmp[0] = 1.0;
  c_C_bs_tmp[3] = u5 * H_phi_tmp;
  c_C_bs_tmp[6] = g_b_tmp * H_phi_tmp;
  c_C_bs_tmp[1] = 0.0;
  c_C_bs_tmp[4] = g_b_tmp;
  c_C_bs_tmp[7] = -u5;
  c_C_bs_tmp[2] = 0.0;
  c_C_bs_tmp[5] = u5 / b_g_b_tmp;
  c_C_bs_tmp[8] = g_b_tmp / b_g_b_tmp;
  for (int i{0}; i < 3; i++) {
    Xdot[i] =
        8.3333333333333337E-6 * (V_b[i] + (FE1_b[i] + FE2_b[i])) - wbe_b[i];
    Xdot[i + 3] =
        (e_a[i] * b_C_bs_tmp + e_a[i + 3] * u4) + e_a[i + 6] * C_bs_tmp;
    Xdot[i + 6] =
        (c_C_bs_tmp[i] * wbe_b_idx_0 + c_C_bs_tmp[i + 3] * wbe_b_idx_1) +
        c_C_bs_tmp[i + 6] * wbe_b_idx_2;
  }
}

// End of code generation (aircraft_dynamics.cpp)
