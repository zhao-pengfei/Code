close all;clc;clear;
lamuta = linspace(0,6,7);
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
N = 210;   % The carbon quota
E199 = [];
b1 = [];
b10 = b+lamuta*k; 
b1 = [b1,b10];
b1 = [b1;b10];
syms t;
syms h;
f = 2*exp(-t*2); % The probability density function of processing time
g = 1/(sqrt(2*pi)*150)*exp(-(h-1000)^2/(2*150*150));  % The probability density function of market demand
a1 = [1.9;1.9];c1 = [-17.2;-2.6];
    for i = 1:length(b1)
        %step1 Calculate the range of the remanufacturing time threshold
        [x1,x2] = solve_equation(a1,b1(:,i),c1);
        %step2 Calculate the optimal remanufacturing time threshold by the false position method
        x01 = dichotomyf(x1,x2,a,f,b10(i),Cd,Cr,t);
        %step3 Calculate the remanufacturing rate
        F1 = gamcdf(x01,Pt,Ht);
        %step4 Calculate the carbon emissions of a remanufactured product
        ma1 = double(int(k*t*f,t,0,x01)/F1);
        %step5 Calculate the mean processing cost of a remanufactured product
        cu1 = double(int((a*t^2+b*t+c)*f,t,0,x01)/F1);
        %step6 Calculate the unit remanufacturing cost
        bvr1 = Cr/F1+cu1+(1-F1)/F1*Cd+lamuta(i)*ma1;
        %step7 Calculate the remanufacturing quantity
        m1 = (Cp+Cv-bvr1)/(Cp-Cn+Cv);
        B1 = norminv(m1,Ex,Dx);
        %step8 Calculate the acquisition quantity
        A1 = B1/F1;
        %step9 Calculate total carbon emissions
        m10 = B1*ma1;
        %step10 Calculate the profit
        E10 = (Cp-Cn+Cv)*int((h-B1)*g,h,0,B1)+(Cp+Cv-bvr1)*B1-Cv*Ex+lamuta(i)*N;
        E0 = double(E10);
        E199 = [E199,E0];
    end
plot(lamuta,E199,'s-'); 
xlabel('Carbon trading price');
ylabel('Profit ');





