

%Testing different speeds in moving between different positions


%Robot's IP address and port number
ip = '192.168.1.117';
port = 54000;

%Names of robot's servos
servoNames = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'RightShoulderRotator', 'RightShoulderPitch',...  
    'RightElbow', 'RightWrist', 'LeftShoulderRotator', 'LeftShoulderPitch', 'LeftElbow', 'LeftWrist'};


%Create TCP connection to robot
sock = connectRobot(ip, port);
if(sock < 0)
    disp('Could not connect to robot.');
    pnet('closeall');
    return;
else
    disp('Connected to robot');
end

robotZero = 512;

%%INITIAL STATE: angles, position, time
%Get angle of each servo
% angles_init = zeros(1, 7);
% for i=1:length(servoNames)
%     servo = servoNames{i};
%     angles_init(i) = getAngle(sock, servo, robotZero);
% end
% [point_init, joints_init] = ForwardKinematics(angles_init);
% t0 = clock;
% 
%2-d vector to hold times and angles 
distOverTime = zeros(2, 20);
robotAngles = zeros(1, 11);
% %initial time and angle
% % t0 = clock;
% % anglesOverTime(1,1) = 0; 
% % anglesOverTime(2,1) = getAngle(sock, 'RightWrist', robotZero);
 


% 
%MOVEMENT HERE
% %Constants for position and speed of ShoulderRotator and ShoulderPitch
% rotatorPos = 529;
% speed = 50;
% elbowSpeed = 50;
% elbowPos = 512;
% pitchPosition = containers.Map({'Left', 'Right'}, {830, 200});
% 
% moveServo(sock, 'RightShoulderRotator', speed, rotatorPos);
% moveServo(sock, 'RightShoulderPitch', speed, pitchPosition('Right'));
% moveServo(sock, 'RightElbow', elbowSpeed, elbowPos);

position = [0 -8 7];
posture = selectPosture(sock, A, position, 'right');

tStart = tic;
for i=1:20
    %Mark time
    distOverTime(1,i) = toc(tStart);
    
    %Get robot's angles on the right side
    for j=1:7
        servo = servoNames{j};
        robotAngles(j) = getAngle(sock, servo, 512);
    end
    
    %Calculate and record position of right gripper
    [rightPt, leftPt] = ForwardKinematics_V5(robotAngles);
    distOverTime(2,i) = rightPt;
    
    pause(0.1);
end

distOverTime(1,1) = 0;
speedVectors = zeros(1, 20);
for i=2:20
    speedVectors(i) = dist(distOverTime(1,i), distOverTime(1,i-1)) / (anglesOverTime(2,i)-anglesOverTime(2,i-1));
end

plot(distOverTime(1,:), speedVectors);
    
% %FINAL STATE: angles, position, time
% tf = clock;
% %Get angle of each servo
% angles_final = zeros(1, 7);
% for i=1:length(servoNames)
%     servo = servoNames{i};
%     angles_final(i) = getAngle(sock, servo, robotZero);
% end
% [point_final, joints_final] = ForwardKinematics(angles_final);


% %Calculate distance covered and speed
% d = dist(point_final, point_init)
% time = etime(tf, t0)
% avg_speed = d / time


%Close connection and exit
pnet('closeall');
disp('Connection closed');
return;