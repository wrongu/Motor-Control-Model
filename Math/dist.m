%Divya Gunasekaran
%Feb. 8, 2011

%Calculate Euclidean distance between two 3-d points

function d = dist(point1, point2)

d=0;
for i=1:length(point1)
    d = d + (point1(i)-point2(i))^2;
end

d= sqrt(d);