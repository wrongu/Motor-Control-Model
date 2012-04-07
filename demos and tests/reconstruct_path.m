% Richard Lange
% August 8, 2011

% given movement, reconstruct path using forward kinematics

function path_IK = reconstruct_path(movement, side)
    numPostures = size(movement, 1);
    path_IK = zeros(numPostures, 3);
    
    for i = 1:numPostures
        posture = partial_posture_to_full(movement(i,:), side);
        if(strcmp(side, 'right'))
            pos = ForwardKinematics_V5(posture);
        else
            [~,~,pos] = ForwardKinematics_V5(posture);
        end
        path_IK (i,:) = pos;
    end
end

function fullPosture = partial_posture_to_full(posture, side)
    fullPosture = zeros(1, 11);
    padding = zeros(1,4);
    % go from posture on one side to full posture
    if(strcmp(side,'right'))
        fullPosture = [posture, padding];
    elseif(strcmp(side,'left'))
        fullPosture = [posture(1:3), padding, posture(4:7)];
    else 
        disp('Error: Please enter right or left for side');
        return;
    end
end