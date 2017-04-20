function [ d ] = computeMahalDist( x, r, rozptyl )
diff = x - r;
diff = diff.*diff.*rozptyl;
d = sqrt(sum(diff,2));
end