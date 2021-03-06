% Divya Gunasekaran
% May 16, 2011
%
% Get robot's servo positions in units of radians
% ignore any angles in the cell array of names 'skip_servos'

function allAngles = GetCurrPosture(sock, oldAngles, skip_servos)

%Names of arm and torso servos
[~,~,servoNames] = get_servo_info();
numServos = length(servoNames);

if(nargin < 3)
    skip_servos = {};
end
if(nargin < 2)
    oldAngles = zeros(1,numServos);
end

zero = 512; %robot zero for servos
% default values (if no server response or if skipped)
allAngles = oldAngles;

skip_indices = ismember(servoNames, skip_servos);
%Else get robot's current posture in radians if initPosture not given
for p=1:numServos
    servo = servoNames{p};
    if(skip_indices(p))
        continue;
    end
    angle = getAngle(sock, servo, zero);
    if(~isnan(angle))
        allAngles(p) = angle;
        % otherwise, defaulted to oldAngles already
    end
end

