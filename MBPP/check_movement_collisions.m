% check_movement_collisions.m
% written by Richard Lange
% August 31, 2011
%
% Given a movement and 3D space of obstacles, returns false if there is a
% collision

function isValid = check_movement_collisions(B, movement, side)
    num_postures = size(movement, 1);
    isValid = true;
    for i = 1:num_postures
        if(~CheckPostureCollisions(B, movement(i,:), side))
            isValid = false;
            return;
        end
    end
end