function [b] = computeB(c1, frame, means, vars, params)
temp = vars(:,params)' .\ (frame - means(:,params))';
c2 = (-1/2)*(frame - means(:,params))*temp;
b = c1 + c2;
end

