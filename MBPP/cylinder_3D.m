% cylinder_3D: generate points on the surface of a 3D cylinder
%
% Richard Lange
% October 13, 2011
%
% Generate 3D points in a cylinder on the given axis at the given point,
% where the distance between adjacent points is less than the given
% resolution. The cylinder will span the length of axis perfectly

function [points x y z] = cylinder_3D(axis, radius, offset, resolution)
    vert_divisions = floor(norm(axis)/resolution) + 1;
    circumference = abs(2*pi*radius);
    angle_divisions = floor(circumference/resolution) + 1;
    
    % use built-in function to get unit cylinder with proper number of
    % divisions
    [x2 y2 z2] = cylinder(ones(1, vert_divisions), angle_divisions);
    
    % flatten point matrices to vectors
    x = reshape(x2, 1, numel(x2));
    y = reshape(y2, 1, numel(y2));
    z = reshape(z2, 1, numel(z2));
    
    % scale up
    x = x*radius;
    y = y*radius;
    z = z*norm(axis);
    
    % rotate
    points = [x; y; z];
    axis = axis/norm(axis);
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