close all;
if(~exist('B', 'var'))
    initMBPP;
    B = fillSelfObstacles(B);
end
posture1 = generatePosture();
posture1(1:3) = 0;
posture2 = flip_shoulder_elbow(posture1);
plot_movement_stills(B, [posture1; posture2], side);