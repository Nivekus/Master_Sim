// Fill out your copyright notice in the Description page of Project Settings.

#pragma once


#define LOGGING true


#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"

#include <cstddef>
#include <cstdlib>
#include <sstream>

THIRD_PARTY_INCLUDES_START
#pragma push_macro("check")
#undef check
#include <boost/numeric/odeint.hpp>
#include <aircraft_dynamics.h>
#pragma pop_macro("check")
THIRD_PARTY_INCLUDES_END
#include "Drone.generated.h"


UCLASS()
class UNREAL_SIMULATION_API ADrone : public APawn
{
	GENERATED_BODY()

public:
	// Sets default values for this pawn's properties
	ADrone();
	aircraft_dynamics* dynamics;


	//set intial conditions
	double X[9];
	double U[5];
	double U_r[5] = {0,0,0,0,0};
	double position[3];
	


	//for logging
	FString str="";
	

	//aircraft control parameter
	// damper longitudinal
	double k_eta_q = 10;
	double k_eta_theta = 50;
	// damper lateral
	double k_zeta_r = 10;
	double T = 0.01;

	double r_u_prev;
	double r_y_prev;

	// height
	double k_theta_H = 0.009;
	double k_f_V = 0.01;
	double r_f_V = 10;

	//desired values
	double v_c = 100;
	double h_c = 500;


	void get_earth_velocity(const double v[3], double phi, double theta, double psi,
		double y[3]);
	
	void calcStep(double dt);

	void pitch_damper();

	void phygoid_damper();

	void yaw_damper(double dt);

	void hight_controller(double H_c, double V_c, double dt);
 
protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
public:
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	// Called to bind functionality to input
	virtual void SetupPlayerInputComponent(class UInputComponent* PlayerInputComponent) override;

	UFUNCTION(BlueprintCallable)
		void setposition(double x, double y, double z);

	UFUNCTION(BlueprintCallable)
		void setU(double u0, double u1, double u2, double u3, double u4);

	UFUNCTION(BlueprintCallable)
		void setX0(double x0, double x1, double x2, double x3, double x4, double x5, double x6, double x7, double x8);

	UFUNCTION(BlueprintCallable)
		void set_v_c(double v);

	UFUNCTION(BlueprintCallable)
		void set_h_c(double h);
	
	UFUNCTION(BlueprintCallable)
		void set_orientation(double x6, double x7, double x8);

	UFUNCTION(BlueprintCallable)
		void update_aircraft(double dt, double &x, double& y, double& z, double& phi, double& theta, double& psi);

	UFUNCTION(BlueprintCallable)
		void get_u_w_v(double& u, double& v, double& w);

};
