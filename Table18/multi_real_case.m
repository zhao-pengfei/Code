clc,clear
ma = zeros(1,3);cu = zeros(1,3);F = zeros(1,3);t0 = zeros(1,3);bvr = zeros(1,3);result = [];
A = zeros(1,3);m1 = zeros(1,3);E1 = zeros(1,3);E = zeros(1,3);n = zeros(1,3);B = zeros(1,3);m = zeros(1,3);
Cr = [1.05 2.14 0.09];      % Testing cost of a EOL product
Cp = [33 53 2.1];     % Unit selling price
k = [3.56 3.8 2.97];    % Carbon emissions coefficient of machine tools
Cv = [0.92 2.01 0.07];    % Unit shortage cost of rEOL products
Cn = [1.5 2.9 0.45];    % Unit residual value of unsold rEOL products
Cd = [1.31 2.29 0.11];  % Unit treatment cost of dEOL products
a = [0.6 0.5 0.03];     % Average processing cost coefficient of a single remanufactured product
b = [0.1 0.2 0.01];     % Average processing cost coefficient of a single remanufactured product
c = [0.03 0.9 0];       % Average processing cost coefficient of a single remanufactured product
Pt = [0 0 0];      % The coefficient of processing time
Ht = [3.5 4 0.3];      % The coefficient of processing time
Ex = [2600 2600 2600];   % The coefficient of market demand
Dx = [70 90 102];    % The coefficient of market demand
N = 160;     % The carbon quota  
lambda = 3;  % The carbon trading price
b1 = zeros(2,1);
c1 = [];
syms t h z;
for i = 1:length(Cr)
    f = 1/(Ht(i)-Pt(i)); % The probability density function of processing time
    b10(i) = b(i)+lambda*k(i);
    b1(:,1) = b10(i);
    a1 = [a(i);a(i)];
    c11 = c(i)-Cd(i)-Cn(i);
    c12 = c(i)-Cd(i)-Cp(i)-Cv(i);
    c1= [c11;c12];
    % Calculate the range of the remanufacturing time threshold
    [x1,x2] = solve_equation(a1,b1,c1);
    % Calculate the optimal remanufacturing time threshold by a dichotomy method
    t0(i) = dichotomyf(x1,x2,a(i),f,b10(i),Cd(i),Cr(i),t);
    %step3 Calculate the remanufacturing rate
    F(i) = unifcdf(t0(i),Pt(i),Ht(i));
    %step4 Calculate the carbon emissions of a remanufactured product
    ma(i) = double(int(k(i)*t*f,t,0,t0(i))/F(i));
    %step5 Calculate the mean processing cost of a remanufactured product
    cu(i) = double(int((a(i)*t^2+b(i)*t+c(i))*f,t,0,t0(i))/F(i));
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
 
