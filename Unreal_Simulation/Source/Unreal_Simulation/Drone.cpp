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
	tmp[0]  = FMath::DegreesToRadians(rot.Roll);
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
