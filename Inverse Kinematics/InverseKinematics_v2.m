% Richard Lange
% August 17 2011
%
% InverseKinematics(targetXYZ, currJointAngles, side, threshold)
%
% returns new joint angle configuration that puts the brainbot's gripper within
% 'threshold' of targetXYZ
%
% For this function to run quickly and effectively, targetXYZ should not be
% too far from the current position. In the generic sense, "too far" is
% based on the complexity (degrees of freedom) of the arm and the precision
% required. IE don't request a small threshold for a point far away.
%
% Inverse Kinematics implementation using Gradient Descent. The process is
% to compute a jacobian matrix for the change in position with respect to
% changes (plus epsilon) of joint configurations and call this a good
% approximation of the partial derivatives. The updated position is found
% using the Transpose of the jacobian (rather than its inverse), which is a
% good enough approximation. This algorithm iterates through this process
% using small spatial steps (Beta)
% 
% Copied from ForwardKinematics_V5:
% Rangles = [-angles(7), -angles(6), -angles(5), -angles(4), torsoangle, angles(1)];
% Langles = [angles(11), angles(10), angles(9), angles(8), torsoangle, angles(1)];
%
% TODO: add a tendency for servos to move towards 'ideal' positions as
% defined in get_servo_info.m

function [new_angles currPoint dist_history path posture_history] = InverseKinematics_v2(targetXYZ, currJointAngles, side, threshold, M)
    if(length(currJointAngles) ~= 11)
        joint_angles_temp = partial_posture_to_full(currJointAngles, side);
    else
        joint_angles_temp = currJointAngles;
    end
    
    % joint weights: a zero means don't use that joint. 1 means use it fully.
    % Shoulder Pitches (indeces 5 (right) and 9 (left) must be weighted in
    % relative to the elbow's weight in proportion to their lengths.
    % Otherwise, since the distance from shoulder to end effector is
    % (generally) longer than from the elbow, it will prioritize the
    % shoulder first then move the elbow backwards
    L_e = 7.75;
    L_s = 4.125;
    elbow_weight = 1;
    sp_weight = elbow_weight * L_s / (L_s + L_e) * 0.5;
%    if(nargin < 5)
        % default:
        %   torsoYaw is 0.5
        %   torsoPitch both 0.1
        %   all others 1
        arm_weight = [0.8, sp_weight, elbow_weight, 0.1];
        joint_weights = [0.1, 0.05, 0.05, arm_weight, arm_weight];
%    end
    if(size(joint_weights, 1) > 1)
        joint_weights = joint_weights';
    end
    if(size(joint_weights, 1) > 1)
        error('InverseKinematics: joint weights must be a one dimensional vector');
    end
    
    % choose which forward kinematics output to use based on the side:
    if(strcmp(side, 'right'))
        get_point = @(a) get_R_point(a);
        joint_weights(8:11) = 0;
    elseif(strcmp(side, 'left'))
        get_point = @(a) get_L_point(a);
        joint_weights(4:7) = 0;
    else
        error('side should be either left or right');
    end
    
    currPoint = get_point(joint_angles_temp);
    dist = norm(targetXYZ - currPoint);
    
    % if already there, nothing to be done:
    if(dist <= threshold)
        new_angles = full_posture_to_partial(currJointAngles, side);
        return;
    end
    
    % joint weights should be same size as J for elementwise multiplication
    joint_weights =  diag(joint_weights);
    
    loopcount = 1;
    max_loops = 150; % break after this many loops and return the closest posture there was
    min_posture = currJointAngles;
    min_dist = dist;
    dist_history = dist; % keep track of distance over time. should always be getting closer
    posture_history = currJointAngles;
    boxsize = 8;
    
    % spatial update parameter: go in steps of a fraction of the threshold:
    
    while(dist > threshold)
        diff = (targetXYZ - currPoint);
        Beta = norm(diff) / 32;
        if(Beta > 1/64)
            Beta = 1/64;
        end
        
        joint_angles_temp
        
        J = approximate_jacobian(joint_angles_temp, get_point)
        
        currPoint
        
        ind = find([M.x] > (currPoint(1)-boxsize) & [M.x] < (currPoint(1)+boxsize) & [M.y] > (currPoint(2)-boxsize) & [M.y] < (currPoint(2)+boxsize) & [M.z] > (currPoint(3)-boxsize) & [M.z] < (currPoint(3)+boxsize))
 %       ind = []
        if isempty(ind),
            
            increment2 = zeros(7,1),
            
        else
            
            increment2 = CalculateInteraction(joint_angles_temp,10, M(ind));
            
        end
        
        %        increment2 = increment2./norm(increment2)
        
        increment2 = partial_posture_to_full(increment2', 'right')'
        
        % update joint angles
        joint_angles_temp_previous = joint_angles_temp;
        
        %        increment = (Beta * diff) * (J * joint_weights)
        increment = ((Beta * diff) * (J * joint_weights))+(Beta * norm(diff)) * increment2'
        joint_angles_temp = joint_angles_temp + increment;
        
        posture_history(loopcount+1, :) = full_posture_to_partial(joint_angles_temp, side);
        
        % if no change, nudge them a bit and try again:
        if(joint_angles_temp == joint_angles_temp_previous)
            joint_angles_temp = joint_angles_temp + ((diag(joint_weights)') / 64);
            disp('no change. nudging angles');
        end
        
        % make posture more 'natural' using a brute-force patch. just like
        % nature.
        joint_angles_temp = flip_shoulder_elbow(joint_angles_temp);
        
        currPoint = get_point(joint_angles_temp);
        
        path(loopcount,:) = currPoint;
        
        dist = euclidDist(currPoint, targetXYZ);
        dist_history(loopcount+1) = dist;
        if(dist < min_dist)
            min_posture = joint_angles_temp;
        end
        
        loopcount = loopcount + 1;
        if(loopcount > max_loops)
            joint_angles_temp = min_posture;
            break;
        end
    end
    
    new_angles = full_posture_to_partial(joint_angles_temp, side);
end