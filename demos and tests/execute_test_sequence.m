% execute test sequence, get stats
% variables required to execute this script:
%   test_sequence

use_robot = false;
%refresh;
task = 'reaching';
side = 'right';
numobs = [];
num_tests = size(test_sequence,1);

level_time_stats = zeros(8*num_tests, 3);
level_stats_index = 1;
probcond = [];

Mov = [];

for test_num = 1:num_tests
    %    clc;
    try 
        t = cputime;
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
        
        MainController;
        
        highestlevel(test_num) = hlevel;
        
%        level_stats_index = level_stats_index+1;
        
        save Results4 level_time_stats test_sequence
        
        if cputime - t > 150
            ghdfhfdhd
        end
        
     catch
         probcond = [probcond, test_num];
         fprintf('error occured on trial %d\n', test_num);
     end
end