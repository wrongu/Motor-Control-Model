%Divya Gunasekaran
%April 22, 2011
%Heuristic Function for D* Field algorithm

%Simple straight line distance heuristic

function dist = heuristic(node1, node2, B)

pos1 = getCoord(node1, B);
pos2 = getCoord(node2, B);

dist = euclidDist(pos1, pos2);