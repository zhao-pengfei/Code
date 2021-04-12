clc,clear
ma = zeros(1,5);cu = zeros(1,5);F = zeros(1,5);t0 = zeros(1,5);bvr = zeros(1,5);result = [];
Cr = [0.7 0.8 1.5 2.5 3.6];      % Testing cost of a EOL product
Cp = [8 10 13 19 25];     % Unit selling price
k = 0.75;    % Carbon emissions coefficient of machine tools
Cv = [0.3 0.1 0.2 0.3 0.3];    % Unit shortage cost of rEOL products
Cn = [0.6 0.7 1 1.9 2.7];    % Unit residual value of unsold rEOL products
Cd = [0.4 0.5 0.6 1.5 2.2];  % Unit treatment cost of dEOL products
a = 1.9;     % Average processing cost coefficient of a single remanufactured product
b = 6.6;     % Average processing cost coefficient of a single remanufactured product
c = 0;       % Average processing cost coefficient of a single remanufactured product
Pt = [0.2 0.2 0.3 0.7 0.7];      % The coefficient of processing time
Ht = [0.9 0.9 0.8 0.5 0.5];      % The coefficient of processing time
Ex = [650 700 800 1500 1800];   % The coefficient of market demand
Dx = [100 105 120 130 85];    % The coefficient of market demand
N = 150;     % The carbon quota  
lamuta = 4;  % The carbon trading price
b1 = zeros(2,1);
b10 = b+lamuta*k;
b1(:,1) = b10;
c1 = [];
syms t h z;
for i = 1:length(Cr)
    f = ((t.^(Pt(i)-1)).*exp(-t/Ht(i)))/((Ht(i).^Pt(i))*gamma(Pt(i))); % The probability density function of processing time
    a1 = [1.9;1.9];
    c11 = c-Cd(i)-Cn(i);
    c12 = c-Cd(i)-Cp(i)-Cv(i);
    c1 = [c11;c12];
    % Calculate the range of the remanufacturing time threshold
    [x1,x2] = solve_equation(a1,b1,c1);
    % Calculate the optimal remanufacturing time threshold by a dichotomy method
    t0(i)= dichotomyf(x1,x2,a,f,b,Cd(i),Cr(i),t);
    % Calculate the remanufacturing rate
    F(i) = gamcdf(t0(i),Pt(i),Ht(i));
    % Calculate the carbon emissions of a remanufactured product
    ma(i) = double(int(k*t*f,t,0,t0(i))/F(i));
    % Calculate the mean processing cost of a remanufactured product
    cu(i) = double(int((a*t^2+b*t+c)*f,t,0,t0(i))/F(i));
    % Calculate the unit remanufacturing cost
    bvr(i) = Cr(i)/F(i)+cu(i)+(1-F(i))/F(i)*Cd(i)+lamuta*ma(i);
end
result = [t0;bvr;ma];
save('result123.mat','result')
