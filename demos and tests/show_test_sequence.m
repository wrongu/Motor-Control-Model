% function to visualize tests

function [] = show_test_sequence(B_orig, test_sequence, side)
    num_tests = length(test_sequence);
    w = B_orig(1).width;
    for i=1:num_tests
        fprintf('test %d\n', i);
        test = test_sequence(i);
        B = update_self_obstacles(B_orig, test.start_posture);
        close all;
        goal_pt = test.goal_point;
        obstacles = test.obstacles;
        M = length(obstacles);
        for j=1:M
            obstacle = obstacles(j);
            B = points_to_obstacles(B, obstacle_to_points(obstacle, w/2));
        end
        plot_posture(B, test.start_posture, side, 2);
        hold on;
        plot3(goal_pt(1), goal_pt(2), goal_pt(3), 'Marker', 'o', 'MarkerFaceColor', 'k')
        hold off;
        title(['test ' num2str(i) ': ' num2str(M) ' obstacles']);
        pause;
    end
end