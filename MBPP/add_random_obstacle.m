% Richard Lange
% Random Obstacles
%
% inputs:
%   B (see initMBPP)
%   min_dim = smallest dimension of the obstacle
%   max_dim = largest dimension of the obstacle

% this function was created before an obstacle struct was define.
%   see obstacle_new.m
function B = add_random_obstacle(B, min_dim, max_dim, max_off)
    n = size(B,1);
    w = B(1).width;
    
    % size of space
    space_width = n*w;
    
    if(nargin < 3)
        max_dim = space_width/4;
        if(nargin < 2)
        	min_dim = 4;
        end
    end
    
    types = 4;
    type = floor(rand*types);    

    
    % generate here for readability
    random_nums = rand(1, 6)*2-1;
    % use the 6 random nums as different features of the random shapes:
    axis = [random_nums(1) random_nums(2) random_nums(3)]*(max_dim-min_dim) + min_dim;
    %    make offset weighted towards outside by square-rooting
    xoff = sign(random_nums(4))*sqrt(abs(random_nums(4)))*max_off;
    yoff = sign(random_nums(5))*sqrt(abs(random_nums(5)))*max_off;
    zoff = sign(random_nums(6))*sqrt(abs(random_nums(6)))*max_off;
    offset = [xoff yoff zoff];
    res = w/2;
    radius = (rand*(max_dim-min_dim) + min_dim)/2;
    
    % now for specifics:
    switch(type)
        case 0
            % rectangle
            xdim = rand*(max_dim-min_dim) + min_dim;
            ydim = rand*(max_dim-min_dim) + min_dim;
            zdim = rand*(max_dim-min_dim) + min_dim;
            
            pts = rectangle_3D([xdim ydim zdim], offset, axis, res);
            disp('rectangle');
            
        case 1
            % cylinder
            
            % max radius = max_dim/2
            pts = cylinder_3D(axis, radius, offset, res);
            disp('cylinder');
            
        case 2
            % line
            pts = line_3D(offset, offset+axis, res);
            disp('line');
            
        case 3
            % ring
            pts = ring_3D(radius, axis, offset, res);
            disp('ring');
        otherwise
            return
    end
    B = points_to_obstacles(B, pts');
end