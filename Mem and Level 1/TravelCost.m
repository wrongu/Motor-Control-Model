%Divya Gunasekaran
%March 9, 2011

%function to calculate travel cost for a given posture
%as defined by Rosenbaum et. al (2001)

function travelCost = TravelCost(currPosture, newPosture)

%% Set expense factors for each joint

%Lengths of each robot arm segments
rotatorToShoulder = 0.5;
shoulderToElbow = 4.125;
elbowToWrist = 2; 
wristToGripper = 6.5;

%Length of arm that each joint moves
shoulderRotator = rotatorToShoulder + shoulderToElbow + elbowToWrist + wristToGripper;
torsoYaw = shoulderRotator*2;
shoulderPitch = shoulderRotator - rotatorToShoulder;
elbow = shoulderPitch - shoulderToElbow;
wrist = elbow - elbowToWrist;

%Cell array of arm lengths each joint moves
armLengths = {torsoYaw, 0, 0, shoulderRotator, shoulderPitch, elbow, wrist};

%Calculate sum of all arm lengths
lengthSum = 0;
for i=1:length(armLengths)
    lengthSum = lengthSum + armLengths{i};
end

%Cell array of expense factors for joints
for i=1:length(armLengths)
    expenseFactors{i} = (armLengths{i}/lengthSum);
end


%% Travel cost calculations

commonTimeNumer = 0; %numerator of the optimal common time calculation
commonTimeDenom = 0; %denominator of the optimal common time calculation
numAngles = length(newPosture);

%Calculate optimal common time for joint movement
for i=1:numAngles
    %Absolute angular displacement
    angleDisplacement = abs(currPosture(i) - newPosture(i));
    
    %Optimal time for individual joint movement
    optTime = expenseFactors{i}*log(angleDisplacement + 1);
    
    commonTimeNumer = expenseFactors{i}*angleDisplacement*optTime + commonTimeNumer;
    commonTimeDenom = expenseFactors{i}*angleDisplacement + commonTimeDenom;
    
end

%Optimal common time for joint movement
optCommonTime = commonTimeNumer / commonTimeDenom;

travelCost = 0; %travel cost for the given posture
r = 1; %unit of absolute angular displacement, radians
s = 1; %unit of time, seconds

%Calculate travel cost for posture
for i=1:numAngles
    %Absolute angular displacement
    angleDisplacement = abs(currPosture(i) - newPosture(i));
    
    %Optimal time for individual joint movement
    optTime = expenseFactors{i}*log(angleDisplacement + 1);
    
    %Calculate travel cost
    travelCost = travelCost + (expenseFactors{i}*angleDisplacement/r)*(1 + ((optCommonTime - optTime)^2/s^2));
    
end
    
