
poselog = importdata("../Unreal_Simulation/Source/pose_log.txt")

time = cumsum(poselog(:,7));
% figure;
% subplot(3,1,1)
% plot(time,poselog(:,1));
% title("x")
% 
% subplot(3,1,2)
% plot(time,poselog(:,2));
% title("y")
% 
% subplot(3,1,3)
% plot(time,poselog(:,3));
% title("z")


%% PLOT states

% figure;
% subplot(3,3,1)
% plot(time,poselog(:,8));
% title("u")
% 
% subplot(3,3,4)
% plot(time,poselog(:,9));
% title("v")
% 
% subplot(3,3,7)
% plot(time,poselog(:,10));
% title("w")
% 
% subplot(3,3,2)
% plot(time,poselog(:,11));
% title("p")
% 
% subplot(3,3,5)
% plot(time,poselog(:,12));
% title("q")
% 
% subplot(3,3,8)
% plot(time,poselog(:,13));
% title("r")
% 
% subplot(3,3,3)
% plot(time,poselog(:,14));
% title("phi")
% 
% subplot(3,3,6)
% plot(time,poselog(:,15));
% title("theta")
% 
% subplot(3,3,9)
% plot(time,poselog(:,16));
% title("psi")