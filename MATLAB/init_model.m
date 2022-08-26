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


initpos = [0;0;500]


% Rtheta =[cos(0.1) 0 -sin(0.1);
%          0 1 0;
%          sin(0.1) 0 cos(0.1)];
% 
% 
%         
% R =  Rtheta ;
% x10to12dot = R' * x0(1:3);
% 
% x0 = [x0;x10to12dot];


u = [0;
     -0.2;
     0;
     0.08;
     0.08];

TF = 40;

%% RUN Simulation 
res = sim("modelsim.slx")
res.simX.signals.values(:,7) = res.simX.signals.values(:,7) * 180/pi;
res.simX.signals.values(:,8) = res.simX.signals.values(:,8) * 180/pi;
res.simX.signals.values(:,9) = res.simX.signals.values(:,9) * 180/pi;
%% PLOT states

% subplot(3,3,1)
% plot(res.tout,res.simX.signals.values(:,1));
% title("u")
% 
% subplot(3,3,4)
% plot(res.tout,res.simX.signals.values(:,2));
% title("v")
% 
% subplot(3,3,7)
% plot(res.tout,res.simX.signals.values(:,3));
% title("w")
% 
% subplot(3,3,2)
% plot(res.tout,res.simX.signals.values(:,4));
% title("p")
% 
% subplot(3,3,5)
% plot(res.tout,res.simX.signals.values(:,5));
% title("q")
% 
% subplot(3,3,8)
% plot(res.tout,res.simX.signals.values(:,6));
% title("r")
% 
% subplot(3,3,3)
% plot(res.tout,res.simX.signals.values(:,7));
% title("phi")
% 
% subplot(3,3,6)
% plot(res.tout,res.simX.signals.values(:,8));
% title("theta")
% 
% subplot(3,3,9)
% plot(res.tout,res.simX.signals.values(:,9));
% title("psi")
% 
% 
% figure;
% subplot(3,1,1)
% plot(res.tout,res.simX2.signals.values(1,:));
% title("x")
% 
% subplot(3,1,2)
% plot(res.tout,res.simX2.signals.values(2,:));
% title("y")
% 
% subplot(3,1,3)
% plot(res.tout,res.simX2.signals.values(3,:));
% title("h")
