function [ x_out, r_out ] = computeLTW( x, r, p, debug )
ratio = ((size(r,1)-1) / (size(x,1)-1));
i = (0:length(x)-1);
w = floor((ratio .* i)+1.5);
r_out = r(w,p);
x_out = x(:,p);
if(debug)
    plot(w)
end
end