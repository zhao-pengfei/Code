clc;clear;
m = zeros(1,4);ma = zeros(1,4);cu = zeros(1,4); F = zeros(1,4);t0 = zeros(1,4); B = zeros(1,4);
bvr = zeros(1,4);A = zeros(1,4);m1 = zeros(1,4);E1 = zeros(1,4);E = zeros(1,4);n = zeros(1,4);result = [];
Cr = [1.1 3.1 3.2 4];      % Testing cost of a EOL product
Cp = [3.6 7.9 15 25];     % Unit selling price
k = [0.08 0.08 0.022 0.033]; % Carbon emissions coefficient of machine tools
Cv = [0.1 0.1 0.2 0.2];  % Unit shortage cost of rEOL products
Cn = [0.4 0.8 1.6 2.4];     % Unit residual value of unsold rEOL products
Cd = [0.3 1.2 1.5 2.1];      % Unit treatment cost of dEOL products
a = 0;     % Average processing cost coefficient of a single remanufactured product
b = 1;     % Average processing cost coefficient of a single remanufactured product
c = 0;     % Average processing cost coefficient of a single remanufactured product
Pt = [1 1 2.7 2.7];      % The coefficient of processing time
Ht = [1.25 1.25 3.3 3.3];    % The coefficient of processing time
Ex = [1500 2000 1000 600];   % The coefficient of market demand
Dx = [245 360 161 108];    % The coefficient of market demand
N = 150;     % The carbon quota 
lambda = 4;   % The carbon trading price
b1 = zeros(2,1);
syms t h;
 for i = 1:length(Cr)
    b10 = b+lambda*k(i);
    b1(:,1) = b10;
    f(i) = 1/(Ht(i)^Pt(i)*gamma(Pt(i)))*t^(Pt(i)-1)*exp(-t/Ht(i)); % The probability density function of processing time
    %step1 Calculate the range of the remanufacturing time threshold
    x2(i) = Cp(i)+Cv(i)+Cd(i); 
    x1(i) = Cn(i)+Cd(i);
    %step2 Calculate the optimal remanufacturing time threshold by a dichotomy method
    t0(i) = dichotomyf(x1(i),x2(i),a,f(i),b10,Cd(i),Cr(i),t);
    %step3 Calculate the remanufacturing rate
    F(i) = gamcdf(t0(i),Pt(i),Ht(i));
    %step4 Calculate the carbon emissions of a remanufactured product
    ma(i) = double(int(k(i)*t*f(i),t,0,t0(i))/F(i));
    %step5 Calculate the mean processing cost of a remanufactured product
    cu(i) = double(int((a*t^2+b*t+c)*f(i),t,0,t0(i))/F(i));
    %step6 Calculate the unit remanufacturing cost
    bvr(i) = Cr(i)/F(i)+cu(i)+(1-F(i))/F(i)*Cd(i)+lambda*ma(i);
    %step7 Calculate the remanufacturing quantity
    m(i) = (Cp(i)+Cv(i)-bvr(i))/(Cp(i)-Cn(i)+Cv(i));
    B(i) = norminv(m(i),Ex(i),Dx(i));
    %step8 Calculate the acquisition quantity
    A(i) = B(i)/F(i);
    %step9 Calculate total carbon emissions
    m1(i) = B(i)*ma(i);
    %step10 Calculate the profit
    g(i) = 1/(sqrt(2*pi)*Dx(i))*exp(-(h-Ex(i))^2/(2*Dx(i)^2));
    n(i) = double((Cp(i)-Cn(i))*int((h-B(i))*g(i),h,0,B(i))+Cp(i)*B(i));
    E1(i) = (Cp(i)-Cn(i)+Cv(i))*int((h-B(i))*g(i),h,0,B(i))+(Cp(i)+Cv(i)-bvr(i))*B(i)-Cv(i)*Ex(i)+lambda*N; 
    E(i) = double(E1(i));
    result = [t0;bvr;B;m1;E;ma];
    save('result.mat','result')
 end