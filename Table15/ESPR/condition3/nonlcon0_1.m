% Constraint conditions
function [c,ceq] = nonlcon0_1(x)
p = [3.6 7.9 15 25]; % Unit selling price
ci = [2.4356 4.7039 11.7358 13.1871];  % The unit remanufacturing cost
vi = [0.4 0.8 1.6 2.4]; % Unit residual value of unsold rEOL products
e = [1500 2000 1000 600];    % The coefficient of market demand
f = [245 360 161 108];    % The coefficient of market demand
B = 33000;  % Budget
L = 1500;   % Loss
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