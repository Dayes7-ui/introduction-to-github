function dydt=noble(t,y)
Cm=12;
    Vm=y(1);
    m=y(2);
    h=y(3);
    n=y(4);

    alpha_m =(-0.1 * (Vm + 48)) / (exp(-(Vm + 48) / 15) - 1);
    beta_m = (0.12 * (Vm + 8)) / (exp((Vm + 8) / 5) - 1);

    alpha_h =0.17 * exp(-(Vm+ 90) / 20);
    beta_h =1 / (exp(-(Vm+ 42) / 10) + 1);

    alpha_n =(-0.0001 * (Vm + 50)) / (exp(-(Vm + 50) / 10) - 1);
    beta_n = 0.002 * exp(-(Vm + 90) / 80);

     IK1 = (1.2 * exp(-(Vm + 90) / 50) + 0.015 * exp((Vm + 90) / 60)) * (Vm + 100);
    IK2 = 1.2 * n^4 * (Vm + 100);


    INa = (400 * m^3 * h + 0.14) * (Vm - 40);
    IK = IK1 + IK2;
    IL = 0.03 * (Vm+ 70);

   
    dVm =(- (INa + IK + IL) / Cm);
    dm = (alpha_m * (1 - m) - beta_m * m);
    dh = (alpha_h * (1 - h) - beta_h * h);
    dn = (alpha_n* (1 - n) - beta_n * n);
     
    dydt=[dVm;dm;dh;dn];

end
