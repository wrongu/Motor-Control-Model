%Daniel Muldrew
%October 22, 2010

%Function  for converting angles to (x,y,z) position for left and
%right arms

%angles is currently a vector of length 4
%unit is radians
%angles(1) = RightShoulderRotator
%angles(2) = RightShoulderPitch
%angles(3) = RightElbow
%angles(4) = RightWrist
%jointPosition is a cell array that gives the position of each joint


function [point, jointPosition] = ForwardKinematics(angles)

state = AugmentedMat(eye(3), zeros(1,3));
jointPosition{1} = state;

state = AffineTransform(-angles(7),state(1:3,2),[0 0 0]) * state;
jointPosition{2} = state; %right wrist

state = AffineTransform(-angles(6),state(1:3,3),[0 7.75 0]) * state;
jointPosition{3} = state; %right elbow

state = AffineTransform(-angles(5),state(1:3,3),[0 4.125 0]) * state;
jointPosition{4} = state; %right shoulder pitch

state = AffineTransform(-angles(4),state(1:3,2),[-.5 1 0]) * state;
jointPosition{5} = state; %right shoulder rotator

% state = AffineTransform(0,[0 0 1],[0 (-4.625/2) 0]) * state;
% jointPosition{6} = state; %right shoulder rotator

torsoangle = (angles(2)-angles(3))/2;
state = AffineTransform(torsoangle,state(1:3,2),[0 4.625/2 -4.3]) * state;
jointPosition{7} = state; %torso bend

state = AffineTransform(angles(1),state(1:3,3),[0 0 -2.75]) * state;
jointPosition{8} = state; %torso yaw

point = state(1:3,4);

end

