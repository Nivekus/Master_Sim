// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#define _USE_MATH_DEFINES
#define LOGGING false


#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"

#include <cstddef>
#include <cstdlib>
#include <sstream>
#include <math.h>
#include <algorithm>
#include <array>


THIRD_PARTY_INCLUDES_START
#pragma push_macro("check")
#undef check
#include <boost/numeric/odeint.hpp>
//#include <aircraft_dynamics.h>
#include <aircraft_dynamics_custom.h>
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
	aircraft_dynamics_custom dynamics;

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
		void set_chi_c(double chi_input);

	UFUNCTION(BlueprintCallable)
		void set_phi_c(double phi);

	UFUNCTION(BlueprintCallable)
		void set_k_zeta_r(double k_zeta_r, double T);

	UFUNCTION(BlueprintCallable)
		void set_k_xi_p(double k);

	UFUNCTION(BlueprintCallable)
		void set_orientation(double x6, double x7, double x8);

	UFUNCTION(BlueprintCallable)
		void update_aircraft(double dt, double& x, double& y, double& z, double& phi, double& theta, double& psi);

	UFUNCTION(BlueprintCallable)
		void get_u_v_w(double& u, double& v, double& w);

	UFUNCTION(BlueprintCallable)
		void get_chi(double& chi_output);

	UFUNCTION(BlueprintCallable)
		void get_U(double& u1, double& u2, double& u3, double& u4, double& u5);

};
