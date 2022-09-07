// Fill out your copyright notice in the Description page of Project Settings.

#pragma once
#define _USE_MATH_DEFINES
#include <math.h>
#include <array>
#include <algorithm>


#include "CoreMinimal.h"

/**
 *
 */




class UNREAL_SIMULATION_API aircraft_dynamics_custom
{
	std::array<double, 9> X;
	std::array<double, 5> U;

public:
	aircraft_dynamics_custom();
	~aircraft_dynamics_custom();

	//define parameters
	//mass
	double m = 120000;

	//engine parameters
	double x_apt1 = 0;
	double x_apt2 = 0;

	double y_apt1 = -7.94;
	double y_apt2 = 7.94;

	double z_apt1 = -1.9;
	double z_apt2 = -1.9;

	//aerodynamic parameters 
	double S = 260;
	double St = 64;

	double l = 6.6;
	double lt = 24.8;

	double x_cg = 0.23 * l;
	double y_cg = 0;
	double z_cg = 0.10 * l;

	double x_ac = 0.12 * l;
	double y_ac = 0;
	double z_ac = 0;


	double rho = 1.225;
	double depsda = 0.25;		// d epsilon / d alpha
	double alpha_L0 = -11.5 * M_PI / 180;

	double n = 5.5;
	double a3 = -768.5;
	double a2 = 609.2;
	double a1 = -155.2;
	double a0 = 15.212;

	double alpha_switch = 14.5 * (M_PI / 180);

	//gravity
	double g = 9.81;


	//control limits
	double u1min = -25 * M_PI / 180;
	double u1max = 25 * M_PI / 180;

	double u2min = -25 * M_PI / 180;
	double u2max = 10 * M_PI / 180;

	double u3min = -30 * M_PI / 180;
	double u3max = 30 * M_PI / 180;

	double u4min = .5 * M_PI / 180;
	double u4max = 10 * M_PI / 180;

	double u5min = .5 * M_PI / 180;
	double u5max = 10 * M_PI / 180;

	std::array<std::array<double, 3>, 3> Ib = { 40.07 * m,		0 * m,		-2.0923 * m,
												0 * m,			64 * m,		0 * m,
												-2.0923 * m,	0 * m,		99.92 * m };

	std::array<std::array<double, 3>, 3> inv_Ib = { 0.024983643360277 / m,	0 / m,						0.000523151291060 / m,
													0 / m,					0.015625000000000 / m,		0 / m,
													0.000523151291060 / m,  0 / m,						0.010018961063313 / m };

	void aircraft_model(const double X[9], const double U[5], double Xdot[9]);
	void aircraft_model(const std::array<double, 9> X, const std::array<double, 5> U, std::array<double, 9>& Xdot);
	void limit_u( std::array<double, 5> &u);



};
