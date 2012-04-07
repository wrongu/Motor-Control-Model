% Richard Lange
% August 17, 2011
%
% get point of right gripper using ForwardKinematics. This function is
% useful for generalizing other code where a definition of 'side' is
% required.

function rpoint = get_R_point(joint_angles)

    [rpoint, ~,~,~] = ForwardKinematics_V5(joint_angles);

end