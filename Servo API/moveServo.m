%Divya Gunasekaran
%Jan 26, 2010
%Robot functions

%Function to move robot servos

%Inputs:
    %sock = socket id of connection to the robot
    %servo = name of the servo to command
        %servo='Left' moves all of the robot's left servos
        %servo='Right' moves all of the robot's right servos
        %servo='All' moves all of the robot's servos
    %speed = speed at which the robot's servo will move
    %pos = position to which the servo will be moved
        %pos must be within valid range
        
%Outputs:
    %iResult = Greater than 0 if commands sent successfully; -1 otherwise
    
%Note: Currently, the 'All' keyword does not include torso servos


function[iResult] = moveServo(sock, servo, speed, pos)

%%
%VARIABLES AND STRUCTS

[servoLimits, ~, servoNames] = get_servo_info();

% %Names of arm and torso servos
% servoNames = {'RightShoulderRotator', 'RightShoulderPitch',...  
%     'RightElbow', 'RightWrist', 'RightGripper', 'LeftShoulderRotator',...
%     'LeftShoulderPitch', 'LeftElbow', 'LeftWrist', 'LeftGripper', ...
%     'TorsoYaw', 'HeadPitch', 'HeadYaw', 'TorsoPitchOne', 'TorsoPitchTwo'};
% 
% %Position limits for arm and torso servos -- [lower bound, upper bound]
% servoLimits = {[0,1022], [170,829], [151,885], [0,1022], [290,772], [0,1022], ... 
%      [230,870], [151,885], [0,1022], [373,672], [0,1022], [352,708], ...
%      [0,1022], [500,525], [500,525]};

%"Hash table" mapping servo names to their position limits
servoTable = containers.Map(servoNames, servoLimits);
    

%%
%MOVE COMMAND

%If given servo is a key in the above associative array
%Move the given servo
if(isKey(servoTable, servo))
    [~, servo_ind] = ismember(servoNames, servo);
    bounds = servoLimits{find(servo_ind)};
    iResult = moveServoHelper(sock, servo, bounds, speed, pos);
    
%If given servo is 'Left' or 'Right' keyword
%Move all of the robot's left servos   
elseif(strcmp(servo, 'Left') || strcmp(servo, 'Right'))
    indices = strmatch(servo, servoNames);
    for i=1:length(indices)
        nameIndex = indices(i); %index for servoNames array
        currServo = servoNames{nameIndex}; %name of servo on left side
        bounds = servoTable(currServo); %bounds for the servo
        iResult = moveServoHelper(sock, currServo, bounds, speed, pos);
        if(iResult == -1)
            return;
        end
    end
        
%If given servo is 'All' keyword
%Move all of the robot's servos   
elseif(strcmp(servo, 'All'))
    for i=1:(length(servoNames)-2) %don't include torso servos for now
        servoName = servoNames{i}; %name of servo 
        bounds = servoTable(servoName); %bounds for the servo
        iResult = moveServoHelper(sock, servoName, bounds, speed, pos);
        if(iResult == -1)
            return;
        end
    end
    
%Else invalid input for servo        
else
    disp('Error: Invalid servo');
    iResult=-1;
end

end

