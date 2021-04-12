% The solution of binary first order inequality
% a1, b1, and c1 represent the coefficient of the first term, the coefficient of the second term and constant term of quadratic equation with one variable, respectively
% x1 is the smaller root, x2 is the larger root.
function [x1,x2] = solve_equation(a1,b11,c1)
delt_array = b11.^2-4.*a1.*c1;
num = size(delt_array,1);
x10 = cell(num,1);x20 = cell(num,1);
for i = 1:num
    if delt_array(i)<0
        x10{i} = [];x20{i}=[];
    elseif delt_array==0
        x10{i} = -b11(i)/(2*a1(i));x20{i} = x10{i};
    else
        x10{i} = (-b11(i)-sqrt(delt_array(i)))/(2*a1(i));
        x20{i} = (-b11(i)+sqrt(delt_array(i)))/(2*a1(i));
    end
end
x2_mat = cell2mat(x20);
x2_mat = sort(x2_mat.');
x1 = x2_mat(1);x2 = x2_mat(2);
end


