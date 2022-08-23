// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"

#include <cstddef>
#include <cstdlib>
#include "../DynamicsModel/rtwtypes.h"
#include "../DynamicsModel/aircraft_dynamics.h"
#include "../DynamicsModel/rt_nonfinite.h"
//#include <boost/numeric/odeint.hpp>
#include "../../../../../../Program Files (x86)/UE_5.0/Engine/Source/ThirdParty/Boost/boost-1_70_0/include/boost/numeric/odeint.hpp"
#include "Drone.generated.h"


// includes for Dynamics model from Matlab Codegen



UCLASS()
class UNREAL_SIMULATION_API ADrone : public APawn
{
	GENERATED_BODY()

public:
	// Sets default values for this pawn's properties
	ADrone();
	aircraft_dynamics dynamics();
	double U[9];
	double X[5];
	double startpose[3];

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
	void setX0(double x0, double x1,double x2, double x3, double x4, double x5, double x6, double x7, double x8);

	UFUNCTION(BlueprintCallable)
	void setInitpose(double x, double y, double z);

	UFUNCTION(BlueprintCallable)
	void calc_step();
	
};
