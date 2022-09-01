k_eta_q = 5;
%k_eta_theta = 50;
k_eta_theta = 20;
k_theta_H = 0.009;
k_f_V = 0.01;
r_f_V = 0.1;
Hc = 500;
Vc = 100;

UEPlot;

%figure;
subplot(3,3,1)
plot(time,poselog(:,8));
hold on;
title("u")

subplot(3,3,4)
plot(time,poselog(:,9));
hold on;
title("v")

subplot(3,3,7)
plot(time,poselog(:,10));
hold on;
title("w")

subplot(3,3,2)
plot(time,poselog(:,11));
hold on;
title("p")

subplot(3,3,5)
plot(time,poselog(:,12));
hold on;
title("q")

subplot(3,3,8)
plot(time,poselog(:,13));
hold on;
title("r")

subplot(3,3,3)
plot(time,poselog(:,14));
hold on;
title("phi")

subplot(3,3,6)
plot(time,poselog(:,15));
hold on;
title("theta")

subplot(3,3,9)
plot(time,poselog(:,16));
hold on;
title("psi")