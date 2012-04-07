% break_down_movement.m
% Written by Richard Lange
% August 31, 2011
%
% given a movement, this function will return an equivalent movement broken
% into smaller pieces such that no joint makes a step larger than the given
% threshold in one frame.
%
% each row of movement is a point in time, each column is a joint angle in
% radians

function new_movement = break_down_movement(movement, max_angle_step)
    % get the biggest step of any joint by using diff() along the time
    % dimension and finding the max
    largest_step = max(diff(movement, 1, 1), [], 2);
    [largest_step, index_ls] = max(largest_step);
%     fprintf('largest step is %f radians, between postures %d and %d\n', largest_step, index_ls, index_ls+1);
    
    [num_postures, num_angles] = size(movement);
    
    
    if(largest_step  > max_angle_step)
        num_new_divisions = ceil(largest_step / max_angle_step);
        new_movement = zeros(num_postures + num_new_divisions, num_angles);
%         fprintf('previous movement had %d postures, new movement has %d.\n', num_postures, num_postures + num_new_divisions);
        % movements in time up to the largest division are unchanged
        new_movement(1:index_ls-1,:) = movement(1:index_ls-1, :);
        % movement broken down smaller pieces where it was too large a step
        % before:
        for i = 1:num_angles
            new_movement(index_ls:index_ls+num_new_divisions+1, i) = ...
                linspace(movement(index_ls, i), movement(index_ls+1, i), ...
                         num_new_divisions+2);
        end
        % remaining parts are same too
        new_movement(index_ls+num_new_divisions+2:end,:) = ...
            movement(index_ls+2:end,:);
        
        % recurse in case the second largest difference was also too large
        new_movement = break_down_movement(new_movement, max_angle_step);
    else
        new_movement = movement;
        return;
    end
end