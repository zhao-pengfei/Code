close all;
clc;
clear;
lambda = linspace(0,20,21);  % The carbon trading price
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
x99 = [];
x199 = [];
b1 = [];
b10 = b+lambda*k;
b1 = [b1,b10];
b1 = [b1;b10];
syms t;
syms h;
f = 2*exp(-2*t); % The probability density function of processing time
a1 = [1.9;1.9];c1 = [-17.2;-2.6];
for i = 1:length(lambda)
    [x1,x2]=solve_equation(a1,b1( :,i),c1);   % Calculate the range of the remanufacturing time threshold
    x0 = dichotomyf(x1,x2,a,f,b,Cd,Cr,t);    % Calculate the optimal remanufacturing time threshold by a dichotomy method for the TSPR model
    x99 = [x99,x0]; 
    x01 = dichotomyf(x1,x2,a,f,b10(i),Cd,Cr,t); % Calculate the optimal remanufacturing time threshold by a dichotomy method for the ESPR model
    x199 = [x199,x01];
end
plot(lambda,x99,'kp-',lambda,x199,'ks-'); 
xlabel('\lambda');
ylabel('Remanufacturing time threshold');
axis([0 20 0.4 0.8]);
legend('TSPR model','ESPR model');


 

