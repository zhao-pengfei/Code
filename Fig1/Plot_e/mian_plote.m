close all;
clc;
clear;
lambda = linspace(0,20,21); % The carbon trading price
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
N = 150;     % The carbon quota
E99 = [];
E199 = [];
b1 = [];
b10 = b+lambda*k;
b1 = [b1,b10];
b1 = [b1;b10];
syms t;
syms h;
f = 2*exp(-2*t); % The probability density function of processing time
g = 1/(sqrt(2*pi)*150)*exp(-(h-1000)^2/(2*150*150)); % The probability density function of market demand
a1 = [1.9;1.9];c1 = [-17.2;-2.6];
for i = 1:length(b1)
    [x1,x2] = solve_equation(a1,b1(:,i),c1); % Calculate the range of the remanufacturing time threshold
    % Calculate the optimal remanufacturing time threshold by a dichotomy method for the TSPR model
    x0 = dichotomyf(x1,x2,a,f,b,Cd,Cr,t);
    % Calculate the remanufacturing rate for the TSPR model
    F = gamcdf(x0,Pt,Ht);
    % Calculate the carbon emissions of a remanufactured product for the TSPR model
    ma = double(int(k*t*f,t,0,x0)/F);
    % Calculate the mean processing cost of a remanufactured product for the TSPR model
    cu = double(int((a*t^2+b*t+c)*f,t,0,x0)/F);
    % Calculate the unit remanufacturing cost for the TSPR model
    bvr = Cr/F+cu+(1-F)/F*Cd+lambda(i)*ma;
    % Calculate the remanufacturing quantity for the TSPR model
    m2 = (Cp+Cv-bvr)/(Cp-Cn+Cv);
    B = norminv(m2,Ex,Dx);  
    % Calculate the remanufacturing quantity for the TSPR model
    A = B/F;
    % Calculate total carbon emissions for the TSPR model
    m20=B*ma;
    % Calculate the profit for the TSPR model
    E1 = (Cp-Cn+Cv)*int((h-B)*g,h,0,B)+(Cp+Cv-bvr)*B-Cv*Ex+lambda(i)*N; 
    E = double(E1);
    E99 = [E99,E];
    % Calculate the optimal remanufacturing time threshold by a dichotomy method for the ESPR model 
    x01 = dichotomyf(x1,x2,a,f,b10(i),Cd,Cr,t);
    % Calculate the remanufacturing rate for the ESPR model
    F1 = gamcdf(x01,Pt,Ht);
    % Calculate the carbon emissions of a remanufactured product for the ESPR model
    ma1 = double(int(k*t*f,t,0,x01)/F1);
    % Calculate the mean processing cost of a remanufactured product for the ESPR model
    cu1 = double(int((a*t^2+b*t+c)*f,t,0,x01)/F1);
    % Calculate the unit remanufacturing cost for the ESPR model
    bvr1 = Cr/F1+cu1+(1-F1)/F1*Cd+lambda(i)*ma1;
    % Calculate the remanufacturing quantity for the ESPR model
    m1 = (Cp+Cv-bvr1)/(Cp-Cn+Cv);
    B1 = norminv(m1,Ex,Dx);
    % Calculate the remanufacturing quantity for the ESPR model
    A1 = B1/F1;
    % Calculate total carbon emissions for the TSPR model
    m10 = B1*ma1;
    % Calculate the profit for the ESPR model
    E10 = (Cp-Cn+Cv)*int((h-B1)*g,h,0,B1)+(Cp+Cv-bvr1)*B1-Cv*Ex+lambda(i)*N;
    E0 = double(E10);
    E199 = [E199,E0];
end
plot(lambda,E99,'kp-',lambda,E199,'ks-'); 
xlabel('\lambda');
ylabel('Profit');
axis([0 20 8000 11000]);
legend('TSPR model','ESPR model');





