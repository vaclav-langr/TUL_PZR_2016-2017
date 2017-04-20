function [ d ] = computeEuclidDist( x, r, rozptyl )
diff = (x - r);
suma = sum(diff.*diff,2);
d = sqrt(suma);
end