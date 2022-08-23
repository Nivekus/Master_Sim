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

void ADrone::setU(double u1, double u2, double u3, double u4, double u5)
{
	U[0] = u1;
	U[1] = u2;
	U[2] = u3;
	U[3] = u4;
	U[4] = u5;

}

