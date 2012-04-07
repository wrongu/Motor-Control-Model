%Daniel Muldrew
%October 22, 2010

%Stand-in function  for converting angles to (x,y,z) position for left and
%right arms

function [leftarmpos, rightarmpos] = ForwardKinematics(angles)

% there are 8 angles, RightShoulderRotator, RightShoulderPitch, RightElbow,
% RightWrist, LeftShoulderRotator, LeftShoulderPitch LeftElbow, LeftWrist,
% respectively

if (length(angles) == 8)
    leftarmpos(1) = dot(-3*rand(1,4),angles(1:4));
    leftarmpos(2) = dot(-3*rand(1,4),angles(1:4));
    leftarmpos(3) = dot(-3*rand(1,4),angles(1:4));

    rightarmpos(1) = dot(3*rand(1,4),angles(5:8));
    rightarmpos(2) = dot(3*rand(1,4),angles(5:8));
    rightarmpos(3) = dot(3*rand(1,4),angles(5:8));

end

end