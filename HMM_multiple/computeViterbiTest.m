function [ p ] = computeViterbiTest(p, a, means, vars, states, params)
V = -Inf * ones(states + 1, size(p,1));
c1 = log(1./sqrt((2*pi)^length(params) * prod(vars(:,params),2)));
V(2,1) = computeB(c1(1), p(1,:),means(1,:), vars(1,:), params);

for i = 2:size(p,1)
    [Mi, Mx] = MinMax(states, size(p,1), i);
    for s = Mi:Mx
        temp = [V(s,i-1) + log(a(2,s)) V(s+1,i-1) + log(a(1,s))];
        max_value = max(temp);
        V(s+1,i) = computeB(c1(s), p(i,:),means(s,:), vars(s,:), params) + max_value;
    end
end

p = V(end, end);
end