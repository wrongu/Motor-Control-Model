% execute test sequence, get stats
% variables required to execute this script:
%   test_sequence

use_robot = false;
%refresh;
task = 'reaching';
side = 'right';
numobs = [];
num_tests = size(test_sequence);

level_time_stats = zeros(8*num_tests, 3);
level_stats_index = 1;
probcond = [];

for test_num = 1:num_tests
    
    test_num
    %    clc;
    try

        fprintf('==================\n\tTEST %d\n==================\n\n', test_num);
        test = test_sequence(test_num);
        B = update_self_obstacles(B_orig, test.start_posture);
        targetXYZ = test.goal_point;
        
        obstacles = test.obstacles;
        numobs = length(obstacles);
        for j=1:numobs
            obstacle = obstacles(j);
            B = points_to_obstacles(B, obstacle_to_points(obstacle, w/2));
        end
        
        curPosture = test.start_posture;
        
        curPostureFull = partial_posture_to_full(curPosture,side);
        
        [path,movement,tElapsed,Bmod] = A_ComputePath(curPostureFull,targetXYZ,B,thresh)
        
        goodtests = [goodtests; test_sequence(test_num)]
        
        save GoodTrials test_num goodtests
        
        close all

     catch
         probcond = [probcond, test_num];
     end
end