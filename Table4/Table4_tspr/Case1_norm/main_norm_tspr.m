result = [];
Cr = 2;      % Testing cost of a EOL product
Cp = 16;     % Unit selling price
k = 0.75;    % Carbon emissions coefficient of machine tools
Cv = 0.2;    % Unit shortage cost of rEOL products
Cn = 1.6;    % Unit residual value of unsold rEOL products
Cd = 1;      % Unit treatment cost of dEOL products
a = 1.9;     % Average processing cost coefficient of a single remanufactured product
b = 6.6;     % Average processing cost coefficient of a single remanufactured product
c = 0;       % Average proc essing cost coefficient of a single remanufactured product
Pt = 0;      % The coefficient of processing time
Ht = 1;      % The coefficient of processing time
Ex = 1000;   % The coefficient of market demand
Dx = 1;      % The coefficient of market demand
N = 150;     % The carbon quota 
lamuta = 4;  % The carbon trading price
b1 = zeros(2,1);
b10=b+lamuta*k;
b1(:,1) = b10;
syms t;
syms h;
f = 1/(sqrt(2*pi))*exp(-t^2/2); % The probability density function of processing time
%step1 Calculate the range of the remanufacturing time threshold
a1 = [1.9;1.9];c1=[-17.2;-2.6];
[x1,x2] = solve_equation(a1,b1,c1);
%step2 Calculate the optimal remanufacturing time threshold by a dichotomy method
t0 = dichotomyf(x1,x2,a,f,b,Cd,Cr,t);
%step3 Calculate the remanufacturing rate
F = normcdf(t0,Pt,Ht);  
%step4 Calculate the carbon emissions of a remanufactured product
ma = double(int(k*t*f,t,0,t0)/F);
%step5 Calculate the mean processing cost of a remanufactured product
cu = double(int((a*t^2+b*t+c)*f,t,0,t0)/F);
%step6 Calculate the unit remanufacturing cost
bvr = Cr/F+cu+(1-F)/F*Cd+lamuta*ma;
%step7 Calculate the remanufacturing quantity
m = (Cp+Cv-bvr)/(Cp-Cn+Cv);
B = gaminv(m,Ex,Dx);
%step8 Calculate the acquisition quantity
A = B/F; 
%step9 Calculate total carbon emissions
m1 = B*ma;
%step10 Calculate the profit
g = 1/(sqrt(2*pi)*150)*exp(-(h-1000)^2/(2*150*150));
E1 = (Cp-Cn+Cv)*int((h-B)*g,h,0,B)+(Cp+Cv-bvr)*B-Cv*Ex+lamuta*N; 
E = double(E1);
result = [t0;A;B;E;m1];
save('result.mat','result')