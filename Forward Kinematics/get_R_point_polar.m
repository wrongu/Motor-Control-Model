% Richard Lange
% August 17, 2011
%
% get point of right gripper using ForwardKinematics. This function is
% useful for generalizing other code where a definition of 'side' is
% required.

function rpoint = get_R_point_polar(joint_angles)

    [~,~,~,~,rpolar] = ForwardKinematics_V5(joint_angles);
    
    rpoint = rpolar(1,:);

end