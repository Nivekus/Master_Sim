// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"

#include <cstddef>
#include <cstdlib>

// includes for Dynamics model from Matlab Codegen
//#include "../DynamicsModel/rtwtypes.h"
//#include "../DynamicsModel/aircraft_dynamics.h"
//#include "../DynamicsModel/rt_nonfinite.h"

//#include <rt_nonfinite.h>
//#include <rtwtypes.h>
// includes boost library using plugin
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
	double X[9];
	double U[5];
	double position[3];
	aircraft_dynamics* dynamics;
	//boost::numeric::odeint::runge_kutta4<x_type> integrator;
	
	
	void get_earth_velocity(const double v[3], double phi, double theta, double psi,
		double y[3]);
	
	void calcStep(double dt);


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
		void update_aircraft(double dt, double &x, double& y, double& z, double& phi, double& theta, double& psi);
};
