% Divya Gunasekaran
% May 16, 2011

% Check each intermediate posture in the movement

function [is_valid obstacle_locations posture] = CheckMovement(B,movement,side)

numPostures = size(movement, 1);

obstacle_locations = [];
is_valid = true;

for i=1:numPostures
    posture = movement(i,:);
    [is_valid, obstacle_locations] = CheckPostureCollisions(B,posture,side);
    
    % if posture had collision, fail and return
    % Note: obstacle_locations not checked for other postures in the
    % movement. Considering only first collisions.
    if(~is_valid)
        return;
    end
end