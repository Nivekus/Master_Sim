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
	U[1] = -0.2;
	U[2] = 0;
	U[3] = 0.088;
	U[4] = 0.088;


}

// Called when the game starts or when spawned
void ADrone::BeginPlay()
{
	Super::BeginPlay();

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


void ADrone::get_u_w_v(double& u, double& v, double& w) {
	u = X[0];
	v = X[1];
	w = X[2];
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

}

void ADrone::setposition(double x, double y, double z) {
	position[0] = x;
	position[1] = y;
	position[2] = z;
}



void ADrone::calcStep(double dt) {
	double Xdot[9];

	// calculate augmented control values U

	double U_c[5];
	U_c[0] = U[0] + U_r[0];
	U_c[1] = U[1] + U_r[1];
	U_c[2] = U[2] + U_r[2];
	U_c[3] = U[3] + U_r[3];
	U_c[4] = U[4] + U_r[4];



	dynamics->aircraft_model(X, U_c, Xdot);


	//euler 
	for (int i = 0; i < 8; i++) {
		X[i] += dt * Xdot[i];
	}

	//calculate position
	double v[3];
	double y[3];

	v[0] = X[0];
	v[1] = X[1];
	v[2] = X[2];

	get_earth_velocity(v, X[6], X[7], X[8], y);

	for (int i = 0; i < 3; i++) {
		position[i] += dt * y[i];
	}


}

void ADrone::get_earth_velocity(const double v[3], double phi, double theta, double psi,
	double y[3])
{
	static const signed char iv[3] = { 0, 0, 1 };
	double c_Rtheta_tmp[9];
	double dv[9];
	double dv1[9];
	double Rphi_tmp;
	double Rpsi_tmp;
	double Rtheta_tmp;
	double b_Rphi_tmp;
	double b_Rpsi_tmp;
	double b_Rtheta_tmp;
	int i;
	int i1;
	int i2;
	Rpsi_tmp = sin(psi);
	b_Rpsi_tmp = cos(psi);
	Rtheta_tmp = sin(theta);
	b_Rtheta_tmp = cos(theta);
	Rphi_tmp = sin(phi);
	b_Rphi_tmp = cos(phi);
	dv[1] = 0.0;
	dv[4] = b_Rphi_tmp;
	dv[7] = Rphi_tmp;
	dv[2] = 0.0;
	dv[5] = -Rphi_tmp;
	dv[8] = b_Rphi_tmp;
	c_Rtheta_tmp[0] = b_Rtheta_tmp;
	c_Rtheta_tmp[3] = 0.0;
	c_Rtheta_tmp[6] = -Rtheta_tmp;
	dv[0] = 1.0;
	c_Rtheta_tmp[1] = 0.0;
	dv[3] = 0.0;
	c_Rtheta_tmp[4] = 1.0;
	dv[6] = 0.0;
	c_Rtheta_tmp[7] = 0.0;
	c_Rtheta_tmp[2] = Rtheta_tmp;
	c_Rtheta_tmp[5] = 0.0;
	c_Rtheta_tmp[8] = b_Rtheta_tmp;
	for (i = 0; i < 3; i++) {
		i1 = (int)dv[i];
		b_Rtheta_tmp = dv[i + 3];
		Rphi_tmp = dv[i + 6];
		for (i2 = 0; i2 < 3; i2++) {
			dv1[i + 3 * i2] = ((double)i1 * c_Rtheta_tmp[3 * i2] +
				b_Rtheta_tmp * c_Rtheta_tmp[3 * i2 + 1]) +
				Rphi_tmp * c_Rtheta_tmp[3 * i2 + 2];
		}
	}
	c_Rtheta_tmp[0] = b_Rpsi_tmp;
	c_Rtheta_tmp[3] = Rpsi_tmp;
	c_Rtheta_tmp[6] = 0.0;
	c_Rtheta_tmp[1] = -Rpsi_tmp;
	c_Rtheta_tmp[4] = b_Rpsi_tmp;
	c_Rtheta_tmp[7] = 0.0;
	for (i = 0; i < 3; i++) {
		i1 = iv[i];
		c_Rtheta_tmp[3 * i + 2] = i1;
		b_Rtheta_tmp = 0.0;
		Rphi_tmp = c_Rtheta_tmp[3 * i];
		Rtheta_tmp = c_Rtheta_tmp[3 * i + 1];
		for (i2 = 0; i2 < 3; i2++) {
			b_Rtheta_tmp += ((dv1[i2] * Rphi_tmp + dv1[i2 + 3] * Rtheta_tmp) +
				dv1[i2 + 6] * (double)i1) *
				v[i2];
		}
		y[i] = b_Rtheta_tmp;
	}
	y[2] = -y[2];
}


void ADrone::update_aircraft(double dt, double& pos_x, double& pos_y, double& pos_z, double& phi, double& theta, double& psi) {



	if (LOGGING) {
		pos_x = position[0];
		pos_y = position[1];
		pos_z = position[2];
		phi = X[6];
		theta = X[7];
		psi = X[8];
		//FString strs;
		//strs << x << " " << y << " " << z <<" " << phi << " " << theta << " " << psi << " "<< dt << std::endl;
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



	calcStep(dt);

	//reset control values
	for (int i = 0; i < 5; i++) {
		U_r[i] = 0;
	}


	phygoid_daempner();
	pitch_daempner();
	hight_controller(500, 100, dt);

}


void ADrone::pitch_daempner() {
	U_r[1] += k_eta_q * X[4];
}

void ADrone::phygoid_daempner() {
	U_r[1] += k_eta_theta * X[7];
}

void ADrone::hight_controller(double H_c, double V_c, double dt) {
	
	double H_error;
	H_error = position[2] - H_c;
	U_r[1] -= -k_eta_theta*(k_theta_H * H_error);


	// PI control
	double V = std::sqrt(X[0] * X[0] + X[1] * X[1] + X[2] * X[2]);
	double V_error = V_c - V;
	double Pout = r_f_V * V_error;
	
	V_integral += V_error * dt;
	/*{if (V_integral <= 0.0087266462599716477) {
		V_integral = 0.0087266462599716477;
	}
	else if (V_integral > 0.17453292519943295) {
		V_integral = 0.17453292519943295;
	}*/


	double Iout = k_f_V * V_integral;

	U_r[3] += Iout + Pout;
	U_r[4] += Iout + Pout;

}


