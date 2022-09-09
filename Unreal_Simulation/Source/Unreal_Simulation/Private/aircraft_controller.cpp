// Fill out your copyright notice in the Description page of Project Settings.


#include "aircraft_controller.h"

aircraft_controller::aircraft_controller()
{
}

aircraft_controller::~aircraft_controller()
{
}

double aircraft_controller::p_controller(const double& k, const double& error) {
	return k * error;
}

double aircraft_controller::pi_controller(const double& k, const double& r, const double& error, double& integral, const double& dt) {
	double pout = k * error;
	integral += error * dt;
	double iout = r * integral;
	return pout + iout;
}

void aircraft_controller::pitch_damper(const std::array<double, 9> &X, std::array<double, 5> &U_r) {
	U_r[1] += p_controller(k_eta_q, X[4]);
}

void aircraft_controller::roll_damper(const std::array<double, 9>& X, std::array<double, 5>& U_r) {
	U_r[0] += p_controller(k_xi_p,X[3]);
}

void aircraft_controller::phygoid_damper_theta_controller(const std::array<double, 9>& X,const double& theta_c, std::array<double, 5>& U_r) {
	U_r[1] += p_controller(k_eta_theta,(X[7] - theta_c));
}

void aircraft_controller::hight_controller(const double &h, std::array<double, 5>& U_r, const double &h_c,double &theta_c) {
	double H_error;
	H_error = h_c - h;
	theta_c = k_theta_H * H_error;

	// limit max theta angle
	theta_c = std::min(theta_c, 30 * M_PI / 180);
}

void aircraft_controller::velocity_controller(const double& dt, const std::array<double, 9> &X, const double& v_c, std::array<double, 5>& U_r) {
	// PI control
	double V = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);
	double V_error = v_c - V;
	//pi_controller(r_f_V, k_f_V, V_error);
	
	//double Pout = r_f_V * V_error;
	//static double V_integral = 0;
	//V_integral += V_error * dt;
	//double Iout = k_f_V * V_integral;
	double tmp = pi_controller(r_f_V, k_f_V, V_error,velocity_integral, dt);
	U_r[3] += tmp;
	U_r[4] += tmp;
}


void aircraft_controller::phi_controller(const double& dt, const std::array<double, 9>& X, const double& phi_c, std::array<double, 5>& U_r) {
	double phi_error;
	phi_error = X[6] - phi_c;
	U_r[0] += pi_controller(k_xi_phi, i_xi_phi, phi_error,phi_integral, dt);
}

void aircraft_controller::chi_controller(const double& chi, std::array<double, 5>& U_r, const double& chi_c, double& phi_c) {
	double error;
	error = calc_chi_error(chi,chi_c);
	phi_c = p_controller(k_phi_chi, error);
	// limit banking angle 
	phi_c = std::max(phi_c, -50 * M_PI / 180);
	phi_c = std::min(phi_c, 50 * M_PI / 180);
}

double aircraft_controller::calc_chi_error(const double& chi, const double& chi_c) {
	double error = std::fmod(-chi + chi_c + M_PI, 2 * M_PI);
	if (error < 0) {
		error += 2 * M_PI;
	}
	return error - M_PI;

};

void aircraft_controller::yaw_damper(const double& dt,const std::array<double, 9>& X, std::array<double, 5>& U_r) {

	// high pass filter sT/(1+Ts)
	double y_k;
	double y_k_1 = r_y_prev;
	double u_k = X[5];			//r
	double u_k_1 = r_u_prev;

	y_k = T / (dt + T) * (u_k - u_k_1 + y_k_1);
	// update prev values 
	r_y_prev = y_k;
	r_u_prev = u_k;

	// P control
	U_r[2] = k_zeta_r * y_k;
	//	U_r[2] += k_zeta_r * X[5];
}

void aircraft_controller::curve_coordination(const std::array<double, 9>& X, std::array<double, 5>& U_r) {
	double V = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);
	double beta = asin(X[1] / V);
	U_r[2] -= p_controller(k_zeta_beta,beta);
}