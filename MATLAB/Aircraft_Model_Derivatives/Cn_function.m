
function Cn = Cn_function(alpha,beta,Va,p,r,u3)
cbar = 6.6;
Cn = (1-alpha*180/(15*pi))*beta +(cbar/Va) *(1.7*p -11.5*r)-0.63*u3;
end