%Divya Gunasekaran
%Jan 28, 2010
%Robot functions

%Function to close robot gripper

function[iResult] = closeGripper(sock, side, speed)

%Upper bound for position for the left and right grippers, respectively
closePosLeft = 672;
closePosRight = 772;

%Determine whether to move Left or Right gripper
if(strcmp(side, 'left'))
    iResult = moveServo(sock, 'LeftGripper', speed, closePosLeft);
elseif(strcmp(side, 'right'))
    iResult = moveServo(sock, 'RightGripper', speed, closePosRight);
else
    disp('Error: Must specify Left or Right gripper');
    iResult = -1;
    return
end

end