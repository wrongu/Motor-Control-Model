

function [corner0 corner1 corner2 corner3] = GetCorners(faceIndex,side,goal,B)

global FacesArray;

%Get the xyz coordinates of the goal
goalPt = FacesArray{goal}.point;

%get center of given face
center = FacesArray{faceIndex}.center;

%Get dimensions of cells
w = B(1).width;
l = B(1).length;
h = B(1).height;

cornerStruct = struct('pos',[NaN NaN NaN], 'g', NaN);
corner0 = cornerStruct;
corner1 = cornerStruct;
corner2 = cornerStruct;
corner3 = cornerStruct;

%Reduce the number of cases in the switch statement below since 
%calculations for faces in the same plane will be the same
if(mod(side,2)~=0)
    side = side + 1;
end

%Get corners based on side of cell and center of face
switch(side)
    %Left or Right face of cell
    case 2
        %Corner 0
        corner0.pos = [center(1) center(2)-(l/2) center(3)+(h/2)];
        corner0.g = euclidDist(corner0.pos,goalPt);
        %Corner 1
        corner1.pos = [center(1) center(2)+(l/2) center(3)+(h/2)];
        corner1.g = euclidDist(corner1.pos,goalPt);
        %Corner 2
        corner2.pos = [center(1) center(2)+(l/2) center(3)-(h/2)];
        corner2.g = euclidDist(corner2.pos,goalPt);
        %Corner 3
        corner3.pos = [center(1) center(2)-(l/2) center(3)-(h/2)];
        corner3.g = euclidDist(corner3.pos,goalPt);
    %Front or Back face of cell
    case 4
        %Corner 0
        corner0.pos = [center(1)+(w/2) center(2) center(3)+(h/2)];
        corner0.g = euclidDist(corner0.pos,goalPt);
        %Corner 1
        corner1.pos = [center(1)-(w/2) center(2) center(3)+(h/2)];
        corner1.g = euclidDist(corner1.pos,goalPt);
        %Corner 2
        corner2.pos = [center(1)-(w/2) center(2) center(3)-(h/2)];
        corner2.g = euclidDist(corner2.pos,goalPt);
        %Corner 3
        corner3.pos = [center(1)+(w/2) center(2) center(3)-(h/2)];
        corner3.g = euclidDist(corner3.pos,goalPt);
    %Top or Bottom face of cell
    case 6
        %Corner 0
        corner0.pos = [center(1)+(w/2) center(2)-(l/2) center(3)];
        corner0.g = euclidDist(corner0.pos,goalPt);
        %Corner 1
        corner1.pos = [center(1)-(w/2) center(2)-(l/2) center(3)];
        corner1.g = euclidDist(corner1.pos,goalPt);
        %Corner 2
        corner2.pos = [center(1)-(w/2) center(2)+(l/2) center(3)];
        corner2.g = euclidDist(corner2.pos,goalPt);
        %Corner 3
        corner3.pos = [center(1)+(w/2) center(2)+(l/2) center(3)];
        corner3.g = euclidDist(corner3.pos,goalPt);
    otherwise
        disp('Error: Value for side is invalid');
        return;
end