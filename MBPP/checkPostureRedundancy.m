%%Divya Gunasekaran
%%October 14, 2010

%Function to check if a posture is redundant/unnecessary 
%If posture is not redundant, store it in the posture array for the cell

%Inputs:
%stored_postures is array or struct containing all the registered postures in a given
%cell
%currPosture is the most recently generated posture we are checking
%lambda is the threshold for how similar two postures in terms of Euclidean
%distance

function [stored_postures, storePosture] = checkPostureRedundancy(stored_postures, currPosture, lambda) 
[numPostures, numAngles]=size(stored_postures); 
storePosture = 1; %flag s.t. if 1, store the posture, otherwise discard posture

lambda = abs(lambda);

% Only check redundancy if lambda is greater than zero. Zero lambda is a
% trivial case where all postures pass

if(lambda > eps)
    for i=1:numPostures
        % Calculate Euclidean distance between the new posture and already
        % stored postures
        d=0;
        for j=1:numAngles
            d = d+(stored_postures(i,j)-currPosture(j))^2;
        end
        d= sqrt(d);
        %if distance is less than a user-defined threshold, discard the posture
        if d <= lambda
            storePosture=0;
            break;
        end
    end
end

% if posture 'passed', IE is unique enough:
if(storePosture==1)
    stored_postures(numPostures+1, :) = currPosture;
end