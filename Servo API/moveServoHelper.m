%Divya Gunasekaran
%Jan 26, 2010
%Robot functions

%Helper function to move an individual servo

%Inputs:
    %sock = socket id of connection to the robot
    %servo = name of the servo to command
        %Note: Assumes given servo name is correct
    %bounds = [lowerLimit, upperLimit] for position of given servo
    %speed = speed at which the robot's servo will move
    %pos = position to which the servo will be moved
        %pos must be within valid range
        
%Outputs:
    %iResult = Greater than 0 if commands sent successfully; -1 otherwise

%Assumes servo name is correct

function[iResult] = moveServoHelper(sock, servo, bounds, speed, pos)

    %Get lower and upper bound for position
    lowerBound = bounds(1);
    upperBound = bounds(2);
    
    %If given position is within bounds for the given position,
    %then execute move command to given position with given speed
    if(pos >= lowerBound && pos <= upperBound)
        speedCmd = [servo, '.speed=', num2str(speed)];
        posCmd = [servo, '.position=', num2str(pos)];
        sendStr(sock, speedCmd, 1, false);
        sendStr(sock, posCmd, 1, false);
        iResult=1;
    else
        disp(['Error: Position ' num2str(pos) ' is out of bounds for ' servo]);
        iResult=-1;
    end
    
end

