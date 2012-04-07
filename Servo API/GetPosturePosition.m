%Divya Gunasekaran
%May 7, 2011

%Get xyz position of a posture given currAngles and side
%currAngles is a vector of 7 joint angles
%Returns row vector representing xyz position

function currXYZ = GetPosturePosition(currAngles, side)

if(~isempty(currAngles))
    fullPos = partial_posture_to_full(currAngles, side);
    [rp, lp, ~, ~] = ForwardKinematics_V5(fullPos);
    if(strcmp(side,'right'))
        currXYZ = rp;
    elseif(strcmp(side,'left'))
        currXYZ = lp;
    end
else
%     disp('Error: Given vector of angles is empty');
    currXYZ = [];
end