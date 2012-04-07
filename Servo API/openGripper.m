%Divya Gunasekaran
%Jan 28, 2010
%Robot functions

%Function to open robot gripper

function[iResult] = openGripper(sock, side, speed)

%Lower position limit for the left and right grippers, respectively
openPosLeft = 373;
openPosRight = 290;

%Determine whether to move Left or Right gripper
if(strcmp(side, 'left'))
    iResult = moveServo(sock, 'LeftGripper', speed, openPosLeft);
elseif(strcmp(side, 'right'))
    iResult = moveServo(sock, 'RightGripper', speed, openPosRight);
else
    disp('Error: Must specify Left or Right gripper');
    iResult = -1;
    return
end

end
        
       
