% Richard Lange
% August 10, 2011
%
% plot a posture in the 3D cell space along with any obstacles
%
% include_obs:
%   0 - no obs
%   1 - show all same color
%   2 - show different obs different colors (takes longer)

function fig_out = plot_posture(B, posture, side, include_obs, fig_in)
if(nargin < 4)
    include_obs = 1;
end

if(nargin < 5)
    fig_in = figure();
end

if(include_obs == 1)
    fig_out = plot_obstacles(B, fig_in);
elseif(include_obs == 2)
    fig_out = plot_obstacles_color(B, fig_in);
else
    fig_out = fig_in;
end

hold all;

if(~strcmp(side, 'full'))
    posture = partial_posture_to_full(posture,side);
end

[~, ~, rjoints, ljoints] = ForwardKinematics_V5(posture);

rxs = rjoints(:,1);
rys = rjoints(:,2);
rzs = rjoints(:,3);

lxs = ljoints(:,1);
lys = ljoints(:,2);
lzs = ljoints(:,3);

plot3(rxs, rys, rzs, 'Color', [0 0 0.8], 'marker', '+'); % right is blue
plot3(lxs, lys, lzs, 'Color', [0.8 0 0], 'marker', '+'); % left is red

axis square;

hold off;

end