%Divya Gunasekaran
%One step of gradient descent
%April 17, 2011

%currAngles is a vector of 7 joint angles
%targetXYZ is a row vector

function newAngles = gradDescent(currAngles, targetXYZ, stepSize, side)


currXYZ = GetPosturePosition(currAngles, side); 
% 
% deltaXYZ = stepSize*(targetXYZ - currXYZ);
% 
% J = computeJacobian(currAngles, side)
% Jinv = pinv(J);
% newAngles = currAngles' + (Jinv*deltaXYZ');
% 
% newAngles = newAngles';

deltaXYZ = stepSize*(targetXYZ - currXYZ);

% distXYZ = euclidDist(targetXYZ,currXYZ);

% potentialXYZ = 1/distXYZ^3;

J = computeJacobian(currAngles,side);

%NOTE: Need to add a "potential field" opposing change in torso yaw and
%pitch
%Currently, these joint angles are kept constant
J(1,1) = 0;
J(2,1) = 0;
J(3,1) = 0;

Jinv = pinv(J);

newAngles = currAngles' + (Jinv*deltaXYZ');

newAngles = newAngles';
