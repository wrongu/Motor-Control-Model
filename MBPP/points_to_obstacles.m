% Richard Lange
% October 13, 2011
%
% given 3D points and cell space B, adds in obstacles at the given points
%
% points should be given as Nx3

function B = points_to_obstacles(B, points, flag)
    n = size(B,1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    
    if(nargin < 3)
        flag = get_obstacle_flag('world');
    end
    
    num_points = size(points,1);
    for i = 1:num_points
        [~,~,~, ind] = findCell(points(i,:), n, w, l, h);
        if(1 <= ind && ind <= n^3)
            B(ind).obstacle = flag;
            B(ind).obstacle_locations = vertcat(B(ind).obstacle_locations, points(i,:));
            B(ind).obstacle_types = horzcat(B(ind).obstacle_types, flag);
        end
    end
end