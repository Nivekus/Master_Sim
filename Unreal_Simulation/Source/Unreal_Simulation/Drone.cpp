// Fill out your copyright notice in the Description page of Project Settings.


#include "Drone.h"

// Sets default values
ADrone::ADrone()
{
	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
}

// Called when the game starts or when spawned
void ADrone::BeginPlay()
{
	Super::BeginPlay();

	std::array<double, 3> tmp;
	dynamics.X[0] = 85;
	dynamics.X[1] = 0.0;
	dynamics.X[2] = 0.0;
	dynamics.X[3] = 0.0;
	dynamics.X[4] = 0.0;
	dynamics.X[5] = 0.0;
	FVector loc =  GetActorLocation();
	tmp[0] = loc.X / 100.0;
	tmp[1] = loc.Y / 100.0;
	tmp[2] = loc.Z / 100.0;
	dynamics.set_position(tmp);
	FRotator rot = GetActorRotation();
	tmp[0] = FMath::DegreesToRadians(rot.Roll);
	tmp[1] = FMath::DegreesToRadians(rot.Pitch);
	tmp[2] = FMath::DegreesToRadians(rot.Yaw);
	dynamics.set_orientation(tmp);
	dynamics.U_c = { 0,0,0,0,0 };
	dynamics.U_r = { 0,0,0,0,0 };
	dynamics.v_c = std::sqrt( dynamics.X[0] * dynamics.X[0] 
							+ dynamics.X[1] * dynamics.X[1] 
							+ dynamics.X[2] * dynamics.X[2]);

	//loads UE5 overwritten control parameters
	set_control_values();
	set_aircraft_parameters();
}

// Called every frame
void ADrone::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

// Called to bind functionality to input
void ADrone::SetupPlayerInputComponent(UInputComponent* PlayerInputComponent)
{
	Super::SetupPlayerInputComponent(PlayerInputComponent);

}


void ADrone::get_u_v_w(double& u, double& v, double& w) {
	u = dynamics.X[0];
	v = dynamics.X[1];
	w = dynamics.X[2];
}

void ADrone::get_chi(double& chi_output) {
	chi_output = dynamics.chi;
}


void ADrone::get_U(double& u1, double& u2, double& u3, double& u4, double& u5) {
	u1 = dynamics.U_c[0];
	u2 = dynamics.U_c[1];
	u3 = dynamics.U_c[2];
	u4 = dynamics.U_c[3];
	u5 = dynamics.U_c[4];
}

void ADrone::setU(double u0, double u1, double u2, double u3, double u4)
{
	dynamics.U[0] = u0;
	dynamics.U[1] = u1;
	dynamics.U[2] = u2;
	dynamics.U[3] = u3;
	dynamics.U[4] = u4;
}

void ADrone::setX0(double x0, double x1, double x2, double x3, double x4, double x5, double x6, double x7, double x8)
{
	std::array<double, 3> tmp;
	dynamics.X[0] = x0;
	dynamics.X[1] = x1;
	dynamics.X[2] = x2;
	dynamics.X[3] = x3;
	dynamics.X[4] = x4;
	dynamics.X[5] = x5;

	tmp[0] = x6;
	tmp[1] = x7;
	tmp[2] = x8;

	dynamics.set_orientation(tmp);
	dynamics.v_c = std::sqrt(dynamics.X[0] * dynamics.X[0]
		+ dynamics.X[1] * dynamics.X[1]
		+ dynamics.X[2] * dynamics.X[2]);
}

void ADrone::set_orientation(double x6, double x7, double x8) {
	std::array<double, 3> orientation_init = { x6,x7,x8 };
	dynamics.set_orientation(orientation_init);
}


void ADrone::setposition(double x, double y, double z) {
	std::array<double, 3> position_init = {x,y,z};
	dynamics.set_position(position_init);
}


void ADrone::update_aircraft(double dt, double& pos_x, double& pos_y, double& pos_z, double& phi, double& theta, double& psi) {
	FString str;
	if (LOGGING) {
		str = str + FString::SanitizeFloat(pos_x)
			+ " " + FString::SanitizeFloat(pos_y)
			+ " " + FString::SanitizeFloat(pos_z)
			+ " " + FString::SanitizeFloat(phi)
			+ " " + FString::SanitizeFloat(theta)
			+ " " + FString::SanitizeFloat(psi)
			+ " " + FString::SanitizeFloat(dt)
			+ "\n";
		FFileHelper::SaveStringToFile(str, *(FPaths::GameSourceDir() + "pose_log.txt"));
	}

	dynamics.calc_controlled_step(dt, pos_x, pos_y, pos_z, phi, theta, psi);
}



void ADrone::set_v_c(double v) {
	dynamics.v_c = v;
}

void ADrone::set_h_c(double h) {
	dynamics.h_c = h;
}

void ADrone::set_chi_c(double chi_input) {
	dynamics.chi_c = chi_input;
}

void ADrone::set_phi_c(double phi) {
	dynamics.phi_c = phi;
}

void ADrone::set_control_values() {
	dynamics.controller.k_eta_q = k_eta_q;
	dynamics.controller.k_xi_p = k_xi_p;
	dynamics.controller.k_eta_theta = k_eta_theta;
	dynamics.controller.k_theta_H = k_theta_H;
	dynamics.controller.r_f_V = r_f_V;
	dynamics.controller.k_f_V = k_f_V;
	dynamics.controller.k_xi_phi = k_xi_phi;
	dynamics.controller.i_xi_phi = i_xi_phi;
	dynamics.controller.k_phi_chi = k_phi_chi;
	dynamics.controller.k_zeta_beta = k_zeta_beta;
}

void ADrone::set_aircraft_parameters() {
	dynamics.m = mass;
	dynamics.g = gravity;
	dynamics.x_apt1 = engine_1[0];
	dynamics.y_apt1 = engine_1[1];
	dynamics.z_apt1 = engine_1[2];
	
	dynamics.x_apt2 = engine_2[0];
	dynamics.y_apt2 = engine_2[1];
	dynamics.z_apt2 = engine_2[2];

	dynamics.S = S;
	dynamics.St = St;

	dynamics.l = l;
	dynamics.lt = lt;

	dynamics.x_cg = center_of_gravity[0];
	dynamics.y_cg = center_of_gravity[1];
	dynamics.z_cg = center_of_gravity[2];

	dynamics.x_ac = center_of_lift[0];
	dynamics.y_ac = center_of_lift[1];
	dynamics.z_ac = center_of_lift[2];

	dynamics.rho = rho;
	dynamics.depsda = depsda;
	dynamics.alpha_L0 = alpha_L0;
	dynamics.alpha_switch = alpha_switch;
	dynamics.a0 = a0;
	dynamics.a1 = a1;
	dynamics.a2 = a2;
	dynamics.a3 = a3;
	dynamics.n = n;

	dynamics.u1min = cont_aileron[0];
	dynamics.u2min = cont_elevator[0];
	dynamics.u3min = cont_rudder[0];
	dynamics.u4min = cont_engine1[0];
	dynamics.u5min = cont_engine2[0];

	dynamics.u1max = cont_aileron[1];
	dynamics.u2max = cont_elevator[1];
	dynamics.u3max = cont_rudder[1];
	dynamics.u4max = cont_engine1[1];
	dynamics.u5max = cont_engine2[1];

	dynamics.Ib[0][0] = Ix;
	dynamics.Ib[1][1] = Iy;
	dynamics.Ib[2][2] = Iz;
	dynamics.Ib[0][2] = - Ixz;
	dynamics.Ib[2][0] = - Ixz;

	std::array<std::array<double, 3>, 3> m;

	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			m[i][j] = dynamics.Ib[i][j];
		}
	}

	// = dynamics.Ib;
	// computes the inverse of a matrix m
	double det = m[0][0] * (m[1][1] * m[2][2] - m[2][1] * m[1][2]) - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);

	double invdet = 1 / det;

	std::array<std::array<double, 3>, 3> minv;
	// inverse of matrix m
	minv[0][0] = (m[1][1] * m[2][2] - m[2][1] * m[1][2]) * invdet;
	minv[0][1] = (m[0][2] * m[2][1] - m[0][1] * m[2][2]) * invdet;
	minv[0][2] = (m[0][1] * m[1][2] - m[0][2] * m[1][1]) * invdet;
	minv[1][0] = (m[1][2] * m[2][0] - m[1][0] * m[2][2]) * invdet;
	minv[1][1] = (m[0][0] * m[2][2] - m[0][2] * m[2][0]) * invdet;
	minv[1][2] = (m[1][0] * m[0][2] - m[0][0] * m[1][2]) * invdet;
	minv[2][0] = (m[1][0] * m[2][1] - m[2][0] * m[1][1]) * invdet;
	minv[2][1] = (m[2][0] * m[0][1] - m[0][0] * m[2][1]) * invdet;
	minv[2][2] = (m[0][0] * m[1][1] - m[1][0] * m[0][1]) * invdet;

	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			dynamics.inv_Ib[i][j] = minv[i][j];
		}
	}
}

void ADrone::set_waypoint(double x, double y, double z) {
	dynamics.way_point[0] = x;
	dynamics.way_point[1] = y;
	dynamics.way_point[2] = z;
}

void ADrone::get_chi_c(double& chi_c_output) {
	chi_c_output = dynamics.chi_c;
};


