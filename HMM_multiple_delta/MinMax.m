function [ Mi, Mx ] = MinMax( states, frames, frame )
if(frame <= frames - states + 1)
    Mi = 1;
else
    diff = frame - (frames - states + 1);
    Mi = diff + 1;
end

if(frame >= states)
    Mx = states;
else
    Mx = frame;
end
end