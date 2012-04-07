% Richard Lange
% August 17, 2011
%
% get point of left gripper using ForwardKinematics. This function is
% useful for generalizing other code where a definition of 'side' is
% required.

function lpoint = get_L_point(joint_angles)

    [~, lpoint ,~,~] = ForwardKinematics_V5(joint_angles);

end