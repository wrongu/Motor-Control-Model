%Divya Gunasekaran
%May 6, 2011

%Movement is an array, where each row is a posture
%Each posture is only 7 angles

function [isValid,path] = CheckPostureCollisions_old(B,n,posture,side)

% addpath('C:\Users\Administrator\Documents\Matlab\MBPP');
% addpath('C:\Users\Administrator\Documents\Matlab\tcp_udp_ip');

%Get cell dimensions
w = B(1).width;
l = B(1).length;
h = B(1).height;
spacing = w;
path = []; %for testing

%First check is posture is empty
if(isempty(posture))
    isValid = 0;
    return;
end

jointCoords = zeros(3,3); %will hold the xyz coord of gripper, elbow, and shoulder
%Get the joint coordinates using forward kinematics
if(strcmp(side,'right'))
    angles = posture;
    angles = [angles 0 0 0 0];
    jointCoords(:,1) = ForwardKinematics_V4(angles);
    jointCoords(:,2) = ForwardKinematics_Elbow(angles);
    jointCoords(:,3) = ForwardKinematics_Shoulder(angles);
elseif(strcmp(side,'left'))
    angles = posture;
    angles = [angles(1) angles(2) angles(3) 0 0 0 0 angles(4) angles(5) angles(6) angles(7)];
    [rightPoint, jointCoords(:,1)] = ForwardKinematics_V4(angles);
    [rightPoint, jointCoords(:,2)] = ForwardKinematics_Elbow(angles);
    [rightPoint, jointCoords(:,3)] = ForwardKinematics_Shoulder(angles);
else
    disp('Error: Enter right or left side');
    isValid = 0;
    return;
end

%Check points along each limb segment to see if they lie within an
%obstacle region
[dim,numJoints] = size(jointCoords);
for i=1:numJoints-1

    firstJoint = jointCoords(:,i);
    secondJoint = jointCoords(:,i+1);

    %Length of line segment connecting first and second joint
    lineLen = euclidDist(firstJoint,secondJoint);

    %Get number of points on path
    tSpacing = (spacing / lineLen);

    t=0;
    while(t<=1)
        %Parametric equation of 3d line between first and second joints
        intermedPt = firstJoint + (secondJoint-firstJoint)*t;

        path = [path;intermedPt']; %for testing

        [x,y,z,cell] = findCell(intermedPt,n,w,l,h);
        
        %If the cell is blocked
        if(B(x,y,z).obstacle)
            %return invalid
            isValid = 0;
            return;
        end

        t = t + tSpacing;
    end
end


%Else if all points are valid, return valid
isValid = 1;

