%Divya Gunasekaran
%Feb. 16, 2011

% Select the posture for which all the joints move simultaneously by roughly 
%the same amount

function posture = selectPosture(sock, A, i, j, k, side)
% (sock, A, position, side, n, w, l, h)

%Names of arm and torso servos
servoNames = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'RightShoulderRotator', 'RightShoulderPitch',...  
    'RightElbow', 'RightWrist', 'LeftShoulderRotator',...
    'LeftShoulderPitch', 'LeftElbow', 'LeftWrist'};
% 
% %Position limits for arm and torso servos -- [lower bound, upper bound]
% servoLimits = {[0,1022], [500,525], [500,525], [0,1022], [170,829], [151,885], [0,1022], ... 
%      [0,1022], [230, 870], [151,885], [0,1022]};
% 
% 
%  for i=1:length(servoLimits)
%     servoLimitDiff{i} = servoLimits{i}(2)-servoLimits{i}(1);
%  end


zero = 512; %robot zero for servo
numServos = length(servoNames);
allPostures = zeros(1, numServos);
%Get robot's current posture in radians
for p=1:numServos
    servo = servoNames{p};
    allPostures(1,p) = getAngle(sock, servo, zero);
end

% [i, j, k] = findCell(position(1), position(2), position(3), n, w, l, h);

if(strcmp(side, 'left'))
    Postures = A{i,j,k}.l_postures; %matrix of postures of left side
    currPosture = [allPostures(1) allPostures(2) allPostures(3) allPostures(8) allPostures(9) allPostures(10) allPostures(11)];
elseif (strcmp(side, 'right'))
    Postures = A{i,j,k}.r_postures; %matrix of postures of right side
    currPosture = [allPostures(1) allPostures(2) allPostures(3) allPostures(4) allPostures(5) allPostures(6) allPostures(7)];
else
    disp('Error: please specify left or right side');
    posture = -1;
    return;
end

s = size(Postures); %Get dimensions of matrix of postures
minChange = 1000000; %initially set minChange to "infinity"
minPostureIndex = 1;


%If postures are stored in the cell
if(s(1) > 1)
    %For each set of postures
    for i=2:s(2)
        %Convert the positions to radians
        Postures_Rad = zeros(1,7); %store joint angles in units of radians
        for m=1:7
            degrees = (Postures(i,m) - zero)*300/1024; %degrees
            Postures_Rad(1,m) = degrees*pi/180; %radians
        end
        %Calculate the difference between each pair of joint angles
        diffVector = zeros(1, 7); %store difference between each pair of angles
        for j=1:7
            diffVector(1, j) = (Postures_Rad(1,j)-currPosture(1,j))^2;
        end
        sumDiff = 0;
        for n=1:length(diffVector)
            sumDiff = diffVector(1,n) + sumDiff
        end
        stdDev = sqrt(sumDiff / length(diffVector))
        if(stdDev <= minChange)
            minChange = stdDev
            minPostureIndex = i
        end
    end
end

posture = Postures(minPostureIndex, :);

