%Divya Gunasekaran
%Feb. 28, 2011

%Getting degrees per second for different joints at different speed
%settings

function degPerSec = testSpeedSetting(sock, servo, endAngle, speed)

% %Robot's IP address and port number
% ip = '192.168.1.117';
% port = 54000;
% 
% %Names of robot's servos
% %servoNames = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'RightShoulderRotator', 'RightShoulderPitch',...  
%     %'RightElbow', 'RightWrist', 'LeftShoulderRotator', 'LeftShoulderPitch', 'LeftElbow', 'LeftWrist'};
% 
% 
% %Create TCP connection to robot
% sock = connectRobot(ip, port);
% if(sock < 0)
%     disp('Could not connect to robot.');
%     pnet('closeall');
%     return;
% else
%     disp('Connected to robot');
% end

robotZero = 512;
rad = getAngle(sock, servo, robotZero);
startAngle = rad*180/pi; %startAngle is in degrees

%start and endAngle are in degrees
endPosition = round(endAngle*1024/300 + robotZero);

%start timer
tStart = tic;

%move servo
moveServo(sock, servo, speed, endPosition);

%wait until arm stopped moving
pause

%stop timer
tElapsed = toc(tStart)

%change in angle
deltaAngle = abs(endAngle - startAngle)

%average speed in degrees per second
degPerSec = deltaAngle / tElapsed;

% %Close connection and exit
% pnet('closeall');
% disp('Connection closed');
