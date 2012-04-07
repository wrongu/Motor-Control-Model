% Richard Lange
% 3 August 2011

% given cell space B and path `path`, plot the path in 3D space along with
% the obstacles in B

function [fig_out plot_handle] = plot_path(B, path, color, fig_in)
    if(nargin < 4)
        fig_out = plot_obstacles_color(B);
    else
        fig_out = figure(fig_in);
    end
    if(nargin < 3)
        color = [1 0 0];
    end
    hold all;
    xs = path(:,1);
    ys = path(:,2);
    zs = path(:,3);
    plot_handle = plot3(xs,ys,zs,'marker','o', 'Color', color);
    hold off;
end