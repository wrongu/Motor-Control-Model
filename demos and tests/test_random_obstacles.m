% Richard Lange
% October 13, 2011
%
% test random obstacle generation

refresh;
%B = fillSelfObstacles(B);

% while(1)
%     close all;
%     B2 = add_random_obstacle(B, 4, 1.5, 8);
%     plot_obstacles(B2);
%     pause;
% end

while(1)
    close all;
    obs = obstacle_new(4, 1.5, 8);
    B = points_to_obstacles(B_orig, obstacle_to_points(obs,B(1).width/2));
    plot_obstacles_color(B);
    pause;
end