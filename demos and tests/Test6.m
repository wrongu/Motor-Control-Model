clear all
init

% TEST 6
% from zero'd position, obstacle in front of right arm
curPosture = zeros(1,7)
targetXYZ = [13 0 7];
%targetXYZ = [4 0 7];
side = 'right';
task = 'reaching';
speed = 20;
use_robot = false;

level_time_stats = zeros(8,3);
level_stats_index = 1;

[pts, ~, ~, ~] = rectangle_3D([6, 4, 6], [5, -13, 5], [0 0 1], 0.5);
B = points_to_obstacles(B_orig, pts', get_obstacle_flag('world'));
[pts, ~, ~, ~] = ring_3D(5,[1 0 0], [8, -3, 5], 0.5);
B = points_to_obstacles(B, pts', get_obstacle_flag('world'));

MainController;

if(taskTable.loadFactor >= 1)
    taskTable = resize(taskTable);
end