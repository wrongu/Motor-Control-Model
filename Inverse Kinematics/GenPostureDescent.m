%Divya Gunasekaran
%Generate new posture that attains the target via gradient descent
%May 7, 2011

%currAngles input is a vector of 7 joint angles as is posture output
% targetXYZ should be a point close to the current position (current
% position. Use this script to, for example, generate the movement
% corresponding to a given path (where points in the path are closely
% spaced)

function [posture,currXYZ,isValid] = GenPostureDescent(currAngles, targetXYZ, stepSize, side, thresh)

currXYZ = GetPosturePosition(currAngles, side);
isValid = 1;
limit=5;
tries=0;
loopcount = 0;

%Continue gradient descent while distance from current position to target
%position is above given threshold and generated postures are valid
while(euclidDist(currXYZ,targetXYZ) > thresh && isValid && tries < limit)
    
    %One step of gradient descent to get new postures closer to target
    newAngles = gradDescent(currAngles, targetXYZ, stepSize, side);
    
    %Check if servo positions of new posture are within range
    [isValid, ~, invalidAngles] = CheckServoBounds(newAngles,side);
    
    %If any of the new angles violate a servo's joint range of motion, undo
    %the update at that joint and continue gradient descent
    if(~isValid)
        for i=1:numel(invalidAngles)
            undoAngle = invalidAngles(i);
            newAngles(undoAngle) = currAngles(undoAngle);
            isValid = 1;
        end
    end
    
    %Keep track of how many times posture descent results in the same
    %posture
    if(isequal(currAngles,newAngles))
        tries = tries + 1;
        disp(['GenPostureDescent: loop # ' num2str(loopcount) ' tries: ' num2str(tries)]);
    else
        tries = 0;
    end
    
    currAngles = newAngles;
    currXYZ = GetPosturePosition(currAngles, side);
    
    loopcount = loopcount + 1;
    
end

posture = currAngles;

