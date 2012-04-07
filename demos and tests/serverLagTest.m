%% setup variables

stats = struct;
numRuns = 100;

%% SAVE stats struct
save('savedLagSats','stats');

%% Measure time to create TCP connection to robot. 
stats.connectTime = zeros(1,numRuns);

ip = '192.168.1.117';
port = 54000;

for i = 1:numRuns
    tic;
    sock = robo_connect(1);
    elapse = toc;
    stats.connectTime(i) = elapse;
    if(sock < 0)
        disp('Could not connect to robot.');
        pnet('closeall');
        return;
    else
        disp('Connected to robot');
    end
    pnet('closeall');
    disp('Connection closed');
end

%% Measure time to send and receive data with servos (move them zero distance)

%code copied from testAngles.m :
servoNames = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', 'RightShoulderRotator', 'RightShoulderPitch',...  
    'RightElbow', 'RightWrist','LeftShoulderRotator','LeftShoulderPitch','LeftElbow','LeftWrist'};

stats.servoLagTime = cell(1,length(servoNames));

ip = '192.168.1.117';
port = 54000;
sock = connectRobot(ip,port);
if(sock < 0)
    disp('Could not connect to robot.');
    pnet('closeall');
    return;
else
    disp('Connected to robot');
end

moveServo(sock, 'All', 30, 512); % wakeup
pause;


for i=1:numel(servoNames)
    stats.servoLagTime{i} = struct;
    stats.servoLagTime{i}.name= servoNames{i};
    stats.servoLagTime{i}.sendReceiveTime = zeros(1,numRuns);
    for j=1:numRuns
        curPos = 512;%getAngle(sock,servoNames{i},512,'ticks');
        %code from moveServoHelper. doing it directly.
        posCmd = [servoNames{i}, '.position=', num2str(curPos)];
        tic;
        sendStr(sock, posCmd);
        elapse = toc;
        stats.servoLagTime{i}.sendReceiveTime(j) = elapse;
    end
end

 pnet('closeall');
 disp('Connection closed');
 
clear i j elapse curPos