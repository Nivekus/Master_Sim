// Fill out your copyright notice in the Description page of Project Settings.


#include "aircraft_dynamics_custom.h"


template <typename Type, std::size_t... sizes>
auto concatenate(const std::array<Type, sizes>&... arrays)
{
	std::array<Type, (sizes + ...)> result;
	std::size_t index{};

	((std::copy_n(arrays.begin(), sizes, result.begin() + index), index += sizes), ...);

	return result;
}

std::array<double, 3> matmulvec3x3(const std::array<std::array<double, 3>, 3> &m, const  std::array<double, 3> &v) {
	std::array<double, 3> res = { 0,0,0 };
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			res[i] += m[i][j] * v[j];
		}
	}
	return res;
};

std::array<std::array<double, 3>, 3> matmulscal3x3(const std::array<std::array<double, 3>, 3> &m, const  double &v) {
	std::array<std::array<double, 3>, 3> res;
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			res[i][j] = m[i][j] * v;
		}
	}
	return res;
};

std::array<double, 3> vecaddvec3x1(const std::array<double, 3>  &m, const  std::array<double, 3>  &v) {
	std::array<double, 3>  res;
	for (int i = 0; i < 3; i++) {
		res[i] = m[i] + v[i];
	}
	return res;
};

std::array<double, 3> vecsubvec3x1(const std::array<double, 3>  &m, const  std::array<double, 3>  &v) {
	std::array<double, 3>  res;
	for (int i = 0; i < 3; i++) {
		res[i] = m[i] - v[i];
	}
	return res;
};

std::array<double, 3> vecmulscal3x1(const std::array<double, 3>  &m, const  double  &v) {
	std::array<double, 3>  res;
	for (int i = 0; i < 3; i++) {
		res[i] = m[i] * v;
	}
	return res;
};

std::array<double, 3> cross(const std::array<double, 3>  &a, const  std::array<double, 3>   &b) {
	std::array<double, 3>  res;
	res[0] = a[1] * b[2] - a[2] * b[1];
	res[1] = a[2] * b[0] - a[0] * b[2];
	res[2] = a[0] * b[1] - a[1] * b[0];
	return res;
};


aircraft_dynamics_custom::aircraft_dynamics_custom()
{
	X = {85,0,0,0,0,0,0,0.1,0};
	U = { 0,-0.1,0,0.08,0.08 };
	v_c = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);
}

aircraft_dynamics_custom::~aircraft_dynamics_custom()
{
}

void aircraft_dynamics_custom::aircraft_model(const double x[9], const double u[5], double xdot[9]) {
	std::array<double, 9> x_tmp = { x[0],x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8] };
	std::array<double, 5> u_tmp = { u[0],u[1], u[2], u[3], u[4]};
	std::array<double, 9> x_dot_tmp = { u[0],u[1], u[2], u[3], u[4] };

	limit_u(u_tmp);
	aircraft_model(x_tmp, u_tmp, x_dot_tmp);
	
		
	xdot[0] = x_dot_tmp[0];
	xdot[1] = x_dot_tmp[1];
	xdot[2] = x_dot_tmp[2];
	xdot[3] = x_dot_tmp[3];
	xdot[4] = x_dot_tmp[4];
	xdot[5] = x_dot_tmp[5];
	xdot[6] = x_dot_tmp[6];
	xdot[7] = x_dot_tmp[7];
	xdot[8] = x_dot_tmp[8];

}

void aircraft_dynamics_custom::aircraft_model(const std::array<double, 9> &x, const std::array<double, 5> &u, std::array<double, 9> &xdot) {
	// intermediat variables----------------------------------------------------------- 
	double Va = std::sqrt(std::pow(x[0], 2.0) + std::pow(x[1], 2.0) + std::pow(x[2], 2.0));
	double alpha = std::atan2(x[2], x[0]);
	double beta = std::asin(x[1] / Va);
	double q_dach = 0.5  * rho * std::pow(Va, 2.0);

	std::array<double, 3> wbe_b = { x[3],x[4],x[5] };
	std::array<double, 3> V_b = { x[0],x[1],x[2] };

	// aero force coeffs---------------------------------------------------------------
	double CL_wb;																	// lift wing
	if (alpha <= alpha_switch) {
		CL_wb = n * (alpha - alpha_L0);
	}
	else {
		CL_wb = a3 * std::pow(alpha, 3.0) + a2 * std::pow(alpha, 2.0) + a1 * alpha + a0;
	}

	double epsilon = depsda * (alpha - alpha_L0);									//lift tail
	double alpha_t = alpha - epsilon + u[1] + 1.3 * x[4] * lt / Va;
	double CL_t = 3.1 * (St / S) * alpha_t;

	double CL = CL_wb + CL_t;														//total lift
	double CD = 0.13 + 0.07 * std::pow((5.5 * alpha + 0.654), 2.0);					//drag
	double CY = -1.6 * beta + 0.24 * u[2];											//side force 

	// aero forces---------------------------------------------------------------------
	std::array<double, 3> FA_s = { -CD * S * q_dach,
									CY * S * q_dach,
									-CL * S * q_dach };


	double calpha_tmp = std::cos(alpha);
	double salpha_tmp = std::sin(alpha);
	std::array<std::array<double, 3>, 3> C_bs = {	calpha_tmp, 0,	-salpha_tmp,	//ROTATION Experimentel-- > Flugzeug
													0,			1,	0,
													salpha_tmp, 0,	calpha_tmp };

	std::array<double, 3> FA_b = matmulvec3x3(C_bs, FA_s);

	// aero moment coefficients---------------------------------------------------------
	double eta11 = -1.4 * beta;
	double eta21 = -0.59 - 3.1 * ((St * lt) / (S * l)) * (alpha - epsilon);
	double eta31 = (1 - alpha * 180 / (15 * M_PI)) * beta;
	std::array<double, 3> eta = {	eta11,
									eta21,
									eta31 };
	std::array<std::array<double, 3>, 3> dCMdx = { -11,		0,																5,
													0,		-4.03 * ((St * std::pow(lt,2.0)) / (S * std::pow(l,2.0))),		0,
													1.7,	0,																-11.5 };

	dCMdx = matmulscal3x3(dCMdx, l / Va);
	std::array<std::array<double, 3>, 3> dCMdu = { -0.6,	0,									0.22,
													0,		-3.1 * ((St * lt) / (S * l)),		0,
													0,		0,									-0.63 };

	std::array<double, 3> tmp_prim_control = { u[0],u[1],u[2] };
	std::array<double, 3> CMac_b = vecaddvec3x1(matmulvec3x3(dCMdx, wbe_b), matmulvec3x3(dCMdu, tmp_prim_control));
	CMac_b = vecaddvec3x1(eta, CMac_b);
	// aero moment ---------------------------------------------------------------------
	std::array<double, 3> MAac_b = vecmulscal3x1(CMac_b, q_dach * S * l);

	// aero moment in CG----------------------------------------------------------------
	std::array<double, 3> rcg_b = { x_cg, y_cg, z_cg };
	std::array<double, 3> rac_b = { x_ac, y_ac, z_ac };
	std::array<double, 3> MAcg_b = vecaddvec3x1(MAac_b, cross(FA_b, vecsubvec3x1(rcg_b, rac_b)));


	//engine force and moments----------------------------------------------------------
	std::array<double, 3> FE1_b = { u[3] * m * g, 0, 0 };
	std::array<double, 3> FE2_b = { u[4] * m * g, 0, 0 };

	std::array<double, 3> FE_b = vecaddvec3x1(FE1_b, FE2_b);

	std::array<double, 3> mew1 = { x_cg - x_apt1,
									y_apt1 - y_cg,
									z_cg - z_apt1 };

	std::array<double, 3> mew2 = { x_cg - x_apt2,
									y_apt2 - y_cg,
									z_cg - z_apt2 };

	std::array<double, 3> MEcg1_b = cross(mew1, FE1_b);
	std::array<double, 3> MEcg2_b = cross(mew2, FE2_b);
	std::array<double, 3> MEcg_b = vecaddvec3x1(MEcg1_b, MEcg2_b);
	//gravity--------------------------------------------------------------------------

	std::array<double, 3> g_b = {	-g * sin(x[7]),
									g * cos(x[7])* sin(x[6]),
									g * cos(x[7])* cos(x[6])};
	std::array<double, 3> Fg_b = vecmulscal3x1(g_b,m);
	//state derivatives----------------------------------------------------------------

	std::array<double, 3> F_b =vecaddvec3x1( Fg_b ,vecaddvec3x1( FA_b , FE_b));
	std::array<double, 3> x1to3dot = vecsubvec3x1(vecmulscal3x1(F_b,1/m),cross(wbe_b, V_b));
	
	std::array<double, 3> Mcg_b = vecaddvec3x1(MEcg_b,MAcg_b);
	std::array<double, 3> x4to6dot = matmulvec3x3(inv_Ib,vecsubvec3x1(Mcg_b, cross(wbe_b, matmulvec3x3( Ib,wbe_b))));
	
	std::array<std::array<double, 3>, 3> H_phi = {	1,	sin(x[6]) * tan(x[7]),	cos(x[6]) * tan(x[7]),
													0,	cos(x[6]),				-sin(x[6]),
													0,	sin(x[6]) / cos(x[7]),	cos(x[6]) / cos(x[7])};

	std::array<double, 3> x7to9dot = matmulvec3x3( H_phi ,wbe_b);

	xdot = concatenate(x1to3dot, x4to6dot, x7to9dot);

}

void aircraft_dynamics_custom::limit_u( std::array<double, 5> &u) {
	if (u[0] > u1max)
	{
		u[0] = u1max;
	}
	else if (u[0] < u1min)
	{
		u[0] = u1min;
	}

	if (u[1] > u2max)
	{	
		u[1] = u2max;
	}	
	else if (u[1] < u2min)
	{
		u[1] = u2min;
	}

	if (u[2] > u3max)
	{
		u[2] = u3max;
	}
	else if (u[2] < u3min)
	{
		u[2] = u3min;
	}

	if (u[3] > u4max)
	{
		u[3] = u4max;
	}
	else if (u[3] < u4min)
	{
		u[3] = u4min;
	}

	if (u[4] > u5max)
	{
		u[4] = u5max;
	}
	else if (u[4] < u5min)
	{
		u[4] = u5min;
	}
};


void aircraft_dynamics_custom::calc_earth_velocity(double v[3], double phi, double theta, double psi,
	double y[3]) 
{
	std::array<double, 3> v_tmp = {v[0],v[1],v[2]};
	std::array<double, 3> euler = { phi,theta,psi };
	std::array<double, 3> earth_velo = { 0,0,0 };
	calc_earth_velocity(v_tmp, euler, earth_velo);
	
	y[0] = earth_velo[0];
	y[1] = earth_velo[1];
	y[2] = earth_velo[2];

};


void aircraft_dynamics_custom::calc_earth_velocity(const std::array<double, 3> &v, const std::array<double, 3> &euler, std::array<double, 3> &earth_velo)
{
	double cos_phi_tmp = std::cos(euler[0]);
	double sin_phi_tmp = std::sin(euler[0]);

	double cos_theta_tmp = std::cos(euler[1]);
	double sin_theta_tmp = std::sin(euler[1]);

	double cos_psi_tmp = std::cos(euler[2]);
	double sin_psi_tmp = std::sin(euler[2]);

	std::array<std::array<double, 3>, 3> rpsi_t = { cos_psi_tmp,	-sin_psi_tmp,	0,
													sin_psi_tmp,	cos_psi_tmp,	0,
													0,				0,				1 };

	std::array<std::array<double, 3>, 3> rtheta_t = {	cos_theta_tmp,	0,	sin_theta_tmp,
														0,				1,	0,
														-sin_theta_tmp,	0,	cos_theta_tmp };

	std::array<std::array<double, 3>, 3> rphi_t = { 1,			0,				0,
													0,			cos_phi_tmp,	-sin_phi_tmp,
													0,			sin_phi_tmp,	cos_phi_tmp };


	std::array<double, 3> res, v_tmp;
	v_tmp[0] = v[0];
	v_tmp[1] = v[1];
	v_tmp[2] = v[2];

	res = matmulvec3x3(rphi_t, v_tmp);
	res = matmulvec3x3(rtheta_t, res);
	res = matmulvec3x3(rpsi_t, res);

	earth_velo[0] = res[0];
	earth_velo[1] = res[1];
	earth_velo[2] = -res[2];
}

void aircraft_dynamics_custom::calc_step(const double &dt) {
	
	std::array<double,9> Xdot;
	// calculate augmented control values U
	for (int i = 0; i < 5; i++) {
		U_c[i] = U[i] + U_r[i];
	}

	limit_u(U_c);
	aircraft_model(X, U_c, Xdot);
	solve_euler(dt, Xdot, X);

	//calculate position
	std::array<double, 3> velo_aircraft = { X[0],X[1],X[2] };
	std::array<double, 3> euler_angles = { X[6],X[7],X[8] };
	std::array<double, 3> velo_earth = { 0,0,0 };
	calc_earth_velocity(velo_aircraft,euler_angles,velo_earth);
	for (int i = 0; i < 3; i++) {
		position[i] += dt * velo_earth[i];
	}
	// calculate heading
	calc_chi(velo_earth[0], velo_earth[1]);
}

void aircraft_dynamics_custom::calc_controlled_step(const double &dt, double& pos_x, double& pos_y, double& pos_z, double& phi, double& theta, double& psi){


	calc_step(dt);

	//reset control values
	for (int i = 0; i < 5; i++) {
		U_r[i] = 0;
	}

	// run before step for correct integrator initial values
	//controller.yaw_damper(dt,X,U_r);

	controller.velocity_controller(dt, X, v_c, U_r);
	controller.hight_controller(position[2], U_r, h_c, theta_c);
	controller.phygoid_damper_theta_controller(X, theta_c, U_r);
	controller.pitch_damper(X,U_r);
	controller.roll_damper(X,U_r);
	controller.curve_coordination(X,U_r);
	controller.chi_controller(chi,U_r,chi_c,phi_c);
	controller.phi_controller(dt, X, phi_c, U_r);

	pos_x = position[0];
	pos_y = position[1];
	pos_z = position[2];
	phi = X[6];
	theta = X[7];
	psi = X[8];
}



void aircraft_dynamics_custom::solve_euler(double dt, const std::array<double, 9>& x_dot, std::array<double, 9>& x) {
	for (int i = 0; i < 9; i++) {
		x[i] += dt * x_dot[i];
	}
};

void aircraft_dynamics_custom::calc_chi(double x, double y) {
	chi = M_PI / 2 - std::atan2(x, y);
}

void aircraft_dynamics_custom::set_initial_cond(std::array<double, 9> x_init, std::array<double, 5> u_init, std::array<double, 3> position_init)
{
	X = x_init;
	U = u_init;
	position = position_init;
	v_c = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);							//
	h_c = position_init[2];
	phi_c = X[6];
	theta_c = X[7];

	std::array<double, 3> velo_aircraft = { X[0],X[1],X[2] };
	std::array<double, 3> euler_angles = { X[6],X[7],X[8] };
	std::array<double, 3> velo_earth = { 0,0,0 };
	calc_earth_velocity(velo_aircraft, euler_angles, velo_earth);
	calc_chi(velo_earth[0], velo_earth[1]);
	chi_c=chi;
}

void aircraft_dynamics_custom::set_position(std::array<double, 3> position_init) {
	position = position_init;
	h_c = position_init[2];
};
void aircraft_dynamics_custom::set_orientation(std::array<double, 3> orientation_init) {
	X[6] = orientation_init[0];
	X[7] = orientation_init[1];
	X[8] = orientation_init[2];
	
	phi_c = orientation_init[0];
	theta_c = orientation_init[1];

	std::array<double, 3> velo_aircraft = { X[0],X[1],X[2] };
	std::array<double, 3> euler_angles = { X[6],X[7],X[8] };
	std::array<double, 3> velo_earth = { 0,0,0 };
	calc_earth_velocity(velo_aircraft, euler_angles, velo_earth);
	calc_chi(velo_earth[0], velo_earth[1]);
	chi_c = chi;
};