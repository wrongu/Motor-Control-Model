%Divya Gunasekaran
%May 5, 2011

function [faceIndex,side] = GetFaceIndex(B,n,point)

global FacesArray;

%Get dimensions of cells
w = B(1).width;
l = B(1).length;
h = B(1).height;

%Find cell that the given point belongs to
[i j k] = findCell(point, n, w, l, h);

%Find which face of the cell the point is on
cellCenter = B(i,j,k).center;
cellFaces = B(i,j,k).faces;

%Determine which side of the cell the point is on
%Not left or right face face
if((cellCenter(1)-(w/2))<point(1) && point(1)<(cellCenter(1)+(w/2)))
    %Not front or back face
    if((cellCenter(2)-(l/2))<point(2) && point(2)<(cellCenter(2)+(l/2)))
        %Side is top face
        if(cellCenter(3) < point(3))
            side = 5;
        %Else side is bottom face
        else
            side = 6;
        end
    %Else is front or back
    %Is front
    elseif(cellCenter(2) < point(2))
        side = 3;
    %Is back
    else
        side = 4;
    end
%Else is left or right face
%Is right
elseif(cellCenter(1) < point(1))
    side = 2;
%Is left
else 
    side = 1;
end
                    
                                  
faceIndex = cellFaces(side);
faceCenter = FacesArray{faceIndex}

