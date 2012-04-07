%c1 = struct('pos',[x y z], 'g', int);
%t,u = face coordinates with orginate at corner1

function xyz = GetXYZ(c1,t,u,side)

pos = c1.pos;

%Reduce the number of cases in the switch statement below since 
%calculations for faces in the same plane will be the same
if(mod(side,2)~=0)
    side = side + 1;
end

switch(side)
    %Left or Right face of cell
    case 2
        x = pos(1);
        y = pos(2) - t;
        z = pos(3) - u;
        xyz = [x y z];
    %Front or Back face of cell
    case 4
        x = pos(1) + t;
        y = pos(2);
        z = pos(3) - u;
        xyz = [x y z];
    %Top or Bottom face
    case 6
        x = pos(1) + t;
        y = pos(2) + u;
        z = pos(3);
        xyz = [x y z];
    otherwise
        disp('Error: Given value for side is invalid');
        return;
end