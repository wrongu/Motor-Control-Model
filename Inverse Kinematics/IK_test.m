% IK test

curPosture = zeros(1,11);
curPt = get_R_point(curPosture);
targetPt = curPt + [4, 4, 0];
side = 'right';
thresh = 0.5;

fprintf('starting %fin away from goal\n', euclidDist(targetPt, curPt));
[newPosture, endPt, dists, posture_attempts] = InverseKinematics(targetPt, curPosture, side, thresh);
fprintf('made it to within %fin of goal\n', euclidDist(targetPt, endPt));

newPosture = partial_posture_to_full(newPosture, side);

interp_pts = 10;
movement = zeros(interp_pts, length(curPosture));
for i = 1:length(curPosture)
    movement(:,i) = linspace(curPosture(i), newPosture(i), interp_pts)';
end

initMBPP;
B = fillSelfObstacles(B);

plot_movement_stills(B, posture_attempts, side);
hold all;
title('attempts of IK algorithm');
plot3(targetPt(1), targetPt(2), targetPt(3), 'marker', 'o', 'Color', [0 0 0]);
hold off;