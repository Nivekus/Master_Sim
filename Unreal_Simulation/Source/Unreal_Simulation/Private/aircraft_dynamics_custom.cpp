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

std::array<double, 3> matmulvec3x3(std::array<std::array<double, 3>, 3> m, std::array<double, 3> v) {
	std::array<double, 3> res = { 0,0,0 };
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			res[i] += m[i][j] * v[j];
		}
	}
	return res;
};

std::array<std::array<double, 3>, 3> matmulscal3x3(std::array<std::array<double, 3>, 3> m, double v) {
	std::array<std::array<double, 3>, 3> res;
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			res[i][j] = m[i][j] * v;
		}
	}
	return res;
};

std::array<double, 3> vecaddvec3x1(std::array<double, 3>  m, std::array<double, 3>  v) {
	std::array<double, 3>  res;
	for (int i = 0; i < 3; i++) {
		res[i] = m[i] + v[i];
	}
	return res;
};

std::array<double, 3> vecsubvec3x1(std::array<double, 3>  m, std::array<double, 3>  v) {
	std::array<double, 3>  res;
	for (int i = 0; i < 3; i++) {
		res[i] = m[i] - v[i];
	}
	return res;
};

std::array<double, 3> vecmulscal3x1(std::array<double, 3>  m, double  v) {
	std::array<double, 3>  res;
	for (int i = 0; i < 3; i++) {
		res[i] = m[i] * v;
	}
	return res;
};

std::array<double, 3> cross(std::array<double, 3>  a, std::array<double, 3>   b) {
	std::array<double, 3>  res;
	res[0] = a[1] * b[2] - a[2] * b[1];
	res[1] = a[2] * b[0] - a[0] * b[2];
	res[2] = a[0] * b[1] - a[1] * b[0];
	return res;
};


aircraft_dynamics_custom::aircraft_dynamics_custom()
{
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

void aircraft_dynamics_custom::aircraft_model(const std::array<double, 9> x, const std::array<double, 5> u, std::array<double, 9>& xdot) {
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
	{		u[1] = u2max;

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

