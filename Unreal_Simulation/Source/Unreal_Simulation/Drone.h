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
	aircraft_dynamics dynamics;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|pitch damper")
		double k_eta_q = dynamics.controller.k_eta_q;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|roll damper")
		double k_xi_p = dynamics.controller.k_xi_p;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|phygoid damper")
		double k_eta_theta = dynamics.controller.k_eta_theta;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|height")
		double k_theta_H = dynamics.controller.k_theta_H;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|velocity")
		double r_f_V = dynamics.controller.r_f_V;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|velocity")
		double k_f_V = dynamics.controller.k_f_V;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|phi")
		double k_xi_phi = dynamics.controller.k_xi_phi;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|phi")
		double i_xi_phi = dynamics.controller.i_xi_phi;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|chi")
		double k_phi_chi = dynamics.controller.k_phi_chi;
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Controller|curve coordinator")
		double k_zeta_beta = dynamics.controller.k_zeta_beta;

	void set_control_values();

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
