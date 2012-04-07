%Divya Gunasekaran
%May 7, 2011

%Given a posture (vector of 7 angles), determine if the posture is valid
%in terms of servo positions being within their allowable range of motion

function [isValid,servoPosition,invalidAngles] = CheckServoBounds(posture,side)

%Names of arm and torso servos
servoNames = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'RightShoulderRotator', 'RightShoulderPitch',...  
    'RightElbow', 'RightWrist', 'LeftShoulderRotator',...
    'LeftShoulderPitch', 'LeftElbow', 'LeftWrist'};

%Position limits for arm and torso servos -- [lower bound, upper bound]
servoLimits = {[0,1022], [500,525], [500,525], [0,1022], [170,829], [151,512], [0,1022], ... 
     [0,1022], [230, 870], [512,885], [0,1022]};


zero = 512; %robot zero
servoPosition = zeros(1,length(posture));
invalidAngles = []; %will store any angles that violate joint range of motion
isValid = 1; %Will be changed to 0 if there are invalid angles

%Check whether each angle is within the servo's range
for i=1:length(posture)
    if(strcmp(side, 'right'))
        bounds = servoLimits{i};
    elseif(strcmp(side, 'left'))
        if(i>=4)
            j=i+4;
            bounds = servoLimits{j};
        else
            bounds = servoLimits{i};
        end
    else
        disp('Error');
        return;
    end
   
    %Manually set TorsoPitchOne and TorsoPitchTwo to avoid complications
    if(i==2 || i==3)
        servoPosition(i) = zero; 
    %Calculate the servo positions for the other angles
    else
        deg = posture(i)*180/pi;
        servoPosition(i) = floor(deg*1024/300 + zero);
    end
    
    %If the servo position is out of range for the servo, invalid posture
    if(servoPosition(i) < bounds(1) || servoPosition(i) > bounds(2))
        isValid = 0;
        invalidAngles = [invalidAngles i];
    end  
end

