%Divya Gunasekaran
%April 22, 2011

%Get xyz coordinates of a given node

function coord = getCoord(nodeNum, B)

center = B(nodeNum).center;
w = B(nodeNum).width;
l = B(nodeNum).length;
h = B(nodeNum).height;

x = center(1) - (w/2);
y = center(2) - (l/2);
z = center(3) - (h/2);

coord = [x y z];