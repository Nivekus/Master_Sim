close all

k_eta_q = 5;
%k_eta_theta = 50;
k_eta_theta = 20;
k_theta_H = 0.009;
k_f_V = 0.01;
r_f_V = 0.1;
Hc = 500;
Vc = 100;

figure
for i=1:5:30
k_zeta_r = 30;
T = 0.1/i;

 
init_model;
end