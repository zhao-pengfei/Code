% Constraint conditions
function [c,ceq] = nonlcon0_1(x)
p = [33 53 2.1]; % Unit selling price
ci = [12.3584 19.3716 0.9247];  % The unit remanufacturing cost
vi = [1.5 2.9 0.45]; % Unit residual value of unsold rEOL products
e = [2600 2600 2600];    % The coefficient of market demand
f = [70 90 102];    % The coefficient of market demand
B = 81000;  % Budget
L = 1200;   % Loss
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