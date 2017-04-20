function [ D ] = computeDTWopt( x, r, p, distanceFunction )
if(size(x,1) > 2 * size(r,1) || size(x,1)*2-1 < size(r,1))
    D = Inf;
    return
end

A = Inf * ones(size(r,1)+2, size(x,1));
B = zeros(size(r,1), size(x,1));
rozptyl = 1 ./ var(x,0,1);
A(3,1) = distanceFunction(x(1,p), r(1,p), rozptyl);

for i = 2:size(x,1)
    [Mi, Mx] = MinMax(i, size(x,1), size(r,1));
    for j = Mi:Mx
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
        end
        d = distanceFunction(x(i,p), r(j,p), rozptyl);
        A(j+2, i) = d + minimal;
        if(minimal < Inf)
            B(j,i) = index;
        end
    end
end
D = A(size(r,1)+2, size(x,1));
end

function [Mi, Mx] = MinMax(i, testLength, refLength)
K = floor((i + 1) / 2);
K1 = refLength - (testLength - i) * 2;
if(K < K1)
    K = K1;
end
Mi = K;

K = 2 * i - 1;
K1 = refLength - floor((testLength - i) / 2);
if(K > K1)
    K = K1;
end
Mx = K;
end