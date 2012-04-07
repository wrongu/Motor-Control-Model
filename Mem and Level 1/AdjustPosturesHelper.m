%Divya Gunasekaran
%March 10, 2011

%Helper function for AdjustPostures function

function [currXYZ, sqDist] = AdjustPosturesHelper(currPosture, targetXYZ, side)
    
%Create vector of 11 angles based on the side of the robot
if(strcmp(side, 'right'))
    currAngles = [currPosture 0 0 0 0];
elseif(strcmp(side, 'left'))
    currAngles = [currPosture(1) currPosture(2) currPosture(3) 0 0 0 0 currPosture(4) currPosture(5) currPosture(6) currPosture(7)];
else
    disp('Error: Invalid side');
    return
end

%Get XYZ coordinates of the posture
currXYZ = ForwardKinematics_V5(currAngles);

%Squared distance between current position and target position
sqDist = (dist(currXYZ, targetXYZ))^2;