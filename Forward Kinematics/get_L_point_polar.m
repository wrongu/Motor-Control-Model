% Richard Lange
% August 17, 2011
%
% get point of left gripper using ForwardKinematics. This function is
% useful for generalizing other code where a definition of 'side' is
% required.

% cylindrical coordinates

function lpoint = get_L_point_polar(joint_angles)

    [~,~,~,~,~,lpolar] = ForwardKinematics_V5(joint_angles);
    
    lpoint = lpolar(1,:);

end