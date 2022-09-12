// Fill out your copyright notice in the Description page of Project Settings.

#pragma once
#define _USE_MATH_DEFINES

#include "CoreMinimal.h"
#include <array>
#include <math.h>
/**
 * 
 */
class UNREAL_SIMULATION_API aircraft_controller
{

	double p_controller(const double& k, const double& error);
	double pi_controller(const double& k, const double& r, const double& error, double& integral, const double& dt);

public:
	//aircraft control parameter
	// damper longitudinal
	double k_eta_q = 5;
	double k_eta_theta = 20;
	// damper lateral
	double k_zeta_r = 15;
	double T = 0.1;
	double k_xi_p = 0.3;
	// high pass filter (not working correctly)
	double r_u_prev = 0;
	double r_y_prev = 0;


	//curve maneuver 
	double k_zeta_beta = 20;
	// height
	double k_theta_H = 0.009;
	// velocity
	double k_f_V = 0.001;		//I
	double r_f_V = 1.0;			//P
	// phi
	double k_xi_phi = 1.0;
	double i_xi_phi = 0.05;
	// chi
	double k_phi_chi = 2.0;


	double phi_integral = 0;
	double velocity_integral = 0;


	aircraft_controller();
	~aircraft_controller();

	double calc_chi_error(const double &chi, const double &chi_c);

	double calc_chi_c(double dx, double dy);
	
	void pitch_damper(const std::array<double, 9>& X, std::array<double, 5>& U_r);

	void phygoid_damper_theta_controller(const std::array<double, 9>& X, const double& theta_c, std::array<double, 5>& U_r);

	void yaw_damper(const double &dt, const std::array<double, 9>& X, std::array<double, 5>& U_r);

	void roll_damper(const std::array<double, 9>& X, std::array<double, 5>& U_r);

	void hight_controller(const double& h, std::array<double, 5>& U_r, const double& h_c, double &theta_c);

	void velocity_controller(const double& dt, const std::array<double, 9>& X, const double& v_c, std::array<double, 5>& U_r);

	void phi_controller(const double& dt, const std::array<double, 9>& X, const double& phi_c, std::array<double, 5>& U_r);

	void chi_controller(const double& chi, std::array<double, 5>& U_r, const double& chi_c, double& phi_c);

	void curve_coordination(const std::array<double, 9> &X, std::array<double, 5>& U_r);

	void waypoint_control(const std::array<double, 3>& position, const std::array<double, 3>& way_point, double& chi);
};
