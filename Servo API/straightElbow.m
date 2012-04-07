%Divya Gunasekaran
%Jan 28, 2010
%Robot functions

%Function to straighten robot elbows

function[iResult] = straightElbow(sock)

%Constants for position and speed
straightPos = 512;
speed = 50;

iResult1 = moveServo(sock, 'LeftElbow', speed, straightPos);
iResult2 = moveServo(sock, 'RightElbow', speed, straightPos);

iResult = iResult1 || iResult2;

end