% Richard Lange
% August 17, 2011
%
% reduce full posture for partial posture on a side. This function is
% useful for generalizing other code where a definition of 'side' is
% required.

function partial_p = full_posture_to_partial(posture, side)
    if(strcmp(side, 'right'))
        partial_p = posture(1:7);
    else
        partial_p = [posture(1:3) posture(8:11)];
    end
end