// Fill out your copyright notice in the Description page of Project Settings.

#pragma once
#define _USE_MATH_DEFINES
#include <math.h>
#include <array>
#include <algorithm>


#include <aircraft_controller.h>

#include "CoreMinimal.h"


class UNREAL_SIMULATION_API aircraft_dynamics 
{

public:
	aircraft_controller controller;
	std::array<double, 9> X;				//current states
	std::array<double, 5> U;				//Input User
	std::array<double, 5> U_c = {0,0,0,0,0};				//Input Combined
	std::array<double, 5> U_r = {0,0,0,0,0};				//Input PID Control
	double chi;								//current heading
	std::array<double, 3> position;			//current position in earth coordinates
	
	aircraft_dynamics();
	~aircraft_dynamics();


	double v_c;								//
	double h_c;
	double phi_c;
	double chi_c = 0.0;
	double theta_c;


	//define parameters
	//mass
	double m = 120000.0;

	//engine parameters
	double x_apt1 = 0.0;
	double x_apt2 = 0.0;

	double y_apt1 = -7.94;
	double y_apt2 = 7.94;

	double z_apt1 = -1.9;
	double z_apt2 = -1.9;

	//aerodynamic parameters 
	double S = 260.0;
	double St = 64.0;

	double l = 6.6;
	double lt = 24.8;

	double x_cg = 0.23 * l;
	double y_cg = 0.0;
	double z_cg = 0.10 * l;

	double x_ac = 0.12 * l;
	double y_ac = 0.0;
	double z_ac = 0.0;


	double rho = 1.225;
	double depsda = 0.25;		// d epsilon / d alpha
	double alpha_L0 = -11.5 * M_PI / 180.0;

	double n = 5.5;
	double a3 = -768.5;
	double a2 = 609.2;
	double a1 = -155.2;
	double a0 = 15.212;

	double alpha_switch = 14.5 * (M_PI / 180.0);

	//gravity
	double g = 9.81;


	//control limits
	double u1min = -25 * M_PI / 180.0;
	double u1max = 25 * M_PI / 180.0;

	double u2min = -25 * M_PI / 180.0;
	double u2max = 10 * M_PI / 180.0;

	double u3min = -30 * M_PI / 180.0;
	double u3max = 30 * M_PI / 180.0;

	double u4min = .5 * M_PI / 180.0;
	double u4max = 10 * M_PI / 180.0;

	double u5min = .5 * M_PI / 180.0;
	double u5max = 10 * M_PI / 180.0;

	std::array<std::array<double, 3>, 3> Ib = { 40.07 * m,		0 * m,		-2.0923 * m,
												0 * m,			64 * m,		0 * m,
												-2.0923 * m,	0 * m,		99.92 * m };

	std::array<std::array<double, 3>, 3> inv_Ib = { 0.024983643360277 / m,	0 / m,						0.000523151291060 / m,
													0 / m,					0.015625000000000 / m,		0 / m,
													0.000523151291060 / m,  0 / m,						0.010018961063313 / m };

	void aircraft_model(const double X[9], const double U[5], double Xdot[9]);
	void aircraft_model(const std::array<double, 9> &X, const std::array<double, 5> &U, std::array<double, 9> &Xdot);
	void limit_u(std::array<double, 5> &u);
	void calc_earth_velocity(const std::array<double, 3>& v, const std::array<double, 3>& euler, std::array<double, 3>& earth_velo);
	void calc_earth_velocity(double v[3], double phi, double theta, double psi,
		double y[3]);
	void calc_step(const double &dt);
	void calc_controlled_step(const double& dt, double& pos_x, double& pos_y, double& pos_z, double& phi, double& theta, double& psi);
	void calc_chi(double x,double y);
	void solve_euler(double dt, const std::array<double, 9>& x_dot, std::array<double, 9>& x);
	void set_initial_cond(std::array<double, 9> x_init, std::array<double, 5> u_init, std::array<double, 3> position_init);
	void set_position(std::array<double, 3> position_init);
	void set_orientation(std::array<double, 3> orientation_init);

};
