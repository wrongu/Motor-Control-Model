% %Daniel Muldrew
% %March 10, 2011
% 
% %Function  for converting angles to (x,y,z) position for left and
% %right arms
% 
% %angles is currently a vector of length 11
% %unit is radians
% %angles(1) = TorsoYaw
% %angles(2) = TorsoPitchOne
% %angles(3) = TorsoPitchTwo
% %angles(4) = RightShoulderRotator
% %angles(5) = RightShoulderPitch
% %angles(6) = RightElbow
% %angles(7) = RightWrist
% %angles(8) = LeftShoulderRotator
% %angles(9) = LeftShoulderPitch
% %angles(10) = LeftElbow
% %angles(11) = LeftWrist
% %jointPosition is a cell array that gives the position of each joint
% 
% %Some angles are negated in the affine transformation. this is because we
% %want the angles in terms of counterclockwise rotations about an axis, but
% %some are given as clockwise due to servo arrangements
% 
% function [rightPoint, leftPoint, jointPosition] = ForwardKinematics_Grad(anglesArray)
% 
% for i=1:numel(anglesArray{1})
%     
%     for j=1:length(anglesArray)
%         
%         angles(j) = anglesArray{j}(i);
%         
%     end
%         
%     Rstate = AugmentedMat(eye(3), zeros(1,3));
%     Lstate = AugmentedMat(eye(3), zeros(1,3));
% 
%     %rightWrist around Y (negate for CW to CCW) (normally -angles(7))
%     Rstate = AffineTransform(-angles(7),[0 1 0]',[0 -7.75 0]) * Rstate;
%     Lstate = AffineTransform(angles(11),[0 1 0]',[0 7.75 0]) * Lstate;
%     jointPosition(:,:,1) = Rstate;
% 
%     %both Elbows around Z (negate for CW to CCW)
%     Rstate = AffineTransform(-angles(6),[0 0 1]',[0 -4.125 0]) * Rstate;
%     Lstate = AffineTransform(-angles(10),[0 0 1]',[0 4.125 0]) * Lstate;
%     jointPosition(:,:,2) = Rstate;
% 
%     %both ShoulderPitches around Z (negate for CW to CCW)
%     Rstate = AffineTransform(-angles(5),[0 0 1]',[.5 -1 0]) * Rstate;
%     Lstate = AffineTransform(-angles(9),[0 0 1]',[.5 1 0]) * Lstate;
%     jointPosition(:,:,3) = Rstate;
% 
% 
%     %RightShoulderRotator around Y, negative.
%     Rstate = AffineTransform(-angles(4),[0 1 0]',[0 -4.625/2 4.3]) * Rstate;
%     Lstate = AffineTransform(angles(8),[0 1 0]',[0 4.625/2 4.3]) * Lstate;
%     jointPosition(:,:,4) = Rstate;
% 
% 
%     torsoangle = (angles(2)-angles(3))/2;
%     %average of 2 torsoPitch servos. addition is negative because servos mirror
%     %each other. servo at angles(2) is in correct orientation.
%     %Rotation around Y, direction handled in averaging.
%     Rstate = AffineTransform(torsoangle,[0 1 0]',[0 0 2.75]) * Rstate;
%     Lstate = AffineTransform(torsoangle,[0 1 0]',[0 0 2.75]) * Lstate;
%     jointPosition(:,:,5) = Rstate;
% 
% 
%     %torso yaw only orients axes, no translation.
%     %finally, one where servo angles are in the same orientation as the axis..
%     %   no negation of angles.
%     Rstate = AffineTransform(angles(1),[0 0 1]',[0 0 0]) * Rstate;
%     Lstate = AffineTransform(angles(1),[0 0 1]',[0 0 0]) * Lstate;
%     jointPosition(:,:,6) = Rstate;
% 
% 
%     rightPoint = Rstate(1:3,4);
%     leftPoint = Lstate(1:3,4);
% 
% end
% 
%Daniel Muldrew
%October 22, 2010

%Function  for converting angles to (x,y,z) position for left and
%right arms

%angles is currently a vector of length 11
%unit is radians
%angles(1) = TorsoYaw
%angles(2) = TorsoPitchOne
%angles(3) = TorsoPitchTwo
%angles(4) = RightShoulderRotator
%angles(5) = RightShoulderPitch
%angles(6) = RightElbow
%angles(7) = RightWrist
%angles(8) = LeftShoulderRotator
%angles(9) = LeftShoulderPitch
%angles(10) = LeftElbow
%angles(11) = LeftWrist
%jointPosition is a cell array that gives the position of each joint

%Some angles are negated in the affine transformation. this is because we
%want the angles in terms of counterclockwise rotations about an axis, but
%some are given as clockwise due to servo arrangements

function [rightPoint, leftPoint, rightJts, leftJts] = ForwardKinematics_Shoulder(angles)

Rstate = AugmentedMat(eye(3), zeros(1,3));
Lstate = AugmentedMat(eye(3), zeros(1,3));
i=1; 


%both ShoulderPitches around Z (negate for CW to CCW)
Rstate = AffineTransform(-angles(5),[0 0 1]',[.5 -1 0]) * Rstate;
Lstate = AffineTransform(-angles(9),[0 0 1]',[.5 1 0]) * Lstate;
rightJts(:,i) = Rstate(1:3,4);
leftJts(:,i) = Lstate(1:3,4);
i = i+1;

%RightShoulderRotator around Y, negative.
Rstate = AffineTransform(-angles(4),[0 1 0]',[0 -4.625/2 4.3]) * Rstate;
Lstate = AffineTransform(angles(8),[0 1 0]',[0 4.625/2 4.3]) * Lstate;
rightJts(:,i) = Rstate(1:3,4);
leftJts(:,i) = Lstate(1:3,4);
i=i+1;

%torso yaw only orients axes, no translation.
%finally, one where servo angles are in the same orientation as the axis..
%   no negation of angles.
Rstate = AffineTransform(angles(1),[0 0 1]',[0 0 0]) * Rstate;
Lstate = AffineTransform(angles(1),[0 0 1]',[0 0 0]) * Lstate;
rightJts(:,i) = Rstate(1:3,4);
leftJts(:,i) = Lstate(1:3,4);
i = i+1;

torsoangle = (angles(2)-angles(3))/2;
%average of 2 torsoPitch servos. addition is negative because servos mirror
%each other. servo at angles(2) is in correct orientation.
%Rotation around Y, direction handled in averaging.
Rstate = AffineTransform(torsoangle,[0 1 0]',[0 0 2.75]) * Rstate;
Lstate = AffineTransform(torsoangle,[0 1 0]',[0 0 2.75]) * Lstate;
rightJts(:,i) = Rstate(1:3,4);
leftJts(:,i) = Lstate(1:3,4);
i = i+1;



rightPoint = Rstate(1:3,4);
leftPoint = Lstate(1:3,4);

end


