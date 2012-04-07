%Divya Gunasekaran
%May 6, 2011

function [k1,k2] = CalculateKey(faceIndex,start)

global FacesArray;

k2 = min(FacesArray{faceIndex}.g,FacesArray{faceIndex}.rhs);

if(numel(FacesArray{faceIndex}.point))
    point = FacesArray{faceIndex}.point;
else
    point = FacesArray{faceIndex}.center;
end
k1 = k2 + euclidDist(FacesArray{start}.point,point);