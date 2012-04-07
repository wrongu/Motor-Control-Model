%Divya Gunasekaran
%Jan 28, 2010
%Robot functions

%Function to "wave" right elbow
%used when scanning with sensor on robot's right elbow

function[iResult] = waveElbow(sock, wave)

%Constants for speed and position
speed = 100;
pos1 = 350;
pos2 = 612;

if(wave)
    iResult = moveServo(sock, 'RightElbow', speed, pos1);
else
    iResult = moveServo(sock, 'RightElbow', speed, pos2);
end


end