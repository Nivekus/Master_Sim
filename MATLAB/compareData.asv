

% get data
init_model
UEPlot
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

%% Comparison plot

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
