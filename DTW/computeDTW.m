function [ x_out, r_out, D ] = computeDTW( x, r, p, distanceFunction, debug )
if(size(x,1) > 2 * size(r,1) || size(x,1)*2-1 < size(r,1))
    x_out = x;
    r_out = r;
    D = Inf;
    return
end

current_minimum = 1;
current_maximum = 3;
new_minimum = 1;

A = Inf * ones(size(r,1)+2, size(x,1));
B = zeros(size(r,1), size(x,1));
rozptyl = var(x,0,1);
A(3,1) = distanceFunction(x(1,p), r(1,p), rozptyl);
for i = 2:size(x,1)
    for j = current_minimum:current_maximum
%     for j = 1:size(r,1)
        if(A(j,i-1) < A(j+1,i-1))
            minimal = A(j,i-1);
            index = j - 2;
        else
            minimal = A(j+1,i-1);
            index = j - 1;
        end
        if(B(j, i - 1) ~= j)
            if(A(j+2,i-1) < minimal)
                minimal = A(j+2,i-1);
                index = j;
            end
        else
            new_minimum = current_minimum + 1;
        end
        d = distanceFunction(x(i,p), r(j,p), rozptyl);
        A(j+2, i) = d + minimal;
        if(minimal < Inf)
            B(j,i) = index;
        end
    end
    current_minimum = new_minimum;
    if(current_maximum + 2 <= size(r,1))
        current_maximum = current_maximum + 2;
    else
        current_maximum = size(r,1);
    end
end
w = zeros(size(x,1),1);
w(end) = size(r,1);
try
for i = size(x,1)-1:-1:1
    w(i) = B(w(i+1),i+1);
end
catch ME
    x_out = x;
    r_out = r;
    D = Inf;
    return;
%     disp(strcat(int2str(size(x,1)),':', int2str(size(r,1)), '-failed'))
%     rethrow(ME)
end
% disp(strcat(int2str(size(x,1)),':', int2str(size(r,1)), '-ok'))
if(debug)
    plot(w)
end
x_out = x(:,p);
r_out = r(w,p);
D = A(size(r,1)+2, size(x,1));
end