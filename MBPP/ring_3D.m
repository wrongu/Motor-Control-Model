% Richard Lange
% October 13, 2011
%
% Generate points on ring (special case of cylinder)

function [points x y z] = ring_3D(radius, axis, offset, resolution)
    [points1 x1 y1 z1] = cylinder_3D(0.01*axis/norm(axis), radius, offset, resolution);
    [points2 x2 y2 z2] = cylinder_3D(0.01*axis/norm(axis), radius-resolution/2, offset, resolution);
    points = [points1, points2];
    x = [x1, x2;];
    y = [y1, y2;];
    z = [z1, z2;];
    
end