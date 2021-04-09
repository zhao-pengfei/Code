% a dichotomy method
function [x0] = dichotomyf(x1,x2,a,f,b00,Cd,Cr,t)
y = @(x)double(int(((a*x^2+b00*x)-(a*t^2+b00*t))*f,t,0,x)-Cd-Cr);
err = 0.00001;
yc = 1;
while((x2-x1)>err)&&(yc~=0);
    c = (x2+x1)/2;
    ya = y(x1);yb = y(x2);yc = y(c);
    if ya*yc<0
        x2 = c;
    else
        x1 = c;
    end
    x0 = c;
end
end