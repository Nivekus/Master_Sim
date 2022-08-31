close all

k_eta_q = 10;
k_eta_theta = 50;

% turning off other control
k_theta_H = 0.0;
k_f_V = 0.0;
r_f_V = 0;
Hc = 500;
Vc = 100;

k_zeta_r = 10;
T = 0.1;

init_model;
