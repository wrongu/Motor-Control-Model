% Richard Lange
% October 25, 2011
%
% function to plot 3 lines (one parallel to each axis) that goes through a
% given point, on the given axes.

function fig_out = plot_3D_axes_thru_point(point, range, fig_in)
if(nargin < 3)
    fig_out = figure();
else
    fig_out = figure(fig_in);
end

if(nargin < 2)
    range = [-10 10];
end

x = point(1);
y = point(2);
z = point(3);

hold on;
line(x+range, [y y], [z z], 'LineStyle', '--', 'Color', [0 0 0]);
line([x x], y+range, [z z], 'LineStyle', '--', 'Color', [0 0 0]);
line([x x], [y y], z+range, 'LineStyle', '--', 'Color', [0 0 0]);
hold off;