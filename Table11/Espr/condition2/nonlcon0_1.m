% Constraint conditions
function [c,ceq] = nonlcon0_1(x)
p = [8 10 13 19 25 16]; % Unit selling price
ci =  [1.3108 1.4713 2.7459 5.3452 6.7486 5.7705];  % The unit remanufacturing cost
vi = [0.6 0.7 1 1.9 2.7 1.6]; % Unit residual value of unsold rEOL products
e = [650 700 800 1500 1800 1000];    % The coefficient of market demand
f = [100 105 120 130 85 150];    % The coefficient of market demand
B = 18000;  % Budget
L = 300;   % Loss
con01 = 0;
con02 = 0;
syms y z;
for i = 1:length(p)
    con011 = ci(i)*x(i);
    con01 = con01+con011;
    g0 = matlabFunction(int((y-z)*normpdf(z,e(i),f(i)),z,0,y));
    con021 = (ci(i)-vi(i))*g0(x(i));
    con02 = con02+con021;
end
c(1) = con01-B;
c(2) = con02-L;
ceq=0;
end