clc,clear;
dbstop if error
p = [3.6 7.9 15 25];    % Unit selling price
si = [0.1 0.1 0.2 0.2];   % Unit shortage cost of rEOL products
ci = [2.4356 4.7039 11.7358 13.1871];  % The unit remanufacturing cost
vi = [0.4 0.8 1.6 2.4];   % Unit residual value of unsold rEOL products
ee = [1500 2000 1000 600];  % The coefficient of market demand
f = [245 360 161 108];   % The coefficient of market demand
Pt = [1 1 2.7 2.7];      % The coefficient of processing time
Ht = [1.25 1.25 3.3 3.3];      % The coefficient of processing time
ma = [0.0610 0.0897 0.1442 0.2299]; % The carbon emissions of a remanufactured product
lamubda = 4;  % The carbon trading price
N = 150;   % The carbon quota   
syms y z;
n = 4;
x = sym('x',[1 n]);% remanufacturing quantities
z0=0;
for i = 1:length(p)
    g0 = matlabFunction(int((z-y)*normpdf(z,ee(i),f(i)),z,0,y));
    z1 = (p(i)+si(i)-vi(i))*g0(x(i))+(p(i)+si(i)-ci(i))*x(i)-si(i)*ee(i)+lamubda*N; % Profit of the product i
    z0 = z0+z1; % Profit of all products
end
z0 = -z0;
g5 = matlabFunction(z0,'vars',{x});
x0 = [0,0,0,0];
[x,fmin] = fmincon(g5,x0,[],[],[],[],[0,0,0,0],[inf,inf,inf,inf],'nonlcon0_1')
fmax=-fmin %Profit
mm = x(1)*ma(1)+x(2)*ma(2)+x(3)*ma(3)+x(4)*ma(4) %Total carbon emissions