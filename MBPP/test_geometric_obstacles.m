% cylinder test
if(~exist('B', 'var'))
    initMBPP;
    B(1).obstacle = 1;
    %B = fillSelfObstacles(B);
end


%% CYLINDERS

[~, x y z] = cylinder_3D([4 2 0], 1, [0 0 0], 0.25);
pts = [x; y; z];
f = plot_path(B, pts');

[~, x y z] = cylinder_3D([0 0 1], 4, [-8 -10 5], 1);
pts = [x; y; z];
plot_path(B, pts', [0 0 1], f);

[~, x y z] = cylinder_3D([4 -4 -4], 6, [8 8 8], 1.5);
pts = [x; y; z];
plot_path(B, pts', [0 1 0], f);

%% RINGS

[~, x y z] = ring_3D(4, [1 1 1], [5 5 5], 1);
pts = [x; y; z];
f = plot_path(B, pts');

[~, x y z] = ring_3D(4, [0 -1 4], [-2 4 -2], 0.75);
pts = [x; y; z];
plot_path(B, pts', [0 1 0], f);

%% RECTANGLES
% lines and planes can be made from rectangles

pts = rectangle_3D([1 2 3], [0 0 0], [0 0 1], 1);
% pts = [x; y; z];
f = plot_path(B, pts');

[~, x y z] = rectangle_3D([5 5 5], [-8 0 -2], [0.5 1, -5], 1.5);
pts = [x; y; z];
plot_path(B, pts', [0 0 1], f);

pts = rectangle_3D([4 3 7], [10 10 10], [1 1 1], 1.5);
% pts = [x; y; z];
plot_path(B, pts', [0 1 0], f);