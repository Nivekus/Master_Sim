
clear all
close all
clc
k_zeta_beta = -20;
k_eta_phi2 = 0;

i_xi_phi = -0.05;
k_xi_phi = -1.;
k_xi_p=0.3;
phi_c = 10*pi/180;

k_eta_q = 5;
k_eta_theta = 20;
k_theta_H = 0.009;
k_f_V = 0.01;
r_f_V = 0.1;
Hc = 500;
Vc = 100;
k_zeta_r = 30;
T = 0.1;



% get data
init_model;
UEPlot;

% Comparison plot

figure;
subplot(3,3,1)
plot(res.tout,res.simX.signals.values(:,1),time,poselog(:,8));
title("u")

subplot(3,3,4)
plot(res.tout,res.simX.signals.values(:,2),time,poselog(:,9));
title("v")

subplot(3,3,7)
plot(res.tout,res.simX.signals.values(:,3),time,poselog(:,10));
title("w")

subplot(3,3,2)
plot(res.tout,res.simX.signals.values(:,4),time,poselog(:,11));
title("p")

subplot(3,3,5)
plot(res.tout,res.simX.signals.values(:,5),time,poselog(:,12));
title("q")

subplot(3,3,8)
plot(res.tout,res.simX.signals.values(:,6),time,poselog(:,13));
title("r")

subplot(3,3,3)
plot(res.tout,res.simX.signals.values(:,7),time,poselog(:,14));
title("phi")

subplot(3,3,6)
plot(res.tout,res.simX.signals.values(:,8),time,poselog(:,15));
title("theta")

subplot(3,3,9)
plot(res.tout,res.simX.signals.values(:,9),time,poselog(:,16));
title("psi")

figure;
subplot(3,1,1)
plot(time,poselog(:,1),res.tout,res.simX2.signals.values(1,:));
title("x")

subplot(3,1,2)
plot(time,poselog(:,2),res.tout,res.simX2.signals.values(2,:));
title("y")

subplot(3,1,3)
plot(time,poselog(:,3),res.tout,res.simX2.signals.values(3,:));
title("h")

figure;
subplot(5,1,1)
plot(time,poselog(:,17),res.tout,res.simU.signals.values(:,1));
title("Querruder")

subplot(5,1,2)
plot(time,poselog(:,18),res.tout,res.simU.signals.values(:,2));
title("Hoehenruder")

subplot(5,1,3)
plot(time,poselog(:,19),res.tout,res.simU.signals.values(:,3));
title("Seitenruder")

subplot(5,1,4)
plot(time,poselog(:,20),res.tout,res.simU.signals.values(:,4));
title("Triebwerk1")

subplot(5,1,5)
plot(time,poselog(:,21),res.tout,res.simU.signals.values(:,5));
title("triebwerk2")


%% plot sim
figure
subplot(3,3,1)
plot(res.tout,res.simX.signals.values(:,1));
title("u")

subplot(3,3,4)
plot(res.tout,res.simX.signals.values(:,2));
title("v")

subplot(3,3,7)
plot(res.tout,res.simX.signals.values(:,3));
title("w")

subplot(3,3,2)
plot(res.tout,res.simX.signals.values(:,4));
title("p")

subplot(3,3,5)
plot(res.tout,res.simX.signals.values(:,5));
title("q")

subplot(3,3,8)
plot(res.tout,res.simX.signals.values(:,6));
title("r")

subplot(3,3,3)
plot(res.tout,res.simX.signals.values(:,7));
title("phi")

subplot(3,3,6)
plot(res.tout,res.simX.signals.values(:,8));
title("theta")

subplot(3,3,9)
plot(res.tout,res.simX.signals.values(:,9));
title("psi")


figure;
subplot(3,1,1)
plot(res.tout,res.simX2.signals.values(1,:));
title("x")

subplot(3,1,2)
plot(res.tout,res.simX2.signals.values(2,:));
title("y")

subplot(3,1,3)
plot(res.tout,res.simX2.signals.values(3,:));
title("h")


%% plot UE Sim
figure;
subplot(3,3,1)
plot(time,poselog(:,8));
title("u")

subplot(3,3,4)
plot(time,poselog(:,9));
title("v")

subplot(3,3,7)
plot(time,poselog(:,10));
title("w")

subplot(3,3,2)
plot(time,poselog(:,11));
title("p")

subplot(3,3,5)
plot(time,poselog(:,12));
title("q")

subplot(3,3,8)
plot(time,poselog(:,13));
title("r")

subplot(3,3,3)
plot(time,poselog(:,14));
title("phi")

subplot(3,3,6)
plot(time,poselog(:,15));
title("theta")

subplot(3,3,9)
plot(time,poselog(:,16));
title("psi")

