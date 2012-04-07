% Richard Lange
% October 6, 2011
%
% script to test waypoint algorithm

refresh;


ptA = [5, 0, 3];        % front middle
ptB = [-2, -4.5, 4];    % back right
ptC = [0 0 15];         % straight up

path1 = [ptA; ptB];
path2 = [ptA; ptC];
path3 = [ptB; ptC];
path4 = [ptA; ptB; ptC];

[new_path1 valid1] = add_waypoints(B, path1, 4);
[new_path2 valid2] = add_waypoints(B, path2, 4);
[new_path3 valid3] = add_waypoints(B, path3, 4);
[new_path4 valid4] = add_waypoints(B, path4, 4);
    cut_path4 = cut_path_corners(B, new_path4);

fig1 = plot_path(B, path1, [0 0 0.5]);
plot_path(B, new_path1, [0 0 1], fig1);
legend('robot', 'given points', 'waypoints');
title(['path 1: ' num2str(valid1) ' valid']);

fig2 = plot_path(B, path2, [0 0 0.5]);
plot_path(B, new_path2, [0 0 1], fig2);
legend('robot', 'given points', 'waypoints');
title(['path 2: ' num2str(valid2) ' valid']);

fig3 = plot_path(B, path3, [0 0 0.5]);
plot_path(B, new_path3, [0 0 1], fig3);
legend('robot', 'given points', 'waypoints');
title(['path 3: ' num2str(valid3) ' valid']);

fig4 = plot_path(B, path4, [0 0 0.5]);
plot_path(B, new_path4, [0 0 1], fig4);
plot_path(B, cut_path4, [1 0 0], fig4);
legend('robot', 'given points', 'waypoints', 'cut corners');
title(['path 4: ' num2str(valid4) ' valid']);

