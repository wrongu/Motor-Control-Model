% fillSelfOBstacles.m
% Richard Lange
% July 20 2011
%
% The space in which the robot's arm is free to move begins as totally open.
% Pass the memory of postures (variable 'B' from initMBPP.m) to this script
% to fill cells that intersect with the robot itself as 'obstacles'
%
% the assumption is that 0,0,0 is as labeled on the brainbot (where the
% base meets the axis of torsoYaw), and the dimensions are in inches. 
%
% to distinguish between obstacles that move when the robot changes
% position vs ones that are constant in all postures, different numbers are
% used as flags. 1 means constant obstacle, 2 means it changes as the
% torso servos change 

function B = fillSelfObstacles(B)

    dim = min([B(1).width B(1).height B(1).length]);

    % robot base:
    % a constant obstacle
    flag = get_obstacle_flag('constant');
    % x from [-5, 5] (inches)
    % y from [-5.5, 5.5]
    % z from [-2.5, 0]

    xlow = -5;
    xhi = 5;

    ylow = -5.5;
    yhi = 5.5;

    zlow = -2.5;
    zhi = 0;
    
    B = points_to_obstacles(B, ...
        rectangle_3D([xhi-xlow, yhi-ylow, zhi-zlow], ...
        [xlow ylow zlow], [0 0 1], dim/2)', flag);

    % robot body:
    % dynamic obstacle (second arg is # servos that influence these
    % positions)
    flag = get_obstacle_flag('body', 3);
    % x from [-2.5, 2]
    % y from [-2.25, 2.25]
    % z from [0,8]

    xlow = -2.5;
    xhi = 2;

    ylow = -2.25;
    yhi = 2.25;

    zlow = 0;
    zhi = 8;
    
    B = points_to_obstacles(B, ...
        rectangle_3D([xhi-xlow, yhi-ylow, zhi-zlow], ...
        [xlow ylow zlow], [0 0 1], dim/2)', flag);

    % cameras:
    % dynamic obstacle
    flag = get_obstacle_flag('body', 3);
    % x from [-1.5, 3.5]
    % y from [-3.25, 3.25]
    % z from [9,11]

    xlow = -1.5;
    xhi = 3.5;

    ylow = -3.25;
    yhi = 3.25;

    zlow = 9;
    zhi = 11;
    
    B = points_to_obstacles(B, ...
        rectangle_3D([xhi-xlow, yhi-ylow, zhi-zlow], ...
        [xlow ylow zlow], [0 0 1], dim/2)', flag);
    
    % treads (both sides):
    % constant obstacles
    flag = get_obstacle_flag('constant');
    B = fillObstacles_Treads(B, 2, flag);
    
end