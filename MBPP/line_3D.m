% Richard Lange
% October 13, 2011

function [points x y z] = line_3D(ptA, ptB, resolution)
    num_pts = norm(ptB-ptA)/resolution;
    
    x = linspace(ptA(1), ptB(1), num_pts);
    y = linspace(ptA(2), ptB(2), num_pts);
    z = linspace(ptA(3), ptB(3), num_pts);
    
    points = [x; y; z];
end