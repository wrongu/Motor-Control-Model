%%

servoNamesRight = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'RightShoulderRotator', 'RightShoulderPitch',...  
    'RightElbow', 'RightWrist'};

servoNamesLeft = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'LeftShoulderRotator',...
    'LeftShoulderPitch', 'LeftElbow', 'LeftWrist'};

% for j=1:length(servoNames)
%     currPosition(j) = getAngle(sock, servoNames{j}, 512);
% end
% 
% [rightPoint, leftPoint, jointPosition] = ForwardKinematics_V4(currPosition);
% 
% 
% xyzPos = squeeze(jointPosition(1:3,4,:))';
% 
% plot3(xyzPos(:,1), xyzPos(:,2), xyzPos(:,3));

%INPUTS
position = [0 -8 7];
side = 'right';

posture = selectPosture(sock, A, position, side);
% rPostures = A{13,10,14}.r_postures;
% posture = rPostures(9,:);
position = zeros(1, length(posture));
zero = 512;

speed = 30;

%Convert angle in radians to servo position
for j=1:length(posture)
    deg = posture(j)*180/pi;
    position(1,j) = floor(deg*1024/300 + zero)
end

%position(1,1) = 512;
position(1,2) = 512;
position(1,3) = 512;

%%

%Move all servos
for i=1:length(posture)
    if(strcmp(side, 'right'))
        servo = servoNamesRight{i};
    elseif(strcmp(side, 'left'))
        servo = servoNamesLeft{i};
    else
        disp('Error');
        return;
    end
    moveServo(sock, servo, speed, position(1,i));
    %pause(0.25);
end