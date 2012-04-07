% Richard Lange
% July 29 2011

% plot a path in 3D space

function h = plotpath(path)
    xs = path(:,1);
    ys = path(:,2);
    zs = path(:,3);
    
    h = plot3(xs, ys, zs, 'marker', 'o');
end