    Cr = 2;      % Testing cost of a EOL product   
    Cp = 16;     % Unit selling price
    k = 0.75;    % Carbon emissions coefficient of machine tools
    Cv = 0.2;    % Unit shortage cost of rEOL products
    Cn = 1.6;    % Unit residual value of unsold rEOL products
    Cd = 1;      % Unit treatment cost of dEOL products
    a = 1.9;     % Average processing cost coefficient of a single remanufactured product
    b = 6.6;     % Average processing cost coefficient of a single remanufactured product
    c = 0;       % Average processing cost coefficient of a single remanufactured product
    Pt = 1;      % The coefficient of processing time
    Ht = 1/2;    % The coefficient of processing time
    Ex = 1000;   % The coefficient of market demand
    Dx = 150;    % The coefficient of market demand
    b1 = [];
    result2 =  zeros(13,41);
    x = 0:10:400;    % The carbon quota 
    y = 0:0.5:6;     % The carbon trading price
    b10=b+y*k;
    b1 = [b1,b10];
    b1 = [b1;b10];
    syms t;
    syms h;
    f = 2*exp(-2*t);   % The probability density function of processing time
    a1 = [1.9;1.9];c1 = [-17.2;-2.6];
 for i = 1:length(y)
    %step1 Calculate the range of the remanufacturing time threshold 
    [x1,x2] = solve_equation(a1,b1(:,i),c1);
    %step2 Calculate the optimal remanufacturing time threshold by a dichotomy method
    x0 = dichotomyf(x1,x2,a,f,b,Cd,Cr,t);
    %step3 Calculate the remanufacturing rate
    F = gamcdf(x0,Pt,Ht);
    %step4 Calculate the carbon emissions of a remanufactured product
    ma = double(int(k*t*f,t,0,x0)/F);
    %step5 Calculate the mean processing cost of a remanufactured product
    cu = double(int((a*t^2+b*t+c)*f,t,0,x0)/F);
    %step6 Calculate the unit remanufacturing cost
    bvr = Cr/F+cu+(1-F)/F*Cd+y(i)*ma;
    %step7 Calculate the remanufacturing quantity
    m = (Cp+Cv-bvr)/(Cp-Cn+Cv);
    B = norminv(m,Ex,Dx);
    %step8 Calculate the acquisition quantity
    A = B/F;
    %step9 Calculate total carbon emissions
    m1 = B*ma;
    %step10 Calculate the profit
    g = 1/(sqrt(2*pi)*150)*exp(-(h-1000)^2/(2*150*150));
    for j = 1:length(x)
        E1 = (Cp-Cn+Cv)*int((h-B)*g,h,0,B)+(Cp+Cv-bvr)*B-Cv*Ex+y(i)*x(j);
        E = double(E1); 
        result2(i,j) = E;
    end
 end
surf(x,y,result2);
shading interp; 
x1 = xlabel('Carbon quota ');
x2 = ylabel('Carbon trading price ');
zlabel('Profit');
title('TSPR model');   
set(x1,'Rotation',10);    
set(x2,'Rotation',-25);    

