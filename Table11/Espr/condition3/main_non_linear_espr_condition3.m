clc,clear;
dbstop if error
p = [8 10 13 19 25 16];   % Unit selling price
si = [0.3 0.1 0.2 0.3 0.3 0.2];   % Unit shortage cost of rEOL products
ci =  [1.3108 1.4713 2.7459 5.3452 6.7486 5.7705];  % The unit remanufacturing cost
vi = [0.6 0.7 1 1.9 2.7 1.6];   % Unit residual value of unsold rEOL products
ee = [650 700 800 1500 1800 1000];  % The coefficient of market demand
f = [100 105 120 130 85 150];   % The coefficient of market demand
Pt = [0.2 0.2 0.3 0.7 0.7 1];      % The coefficient of processing time
Ht = [0.9 0.9 0.8 0.5 0.5 0.5];      % The coefficient of processing time
ma = [0.0200 0.0227 0.0494 0.1462 0.1710 0.1873]; % The carbon emissions of a remanufactured product
lamubda = 4;  % The carbon trading price
N = 150;   % The carbon quota   
syms y z;
n = 6;
x = sym('x',[1 n]); %ramanufacturing quatities
z0=0;
for i = 1:length(p)
    g0 = matlabFunction(int((z-y)*normpdf(z,ee(i),f(i)),z,0,y));
    z1 = (p(i)+si(i)-vi(i))*g0(x(i))+(p(i)+si(i)-ci(i))*x(i)-si(i)*ee(i)+lamubda*N; % Profit of the product i
    z0 = z0+z1; % Profit of all products
end
z0 = -z0;
g5 = matlabFunction(z0,'vars',{x});
x0 = [0,0,0,0,0,0];
[x,fmin] = fmincon(g5,x0,[],[],[],[],[0,0,0,0,0,0],[inf,inf,inf,inf,inf,inf],'nonlcon0_1')
fmax=-fmin %Profit
mm = x(1)*ma(1)+x(2)*ma(2)+x(3)*ma(3)+x(4)*ma(4)+x(5)*ma(5)+x(6)*ma(6)  % Total carbon emissions