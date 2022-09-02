
poselog = importdata("../Unreal_Simulation/Source/pose_log.txt")

time = cumsum([0; poselog(1:length(poselog(:,1))-1,7)]);


poselog(:,14) = poselog(:,14) *180/pi;
poselog(:,15) = poselog(:,15) *180/pi;
poselog(:,16) = poselog(:,16) *180/pi;


% figure;
subplot(3,1,1)
plot(time,poselog(:,1));
title("x")

subplot(3,1,2)
plot(time,poselog(:,2));
title("y")

subplot(3,1,3)
plot(time,poselog(:,3));
title("z")


%% PLOT states

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

figure;
subplot(5,1,1)
plot(time,poselog(:,17));
title("Querruder")

subplot(5,1,2)
plot(time,poselog(:,18));
title("Hoehenruder")

subplot(5,1,3)
plot(time,poselog(:,19));
title("Seitenruder")

subplot(5,1,4)
plot(time,poselog(:,20));
title("Triebwerk1")

subplot(5,1,5)
plot(time,poselog(:,21));
title("triebwerk2")