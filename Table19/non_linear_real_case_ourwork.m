clc,clear;
dbstop if error
p = [33 53 2.1];    % Unit selling price
si = [0.92 2.01 0.07];   % Unit shortage cost of rEOL products
ci = [12.3584 19.3716 0.9247];  % The unit remanufacturing cost
vi = [1.5 2.9 0.45];   % Unit residual value of unsold rEOL products
ee = [2600 2600 2600];  % The coefficient of market demand
f = [70 90 102];   % The coefficient of market demand
Pt = [0 0 0];      % The coefficient of processing time
Ht = [3.5 4 0.3];      % The coefficient of processing time
ma = [2.1124 3.1723 0.1722]; % The carbon emissions of a remanufactured product
lamubda = 3;  % The carbon trading price
N = 160;   % The carbon quota   
syms y z;
n = 3;
x = sym('x',[1 n]); %ramanufacturing quatities
z0=0;
for i = 1:length(p)
    g0 = matlabFunction(int((z-y)*normpdf(z,ee(i),f(i)),z,0,y));
    z1 = (p(i)+si(i)-vi(i))*g0(x(i))+(p(i)+si(i)-ci(i))*x(i)-si(i)*ee(i)+lamubda*N; % Profit of the product i
    z0 = z0+z1; % Profit of all products
end
z0 = -z0;
g5 = matlabFunction(z0,'vars',{x});
x0 = [0,0,0];
[x,fmin] = fmincon(g5,x0,[],[],[],[],[0,0,0],[inf,inf,inf],'nonlcon0_1')
fmax=-fmin % Profit
mm = x(1)*ma(1)+x(2)*ma(2)+x(3)*ma(3) % Total carbon emissions