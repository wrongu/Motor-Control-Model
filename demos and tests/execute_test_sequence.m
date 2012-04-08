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
level_stats_ind_trial_start = 1;
probcond = [];

Mov = [];

test_num = 1;
test_ind = 1;
while test_num <= num_tests
    %    clc;
    try 
        %t = cputime;
        fprintf('=========================\n   TEST %d of %d (%d+%d)\n=========================\n\n', test_num, num_tests, length(test_sequence), length(probcond));
        test = test_sequence(test_ind);
        B = update_self_obstacles(B_orig, test.start_posture);
        targetXYZ = test.goal_point;
        
        obstacles = test.obstacles;
        numobs = length(obstacles);
        for j=1:numobs
            obstacle = obstacles(j);
            B = points_to_obstacles(B, obstacle_to_points(obstacle, w/2));
        end
        
        curPosture = test.start_posture;
        level_stats_ind_trial_start = level_stats_index;
        MainController;
        
        %save Results4 level_time_stats test_sequence
        
        %if cputime - t > 150
        %    ghdfhfdhd
        %end
        
    catch e
        fprintf('error occured on trial %d\n', test_num);
        % splice out error test, add to 'failed' tests
        % step index backwards since test ind+1 is now at ind
        probcond = [probcond; test];
        test_sequence = [test_sequence(1:test_ind-1); test_sequence(test_ind+1:end)];
        test_ind = test_ind - 1;
        level_stats_index = level_stats_ind_trial_start;
        fprintf('after splicing, %d tests total\n', length(test_sequence));
    end
    test_num = test_num + 1;
    test_ind = test_ind + 1;
end

level_time_stats = level_time_stats(1:level_stats_index+1, :);