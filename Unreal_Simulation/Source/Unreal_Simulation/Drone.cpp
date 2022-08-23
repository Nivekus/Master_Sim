// Fill out your copyright notice in the Description page of Project Settings.


#include "Drone.h"

// Sets default values
ADrone::ADrone()
{
 	// Set this pawn to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	
	//default states and inputs
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

void ADrone::setU(double u0, double u1, double u2, double u3, double u4)
{
	U[0] = u0;
	U[1] = u1;
	U[2] = u2;
	U[3] = u3;
	U[4] = u4;
}

void ADrone::setInitpose(double x, double y, double z)
{
	startpose[0] = x;
	startpose[1] = y;
	startpose[2] = z;
}

void ADrone::calc_step()
{
	boost::numeric::odeint::runge_kutta4<boost::array<double, 9>> integrator;
}