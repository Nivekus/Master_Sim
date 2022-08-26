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
	U[3] = 0.08;
	U[4] = 0.08;

	
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
	dynamics->aircraft_model(X, U, Xdot);
	

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
	
	get_earth_velocity(v, X[7], X[8], X[9],y);

	for (int i = 0; i < 3; i++) {
		position[i] += dt * y[i];
	}


}

void ADrone::get_earth_velocity(const double v[3], double phi, double theta, double psi,
	double y[3])
{
	static const signed char iv[3]{ 0, 0, 1 };
	double c_Rtheta_tmp[9];
	double dv[9];
	double dv1[9];
	double Rphi_tmp;
	double Rpsi_tmp;
	double Rtheta_tmp;
	double b_Rphi_tmp;
	double b_Rtheta_tmp;
	int i1;
	Rpsi_tmp = std::cos(psi);
	Rtheta_tmp = std::sin(theta);
	b_Rtheta_tmp = std::cos(theta);
	Rphi_tmp = std::sin(phi);
	b_Rphi_tmp = std::cos(phi);
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
	for (int i{ 0 }; i < 3; i++) {
		i1 = static_cast<int>(dv[i]);
		b_Rtheta_tmp = dv[i + 3];
		Rphi_tmp = dv[i + 6];
		for (int i2{ 0 }; i2 < 3; i2++) {
			dv1[i + 3 * i2] = (static_cast<double>(i1) * c_Rtheta_tmp[3 * i2] +
				b_Rtheta_tmp * c_Rtheta_tmp[3 * i2 + 1]) +
				Rphi_tmp * c_Rtheta_tmp[3 * i2 + 2];
		}
	}
	c_Rtheta_tmp[0] = Rpsi_tmp;
	c_Rtheta_tmp[3] = 0.41211848524175659;
	c_Rtheta_tmp[6] = 0.0;
	c_Rtheta_tmp[1] = -std::sin(psi);
	c_Rtheta_tmp[4] = Rpsi_tmp;
	c_Rtheta_tmp[7] = 0.0;
	for (int i{ 0 }; i < 3; i++) {
		i1 = iv[i];
		c_Rtheta_tmp[3 * i + 2] = i1;
		b_Rtheta_tmp = 0.0;
		Rphi_tmp = c_Rtheta_tmp[3 * i];
		Rtheta_tmp = c_Rtheta_tmp[3 * i + 1];
		for (int i2{ 0 }; i2 < 3; i2++) {
			b_Rtheta_tmp += ((dv1[i2] * Rphi_tmp + dv1[i2 + 3] * Rtheta_tmp) +
				dv1[i2 + 6] * static_cast<double>(i1)) *
				v[i2];
		}
		y[i] = b_Rtheta_tmp;
	}
	y[2] = -y[2];
}


void ADrone::update_aircraft(double dt, double& x, double& y, double& z, double& phi, double& theta, double& psi) {

	calcStep(dt);
	x = position[0];
	y = position[1];
	z = position[2];
	phi =	X[7];
	theta = X[8];
	psi =	X[9];
}

