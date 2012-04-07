%Divya Gunasekaran
%Jan 26, 2010
%Robot functions

%Wake-up program writen by Dan Muldrew
%Modified to use robot functions by Divya Gunasekaran

clear all

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

%Set speed and position for servos
speed = 50;
position = 512;

%Tell all servos to move
iResult = moveServo(sock, 'All', speed, position);

%Close connection and exit
pnet('closeall');
disp('Connection closed');
return;

