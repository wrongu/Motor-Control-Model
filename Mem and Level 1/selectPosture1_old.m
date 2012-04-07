%Divya Gunasekaran
%Feb. 16, 2011

% Select the posture for which all the joints move simultaneously by roughly 
%the same amount
%initPosture is a row vector of 11 angles (for right or left side)

function [posture,cellIndex] = selectPosture1_old(B, position, initPosture, side, weight_s, weight_v)

%Lengths of robot arm segments
rotatorToShoulder = 0.5;
shoulderToElbow = 4.125;
elbowToWrist = 2; 
wristToGripper = 6.5;

shoulderRotator = rotatorToShoulder + shoulderToElbow + elbowToWrist + wristToGripper;
torsoYaw = shoulderRotator*2;
shoulderPitch = shoulderRotator - rotatorToShoulder;
elbow = shoulderPitch - shoulderToElbow;
wrist = elbow - elbowToWrist;

armLengths = {torsoYaw, 0, 0, shoulderRotator, shoulderPitch, elbow, wrist};

lengthSum = sum(armLengths);

%Find cell to which given position belongs
n = size(B,1);
w = B(1).width;
l = B(1).length;
h = B(1).height;
[i, j, k, cellIndex] = findCell(position, n, w, l, h);

%Get all possible postures appropriate cell for the given side (right or
%left) and reduce the current posture to 7 angles
if(strcmp(side, 'left'))
    stored_postures = B(i,j,k).l_postures; %matrix of postures of left side
    currPosture = [initPosture(1) initPosture(2) initPosture(3) initPosture(8) initPosture(9) initPosture(10) initPosture(11)];
elseif (strcmp(side, 'right'))
    stored_postures = B(i,j,k).r_postures; %matrix of postures of right side
    currPosture = [initPosture(1) initPosture(2) initPosture(3) initPosture(4) initPosture(5) initPosture(6) initPosture(7)];
else
    disp('Error: please specify left or right side');
    posture = -1;
    return;
end

numPostures = size(stored_postures, 1);
minCost = Inf; % initially set minCost to infinity - any other cost will be less
minPostureIndex = 1;

spatialErrorVector = zeros(1,numPostures);
travelCostVector = zeros(1,numPostures);

% If cell has registered postures
% Calculate the standard deviation across joint angles of robot's current 
% position and each registered posture and choose the registered posture
% with the smallest standard deviation
if(numPostures) % if there exists a posture (or more)
    % For each set of postures (skip first because it's all zeros)
    for i=2:numPostures

        spatialError = 0;
        
        % Calculate spatial error cost
        % For right gripper
        if(strcmp(side, 'right'))
            potentialPosture = [stored_postures(i,:) 0 0 0 0];
            [rightPoint, ~, ~,~] = ForwardKinematics_V4(potentialPosture);
            %Euclidean distance between pos. of right gripper and target
            spatialError = euclidDist(rightPoint, position);
        %For left gripper
        elseif(strcmp(side, 'left'))
            potentialPosture = [stored_postures(i,1) stored_postures(i,2) stored_postures(i,3) 0 0 0 0 stored_postures(i,4) stored_postures(i,5) stored_postures(i,6) stored_postures(i,7)];
            [~, leftPoint, ~, ~] = ForwardKinematics_V4(potentialPosture);
            %Euclidean distance between pos. of left gripper and target
            spatialError = euclidDist(leftPoint, position);
        end
        spatialErrorVector(i) = spatialError;
        
        %Calculate travel cost
        travelCostVector(i) = TravelCost(stored_postures(i,:), currPosture);
    end
    
    MaxS = max(spatialErrorVector); 
    MaxV = max(travelCostVector);
    
    %Select the posture with the minimum total cost
    for i=2:numPostures
        totalCost = weight_s*(spatialErrorVector(i)/MaxS) + weight_v*(travelCostVector(i)/MaxV);
        if(totalCost <= minCost)
            minCost = totalCost;
            minPostureIndex = i;
        end
    end
else
    disp('No registered postures for this position.');
    posture = [];
    return;
end

posture = stored_postures(minPostureIndex, :);



