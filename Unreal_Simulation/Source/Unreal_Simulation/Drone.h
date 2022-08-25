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





typedef boost::array<double, 9> x_type;
typedef boost::array<double, 5> u_type;


UCLASS()
class UNREAL_SIMULATION_API ADrone : public APawn
{
	GENERATED_BODY()

public:
	// Sets default values for this pawn's properties
	ADrone();
	x_type X;
	boost::numeric::odeint::runge_kutta4<x_type> integrator;
	double startpose[3];

	struct system
	{
		u_type u;
		aircraft_dynamics* dynamics;
		void operator()(x_type const& x, x_type const& dxdt, double t) const
		{
			double u_model[5];
			double x_model[9];
			double xdot_model[9];

			u_model[0] = u[0];
			u_model[1] = u[1];
			u_model[2] = u[2];
			u_model[3] = u[3];
			u_model[4] = u[4];

			x_model[0] = x[0];
			x_model[1] = x[1];
			x_model[2] = x[2];
			x_model[3] = x[3];
			x_model[4] = x[4];
			x_model[5] = x[5];
			x_model[6] = x[6];
			x_model[7] = x[7];
			x_model[8] = x[8];

			dynamics->aircraft_model(x_model, u_model, xdot_model);
		}

	}sys;

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	// Called to bind functionality to input
	virtual void SetupPlayerInputComponent(class UInputComponent* PlayerInputComponent) override;

	UFUNCTION(BlueprintCallable)
		void setU(double u0, double u1, double u2, double u3, double u4);

	UFUNCTION(BlueprintCallable)
		void setX0(double x0, double x1, double x2, double x3, double x4, double x5, double x6, double x7, double x8);

	UFUNCTION(BlueprintCallable)
		void calcStep();

};
