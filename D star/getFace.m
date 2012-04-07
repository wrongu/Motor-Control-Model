%Divya Gunasekaran
%April 27, 2011

%Inputs:
%B is the cell array of cubes
%index is the index into the cell array specifying a cube
%face is a string specifying left, right, front, back, top, or bottom 

function centerFace = getFace(B, index, face)

centerCube = B(index).center;
w = B(index).width;
l = B(index).length;
h = B(index).height;

switch(face)
    case 'left'
        x = centerCube(1) - (w/2);
        y = centerCube(2);
        z = centerCube(3);
        
    case 'right'
        x = centerCube(1) + (w/2);
        y = centerCube(2);
        z = centerCube(3);
        
    case 'front'
        x = centerCube(1);
        y = centerCube(2) + (l/2);
        z = centerCube(3);
        
    case 'back'
        x = centerCube(1);
        y = centerCube(2) - (l/2);
        z = centerCube(3);
        
    case 'top'
        x = centerCube(1);
        y = centerCube(2);
        z = centerCube(3) + (h/2);
        
    case 'bottom'
        x = centerCube(1);
        y = centerCube(2);
        z = centerCube(3) - (h/2);
        
    otherwise
        disp('Error: Specify a face');
        return;
end

centerFace = [x y z];
        
        