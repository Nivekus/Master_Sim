
poselog = importdata("../Unreal_Simulation/Source/pose_log.txt")

time = cumsum(poselog(:,7));
figure;
subplot(3,1,1)
plot(time,poselog(:,1));
title("x")

subplot(3,1,2)
plot(time,poselog(:,2));
title("y")

subplot(3,1,3)
plot(time,poselog(:,3));
title("z")