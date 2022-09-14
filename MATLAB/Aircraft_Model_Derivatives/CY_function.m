function CY  = CY_function(beta, rudder)
    beta = beta * pi/180;
    CY = 1.6*beta+0.24*rudder;
end