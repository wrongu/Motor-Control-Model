%Divya Gunasekaran
%May 6, 2011

function [k1,k2] = A_CalculateKey(B,cellIndex,start)


k2 = min(B(cellIndex).g,B(cellIndex).rhs);

k1 = k2 + euclidDist(B(cellIndex).center,B(start).center);