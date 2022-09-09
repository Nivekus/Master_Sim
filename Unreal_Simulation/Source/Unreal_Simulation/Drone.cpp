// Fill out your copyright notice in the Description page of Project Settings.


#include "Drone.h"

// Sets default values
ADrone::ADrone()
{
	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	X[0] = 85;
	X[1] = 0;
	X[2] = 0;
	X[3] = 0;
	X[4] = 0;
	X[5] = 0;
	X[6] = 0;
	X[7] = 0.1;
	X[8] = 0;

	U[0] = 0;
	U[1] = -0.1;
	U[2] = 0;
	U[3] = 0.08;
	U[4] = 0.08;

	r_u_prev = X[5];
	r_y_prev = 0;

	v_c = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);

	double v[3];
	double y[3];

	v[0] = X[0];
	v[1] = X[1];
	v[2] = X[2];

	dynamics.calc_earth_velocity(v, X[6], X[7], X[8], y);
	calc_chi(y[0], y[1]);
	chi_c = chi;


}

// Called when the game starts or when spawned
void ADrone::BeginPlay()
{
	std::array<double, 3> tmp;
	Super::BeginPlay();
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
	tmp[0]  = FMath::DegreesToRadians(rot.Roll);
	tmp[1] = FMath::DegreesToRadians(rot.Pitch);
	tmp[2] = FMath::DegreesToRadians(rot.Yaw);
	dynamics.set_orientation(tmp);
	dynamics.U_c = { 0,0,0,0,0 };
	dynamics.U_r = { 0,0,0,0,0 };
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
	//u = X[0];
	//v = X[1];
	//w = X[2];
	u = dynamics.X[0];
	v = dynamics.X[1];
	w = dynamics.X[2];


}

void ADrone::get_chi(double& chi_output) {
	//chi_output = chi;
	chi_output = dynamics.chi;
}


void ADrone::get_U(double& u1, double& u2, double& u3, double& u4, double& u5) {
	/*u1 = U_c[0];
	u2 =  U_c[1];
	u3 =  U_c[2];
	u4 =  U_c[3];
	u5 =  U_c[4];*/

	u1 = dynamics.U_c[0];
	u2 = dynamics.U_c[1];
	u3 = dynamics.U_c[2];
	u4 = dynamics.U_c[3];
	u5 = dynamics.U_c[4];


}

void ADrone::setU(double u0, double u1, double u2, double u3, double u4)
{
	U[0] = u0;
	U[1] = u1;
	U[2] = u2;
	U[3] = u3;
	U[4] = u4;
}

void ADrone::setX0(double x0, double x1, double x2, double x3, double x4, double x5, double x6, double x7, double x8)
{
	X[0] = x0;
	X[1] = x1;
	X[2] = x2;
	X[3] = x3;
	X[4] = x4;
	X[5] = x5;
	X[6] = x6;
	X[7] = x7;
	X[8] = x8;

	v_c = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);

	double v[3];
	double y[3];

	v[0] = X[0];
	v[1] = X[1];
	v[2] = X[2];

	dynamics.calc_earth_velocity(v, X[6], X[7], X[8], y);
	calc_chi(y[0], y[1]);
	chi_c = chi;
}

void ADrone::set_orientation(double x6, double x7, double x8) {
	X[6] = x6;
	X[7] = x7;
	X[8] = x8;

	phi_c = x6;
	theta_c = x7;

	double v[3];
	double y[3];

	v[0] = X[0];
	v[1] = X[1];
	v[2] = X[2];

	dynamics.calc_earth_velocity(v, X[6], X[7], X[8], y);
	calc_chi(y[0], y[1]);
	chi_c = chi;

	std::array<double, 3> orientation_init = { x6,x7,x8 };
	dynamics.set_orientation(orientation_init);
}


void ADrone::setposition(double x, double y, double z) {
	position[0] = x;
	position[1] = y;
	position[2] = z;
	h_c = z;

	std::array<double, 3> position_init = {x,y,z};
	dynamics.set_position(position_init);
}


void ADrone::calc_step(double dt) {
	double Xdot[9];
	//double Xdot2[9];

	// calculate augmented control values U
	U_c[0] = U[0] + U_r[0];
	U_c[1] = U[1] + U_r[1];
	U_c[2] = U[2] + U_r[2];
	U_c[3] = U[3] + U_r[3];
	U_c[4] = U[4] + U_r[4];

	//dynamics.aircraft_model(X, U_c, Xdot);
	dynamics.aircraft_model(X, U_c, Xdot);
	
	//euler 
	for (int i = 0; i < 9; i++) {
		X[i] += dt * Xdot[i];
	}

	//calculate position
	double v[3];
	double y[3];

	v[0] = X[0];
	v[1] = X[1];
	v[2] = X[2];

	dynamics.calc_earth_velocity(v, X[6], X[7], X[8], y);

	for (int i = 0; i < 3; i++) {
		position[i] += dt * y[i];
	}

	calc_chi(y[0], y[1]);

}


void ADrone::update_aircraft(double dt, double& pos_x, double& pos_y, double& pos_z, double& phi, double& theta, double& psi) {
	
/*	pos_x = position[0];
	pos_y = position[1];
	pos_z = position[2];
	phi = X[6];
	theta = X[7];
	psi = X[8];
	
	
	
	
	if (LOGGING) {
		str = str + FString::SanitizeFloat(pos_x)
			+ " " + FString::SanitizeFloat(pos_y)
			+ " " + FString::SanitizeFloat(pos_z)
			+ " " + FString::SanitizeFloat(phi)
			+ " " + FString::SanitizeFloat(theta)
			+ " " + FString::SanitizeFloat(psi)
			+ " " + FString::SanitizeFloat(dt)
			+ " " + FString::SanitizeFloat(X[0])
			+ " " + FString::SanitizeFloat(X[1])
			+ " " + FString::SanitizeFloat(X[2])
			+ " " + FString::SanitizeFloat(X[3])
			+ " " + FString::SanitizeFloat(X[4])
			+ " " + FString::SanitizeFloat(X[5])
			+ " " + FString::SanitizeFloat(X[6])
			+ " " + FString::SanitizeFloat(X[7])
			+ " " + FString::SanitizeFloat(X[8])
			+ " " + FString::SanitizeFloat(U[0] + U_r[0])
			+ " " + FString::SanitizeFloat(U[1] + U_r[1])
			+ " " + FString::SanitizeFloat(U[2] + U_r[2])
			+ " " + FString::SanitizeFloat(U[3] + U_r[3])
			+ " " + FString::SanitizeFloat(U[4] + U_r[4])
			+ "\n";
		FFileHelper::SaveStringToFile(str, *(FPaths::GameSourceDir() + "pose_log.txt"));
	}

	calc_step(dt);

	//reset control values
	for (int i = 0; i < 5; i++) {
		U_r[i] = 0;
	}

	// run before step for correct integrator initial values
	phi_controller(dt);
	velocity_controller(dt);
	phygoid_damper_theta_controller();
	pitch_damper();
	yaw_damper(dt);
	roll_damper();
	curve_coordination();
	chi_controller();
	hight_controller();*/
	dynamics.calc_controlled_step(dt, pos_x, pos_y, pos_z, phi, theta, psi);
}

void ADrone::pitch_damper() {
	U_r[1] += k_eta_q * X[4];
}

void ADrone::roll_damper() {
	U_r[0] += k_xi_p * X[3];
}

void ADrone::phygoid_damper_theta_controller() {
	U_r[1] += k_eta_theta * (X[7] - theta_c);
}


void ADrone::hight_controller() {
	double H_error;
	H_error = h_c - position[2];
	theta_c = k_theta_H * H_error;

	// limit max theta angle
	theta_c = std::min(theta_c, 30 * M_PI / 180);
}

void ADrone::velocity_controller(double dt) {
	// PI control
	double V = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);
	double V_error = v_c - V;
	double Pout = r_f_V * V_error;
	static double V_integral = 0;
	V_integral += V_error * dt;
	double Iout = k_f_V * V_integral;

	U_r[3] += Iout + Pout;
	U_r[4] += Iout + Pout;
}


void ADrone::phi_controller(double dt) {

	double phi_error;
	phi_error = X[6] - phi_c;

	// PI control
	double Pout = k_xi_phi * phi_error;
	static double phi_integral = 0;
	phi_integral += phi_error * dt;

	double Iout = phi_integral * i_xi_phi;

	U_r[0] += Iout + Pout;

}

void ADrone::chi_controller() {

	double error;
	error = calc_chi_error();
	phi_c = k_phi_chi * error;
	// limit banking angle 
	phi_c = std::max(phi_c, -50 * M_PI / 180);
	phi_c = std::min(phi_c, 50 * M_PI / 180);
}

void ADrone::calc_chi(double v_x_e, double v_y_e) {
	chi = M_PI / 2 - std::atan2(v_x_e, v_y_e);
}

double ADrone::calc_chi_error() {
	double error = std::fmod(-chi + chi_c + M_PI, 2*M_PI);
	if (error < 0) {
		error += 2 * M_PI;
	}
	return error - M_PI;

};



void ADrone::yaw_damper(double dt) {

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

void ADrone::curve_coordination() {
	double V = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);
	double beta = asin(X[1] / V);

	U_r[2] -= k_zeta_beta * beta;
}

void ADrone::set_v_c(double v) {
	this->v_c = v;
	dynamics.v_c = v;
}

void ADrone::set_h_c(double h) {
	this->h_c = h;
	dynamics.h_c = h;
}

void ADrone::set_chi_c(double chi_input) {
	this->chi_c = chi_input;
	dynamics.chi_c = chi_input;
}

void ADrone::set_phi_c(double phi) {
	this->phi_c = phi;
	dynamics.phi_c = phi;
}

void ADrone::set_k_zeta_r(double k, double t) {
	this->k_zeta_r = k;
	this->T = T;
}
void ADrone::set_k_xi_p(double k) {
	this->k_xi_p = k;
};
