%Divya Gunasekaran
%Jan 31, 2010
%Robot functions

%testing robot position and angles

%clear all

%Names of robot's servos
servoNames = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'RightShoulderRotator', 'RightShoulderPitch',...  
    'RightElbow', 'RightWrist'};

%Robot's IP address and port number
ip = '192.168.1.117';
port = 54000;

%Create TCP connection to robot
sock = connectRobot(ip, port);
if(sock < 0)
    disp('Could not connect to robot.');
    pnet('closeall');
    return;
else
    disp('Connected to robot');
end

%Get angle of each servo
rad = zeros(1, 7);
for i=1:length(servoNames)
    servo = servoNames{i};
    rad(i) = getAngle(sock, servo, 512);
end
robotAngles = rad

%Display retrieved joint angles
disp('Angles: ');
disp(rad);
[rightArmCoord, jointCoords] = ForwardKinematics(rad);

%Display x,y,z coordinates of each joint
for j=2:5
    disp('xyz coordinates of joint: ');
    jointXYZ = jointCoords{j};
    disp(jointXYZ(1:3,4));  
end
disp('xyz coordinates of gripper: ');
disp(rightArmCoord);


%Close connection and exit
pnet('closeall');
disp('Connection closed');
return;
