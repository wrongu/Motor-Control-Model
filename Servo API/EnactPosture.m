%Divya Gunasekaran
%May 16, 2011

%Have robot move to given posture at given speed

function targetPosition=EnactPosture(sock,posture,speed,side)

%% Convert selected posture (currently in radians) to set of servo positions

targetPosition = zeros(size(posture));
zero = 512; %robot zero

%Convert angle in radians to servo ticks (1024 ticks per 300 degrees)
for j=1:length(posture)
    deg = posture(j)*180/pi;
    targetPosition(1,j) = floor(deg*1024/300 + zero);
end


%Manually set TorsoPitchTwo to the opposite of TorsoPitchOne to avoid complications
% intuitive equation: tpitch2 = zero - (tpitch1 - zero)
% shorter version:
% targetPosition(1,3) = 2*zero - targetPosition(1,2);

%% Move robot servos to selected posture

%Names of arm and torso servos
[~, ~, servoNames] = get_servo_info();

% %Move all servos
% for i=1:length(posture)
%     if(strcmp(side, 'right'))
%         servo = servoNames{i};
%     elseif(strcmp(side, 'left'))
%         if(i>=4)
%             j=i+4;
%             servo = servoNames{j};
%         else
%             servo = servoNames{i};
%         end
%     else
%         disp('Error');
%         return;
%     end
%     moveServo(sock, servo, speed, targetPosition(1,i));
% end

%Move all servos
servoNames = full_posture_to_partial(servoNames, side);

for i=1:length(posture)
    servo=servoNames{i};
    moveServo(sock, servo, speed, targetPosition(1,i));
end