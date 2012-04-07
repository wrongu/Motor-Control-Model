% Divya Gunasekaran
% May 9, 2011

% updated on 3 August 2011 by Richard Lange
%   Changes: removed input parameter n (can be read from B)
% updated on 27 October 2011
%   now uses exclusively gradient descent (no memory lookup).
%   some input parameters removed

% Generate a new movement given a path of points

function [B, movement, retry] = GenMovement(B, curPosture, path, side, thresh)

    %Get dimensions of cells and postures
    n = size(B,1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    if(strcmp(side,'right'))
        numJoints = size(B(1).r_postures, 2);
    elseif(strcmp(side,'left'))
        numJoints = size(B(1).l_postures, 2);
    end

    retry = false;

    numPoints = size(path, 1);
    movement = zeros(numPoints, numJoints);

    % ########################
    % ###  LOOP OVER PATH  ###
    % ########################
    
    for r=1:numPoints
        position = path(r,:);

        % ########################
        % ### GRADIENT DESCENT ###
        % ########################
        
        % Generate a new posture using gradient descent
        [posture, currXYZ, dists, ~, pts] = InverseKinematics(position, curPosture, side, thresh);

%         figure();
%         plot(dists, '-o');
%         line([1 length(dists)], [thresh, thresh], 'LineStyle', '--');
%         
%         num_iters = size(pts,1);
%         figure();
%         plot(1:num_iters, pts(:,1)-pts(end,1), 1:num_iters, pts(:,2)-pts(end,2), 1:num_iters, pts(:,3)-pts(end,3));
%         legend('theta', 'radius', 'z');
%         xlabel('iteration num');
        
        % Find the cell corresponding to the current point
        [i,j,k,~] = findCell(currXYZ,n,w,l,h);

        % Store the newly generated posture in the appropriate cell
        if(strcmp(side,'right'))
            % Store newly generated right posture in cell array
            [B(i,j,k).r_postures, ~] = checkPostureRedundancy(B(i,j,k).r_postures, posture, 0);
        elseif(strcmp(side,'left'))
            % Store newly generated left posture in cell array
            [B(i,j,k).l_postures, ~] = checkPostureRedundancy(B(i,j,k).l_postures, posture, 0);
        else
            disp('GenMovement Error: Enter left or right for side');
            movement = [];
            return;
        end        
            
        % Add the posture to the movement 
        movement(r,:) = posture;
        % update current posture
        curPosture = posture;

    end
end


