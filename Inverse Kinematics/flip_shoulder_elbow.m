% Richard Lange
% August 22, 2011
%
% flip_shoulder_elbow.m
%
% given a full posture (1x11), if in a state of reaching forward with
% "unnatural" shoulder/elbow combinations, flip them. More specifically, if
% the elbow is protruding forwards but the gripper is behind, it should
% flip so the elbow is behind the gripper.
%
% this is a patch to a specific bug where the IK algorithm tends to prefer
% the shoulder first then correct with the elbow, often causing unneeded
% collisions of the elbow with the cameras.
%
% A more elegant fix may be to add another parameter to the planning of
% motion: pointing-direction of the arm, which could be computed in the jacobian
% matrix along with the position, and the requirement could be that it
% points generally forward (or spec. based on category)

function adjusted_posture = flip_shoulder_elbow(full_posture)
    adjusted_posture = full_posture;
    [~, ~, rjoints, ljoints] = ForwardKinematics_V5(full_posture);

    % Right side
    right_shoulder_pitch = full_posture(5);
    right_elbow = full_posture(6);
    if(right_shoulder_pitch < 0 && right_elbow > 0)
        % unit vector pointing from RSP to gripper
        shoulder_to_gripper = rjoints(1,:) - rjoints(3,:);
        shoulder_to_gripper = shoulder_to_gripper / norm(shoulder_to_gripper);
        % unit vector pointing from RSP to elbow
        shoulder_to_elbow = rjoints(2,:) - rjoints(3,:);
        shoulder_to_elbow = shoulder_to_elbow / norm(shoulder_to_elbow);
        % cos(angle) between two vectors is their normalized dot product
        anglediff = acos(dot(shoulder_to_gripper, shoulder_to_elbow));
        % correct RSP by anglediff to the other side, elbow is mirrored
        adjusted_posture(5:6) = [adjusted_posture(5) - 2*anglediff, -right_elbow];
    end
    
    % Left side
    left_shoulder_pitch = full_posture(9);
    left_elbow = full_posture(10);
    if(left_shoulder_pitch > 0 && left_elbow < 0)
        % vector from LSP to gripper
        shoulder_to_gripper = ljoints(1,:) - ljoints(3,:);
        shoulder_to_gripper = shoulder_to_gripper / norm(shoulder_to_gripper);
        % vector from LSP to elbow
        shoulder_to_elbow = ljoints(2,:) - ljoints(3,:);
        shoulder_to_elbow = shoulder_to_elbow / norm(shoulder_to_elbow);
        % cos(angle) between two vectors is their normalized dot product
        anglediff = acos(dot(shoulder_to_gripper, shoulder_to_elbow));
        % correct LSP by anglediff to the other side, elbow is mirrored
        adjusted_posture(9:10) = [adjusted_posture(9) + 2*anglediff, -left_elbow];
    end
end