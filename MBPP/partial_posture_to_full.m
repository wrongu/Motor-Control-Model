% Richard Lange
% August 8, 2011
% postures are saved as 7 joints and the side they apply to. this function
% takes this information and returns the full 11-joint posture for the
% whole robot (filling in extra space with zeros)
%
% fullPosture(1:3) = base, torso
% fullPosture(4:7) = right shoulder and elbow
% fullPosture(8:11) = left shoulder and elbow

function fullPosture = partial_posture_to_full(posture, side)
    [~, ~, ~, ideal] = get_servo_info();
    
    % go from posture on one side to full posture
    if(strcmp(side,'right'))
        padding = ideal(8:11);
        fullPosture = [posture(1:7), padding];
    elseif(strcmp(side,'left'))
        padding = ideal(4:7);
        fullPosture = [posture(1:3), padding, posture(4:7)];
    else 
        disp('Error: Please enter right or left for side');
        return;
    end
    assert(length(fullPosture)==11);
end