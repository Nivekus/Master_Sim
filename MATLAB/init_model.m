%%Init Sim

clear
clc 
close all

x0 = [ 85;
        0;
        0;
        0;
        0;
        0;
        0;
        0.1;
        0];

u = [0;
     -0.1;
     0;
     0.08;
     0.08];

TF = 60;

%% RUN Simulation 
res = sim("modelsim.slx")

%% PLOT states

subplot(3,3,1)
%plot(res.simU,res.tout)