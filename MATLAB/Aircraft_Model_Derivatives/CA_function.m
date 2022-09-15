function CA  = CA_function(alpha,elevator,q,Va)
    alpha_switch = 14.5*pi/180;
    n = 5.5;
    a3 = -768.5;
    a2 = 609.2;
    a1 = -155.2;
    a0 = 15.212;
    alpha_L0 = -11.5*pi/180;
    depsda = 0.25;
    St = 64;
    S = 260;
    lt = 24.8;


    alpha = alpha*pi/180;
    if alpha <= alpha_switch
        CL_wb = n*(alpha-alpha_L0); 
    else
        CL_wb = a3*alpha.^3 + a2 * alpha.^2 + a1 * alpha + a0;
    end

    epsilon = depsda *(alpha -alpha_L0);
    alpha_t = alpha - epsilon + elevator + 1.3 *q *lt/Va;
    CL_t = 3.1 * (St/S)*alpha_t;
    CA = CL_wb;%+CL_t;
end
