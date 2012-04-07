% TEST 5
% from zero'd position, obstacle in front of right arm
targetXYZ = [11 0 7];
side = 'right';
task = 'reaching';
speed = 20;
use_robot = false;
Mov = []'

level_time_stats = zeros(8,3);
level_stats_index = 1;


[pts, ~, ~, ~] = rectangle_3D([6, 4, 6], [5, -13, 5], [0 0 1], 0.5);
B = points_to_obstacles(B_orig, pts', get_obstacle_flag('world'));

MainController;

% if(taskTable.loadFactor >= 1)
%     taskTable = resize(taskTable);
% end