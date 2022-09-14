
function Cl = Cl_function(beta,p,r,u1,u3,Va)
cbar = 6.6;
Cl = -1.4 *beta -11*cbar/Va*p+5*cbar/Va*r+(-0.6*u1)+0.22*u3;
end