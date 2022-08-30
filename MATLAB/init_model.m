%%Init Sim

plot_states = false;
plot_position = false;
plot_input = false;
plot_gamma_alpha = false;
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

TF = 100;




%% RUN Simulation 
res = sim("modelsim.slx")
res.simX.signals.values(:,7) = res.simX.signals.values(:,7) * 180/pi;
res.simX.signals.values(:,8) = res.simX.signals.values(:,8) * 180/pi;
res.simX.signals.values(:,9) = res.simX.signals.values(:,9) * 180/pi;
%% PLOT states

if(plot_states)
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
end
%% Plot Pose
if plot_position
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
end
%% Plot U
if plot_input
    figure;
    subplot(5,1,1)
    plot(res.tout,res.simU.signals.values(:,1));
    title("Querruder")
    
    subplot(5,1,2)
    plot(res.tout,res.simU.signals.values(:,2));
    title("Hoehenruder")
    
    subplot(5,1,3)
    plot(res.tout,res.simU.signals.values(:,3));
    title("Seitenruder")
    
    subplot(5,1,4)
    plot(res.tout,res.simU.signals.values(:,4));
    title("Triebwerk1")
    
    subplot(5,1,5)
    plot(res.tout,res.simU.signals.values(:,5));
    title("triebwerk2")
end
%% Plot gamma alpha
if plot_gamma_alpha
    figure;
    subplot(2,1,1)
    plot(res.tout,res.GammaAlpha.signals.values(:,1));
    title("Gamma")
    
    subplot(2,1,2)
    plot(res.tout,res.GammaAlpha.signals.values(:,2));
    title("alpha")
end
