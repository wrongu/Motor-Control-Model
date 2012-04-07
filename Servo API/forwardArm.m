%Divya Gunasekaran
%Jan 28, 2010
%Robot functions

%Function to move robot arm forward

function[iResult] = forwardArm(sock, side)

%Constants for position and speed of ShoulderRotator and ShoulderPitch
rotatorPos = 529;
speed = 100;
elbowSpeed = 200;
elbowPos = 512;
pitchPosition = containers.Map({'left', 'right'}, {830, 200});

if(strcmp(side, 'left') || strcmp(side, 'right'))
    iResult1 = moveServo(sock, [side, 'ShoulderRotator'], speed, rotatorPos);
    iResult2 = moveServo(sock, [side, 'ShoulderPitch'], speed, pitchPosition(side));
    iResult3 = moveServo(sock, [side, 'Elbow'], elbowSpeed, elbowPos);
    iResult = iResult1 || iResult2 || iResult3;
else
    disp('Error: Must specify Left or Right gripper');
    iResult = -1;
    return
end

end