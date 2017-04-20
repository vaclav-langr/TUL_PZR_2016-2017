function [ bounds, p ] = computeViterbi(p, a, means, vars, states, params)
V = -Inf * ones(states + 1, size(p,1));
B = -1 * ones(states, size(p,1));

V(2,1) = computeB(p(1,:),means(1,:), vars(1,:), params);
B(1,1) = 1;

for i = 2:size(p,1)
    for s = 1:states
        temp = [V(s,i-1)*a(2,s) V(s+1,i-1)*a(1,s)];
        [max_value, index] = max(temp);
        if(index == 1)
            if(max_value > -Inf)
                B(s,i) = s - 1;
            end
        else
            if(max_value > -Inf)
                B(s,i) = s;
            end
        end
        V(s+1,i) = computeB(p(i,:),means(s,:), vars(s,:), params) * max_value;
    end
end

f = zeros(1,size(p,1));
f(1,size(p,1)) = states;

for i = size(p,1)-1:-1:1
    f(i) = B(f(i+1),i+1);
end

bounds = zeros(1,states + 1);
bounds(states + 1) = size(p,1);
for i = 2:states
    bounds(i) = find(f==i-1,1,'last');
end

p = V(end, end);
end

function [b] = computeB(frame, means, vars, params)
c1 = 1/sqrt((2*pi) * vars(:,params));
c2 = exp(-(frame-means(:,params))^2/(2*vars(:,params)));
b = c1 * c2;
end