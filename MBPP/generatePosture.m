%%Divya Gunasekaran
%%October 14, 2010

%Function to randomly generate a posture
%NOTE: The joint angles are further limited by their dependencies on one
%another.  This is not currently accounted for in this code. 
%Elbow angle constrained

%Output is a vector of length 11 with joint angles in radians

function newPosture = generatePosture()

[servoLimits, zeros, servoNames] = get_servo_info();


newPosture = zeros(size(servoNames));

for i=1:length(servoNames)
    %Compute random position within servo range
    bounds = servoLimits{i};
    clicks = (bounds(2) - bounds(1))*rand + bounds(1);
    
    %Convert position to radians
    deg = (clicks-zeros(i))*300/1024;  %degrees
    rad = deg*pi/180;   %radians 
    newPosture(i) = rad;
end