% [center spanning_vectors] = get_goal_space_by_task(task, side)
%
% each task has a region of space that is defined to be 
%
% returns:
%   center              1x3 vector of center of goal space [x y z]
%   spanning_vectors    3x3 matrix of (row) vectors that span goal space. to
%                       generate a random goal point, take a linear
%                       combination of the vectors where the weights are in
%                       [-1, 1].
%
% EXAMPLE:
%   weights = rand(1,3)*2-1; % 3 random numbers on [-1, 1]
%   rand_goal = center + weights(1)*spanning_vectors(1,:) ...
%                      + weights(2)*spanning_vectors(2,:) ...
%                      + weights(3)*spanning_vectors(3,:);
%
% Note:
% - to weight to the outside of space, take the square root of the weight
% - to weight towards the center, square the weight
%
% written by Richard Lange 
% December 8, 2011

function [center spanning_vectors] = get_goal_space_by_task(task, side)
    
    % get space for right side - switched to left at the end.
    switch task
        case 'reaching'
            center = [6 -4 7];
            spanning_vectors = [8 0 0;
                                0 10 0;
                                0 0 7];
        case 'blocking'
            center = [5.4696   -3.9787   10.9610];
            spanning_vectors = [3.9672    5.3424   -0.1540;
                                2.4085   -1.7885         0;
                                -0.0276   -0.0371   -1.9995];
            
        case 'eating'
            center = [5 0 8];
            spanning_vectors = [1 0 0;
                                0 1 0;
                                0 0 1];
            
        otherwise
            [center spanning_vectors] = ...
                get_goal_space_by_task('reaching', side);
            
    end
    
    % if left, reflect y values
    if(strcmp(side, 'left'))
        center(2) = -center(2);
        spanning_vectors(:,2) = -spanning_vectors(:,2);
        
    end
end