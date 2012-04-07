% rectangle_3D: generate points in a solid 3D rectangle
%
% Richard Lange
% October 13, 2011
%
% dimensions(1) = width = x
% dimensions(2) = length = y
% dimensions(3) = height= z
%
% offset = after rotation, offset from origin
%
% rotated_z_axis = [x' y' z'] = normal to xy face of rectangle. rotation
% calculated from this
%
% resolution = spacing between points

function [points x y z] = rectangle_3D(dimensions, offset, rotated_z_axis, resolution)
    
    x_divisions = floor(dimensions(1)/resolution) + 1;
    y_divisions = floor(dimensions(2)/resolution) + 1;
    z_divisions = floor(dimensions(3)/resolution) + 1;
    
    xs = linspace(0, dimensions(1), x_divisions);
    ys = linspace(0, dimensions(2), y_divisions);
    zs = linspace(0, dimensions(3), z_divisions);
    
    % fill space with xyz points
    points = setprod(xs, ys, zs)';
    
    % rotate
    axis = rotated_z_axis/norm(rotated_z_axis);
    if(~all(axis == [0 0 1]))
        rotation_axis = cross([0 0 1], axis);
        angle = acos(dot(axis, [0 0 1]));
        points = rotationmat3D(angle, rotation_axis) * points;
    end
    
    % get back points, add offset
    x = points(1,:) + offset(1);
    y = points(2,:) + offset(2);
    z = points(3,:) + offset(3);
    
    points = [x; y; z];
end