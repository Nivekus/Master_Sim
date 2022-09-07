//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// aircraft_dynamics.h
//
// Code generation for function 'aircraft_dynamics'
//

#ifndef AIRCRAFT_DYNAMICS_H
#define AIRCRAFT_DYNAMICS_H

// Include files
#include "rtwtypes.h"
#include <cstddef>
#include <cstdlib>


// Type Definitions
 class __declspec(dllexport) aircraft_dynamics {
public:
  aircraft_dynamics();
  ~aircraft_dynamics();
  void aircraft_model(const double X[9], const double U[5], double Xdot[9]);
};

#endif
// End of code generation (aircraft_dynamics.h)
