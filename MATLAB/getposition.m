function y = getposition(v,phi,theta,psi)
    
    x7 = phi;
    x8 = theta;
    x9 = psi;



    Rpsi = [cos(x9) sin(x9) 0;
            -sin(x9) cos(x9) 0;
            0 0 1];
    
    Rtheta =[cos(x8) 0 -sin(x8);
             0 1 0;
             sin(x8) 0 cos(x8)];
    
    Rphi = [1 0 0;
            0 cos(x7) sin(x7);
            0 -sin(x7) cos(x7)];
            
    R = Rphi * Rtheta * Rpsi;

    y = R' * v;
    y(3) = -y(3);
   
end