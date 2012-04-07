% points = obstacle_to_points(obstacle, spacing)
%
% given obstacle struct, return points

function points = obstacle_to_points(obstacle, spacing)
    switch(obstacle.type)
        case 'box'
            points = rectangle_3D(obstacle.dimensions, obstacle.offset, ...
                obstacle.axis, spacing);
        case 'ring'
            points = ring_3D(obstacle.dimensions(1)/2, obstacle.axis, ...
                obstacle.offset, spacing);
        case 'cylinder'
            points = cylinder_3D(obstacle.axis, obstacle.dimensions(1)/2,...
                obstacle.offset, spacing);
        case 'line'
            points = line_3D(obstacle.offset, ...
                obstacle.offset+obstacle.axis, spacing);
        otherwise
            error(['obstacle_to_points: given obstacle type is %s.' ...
                '\nmust be box, ring, cylinder, or line'], obstacle.type);
    end
    points = points';
end