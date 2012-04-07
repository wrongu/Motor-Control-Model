%Divya Gunasekaran
%May 6, 2011

function side = GetFaceSide(B,n,faceIndex)

global FacesArray;

point = FacesArray{faceIndex}.center;

%Get dimensions of cells
w = B(1).width;
l = B(1).length;
h = B(1).height;

%Find cell that the given face belongs to
[i j k] = findCell(point, n, w, l, h);

%Find which face of the cell the point is on
cellFaces = B(i,j,k).faces;
sideIndex = find(cellFaces==faceIndex);

side = sideIndex(1);