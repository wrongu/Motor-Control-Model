% Richard Lange
% 3 August 2011

% plot obstacles of space B using PATCH3Darray library downloaded online.

function fig_out = plot_obstacles(B, fig_in)
    if(nargin < 2)
        fig_out = figure();
    else
        fig_out = figure(fig_in);
    end
    
    n = size(B,1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    
    obs = getObstacles(B);

    xs = linspace(-(n*w)/2, (n*w)/2, n);
    ys = linspace(-(n*l)/2, (n*l)/2, n);
    zs = linspace(-(n*h)/2, (n*h)/2, n);

    PATCH_3Darray(obs, xs, ys, zs, 'col');
    axis([min(xs) max(xs) min(ys) max(ys) min(zs) max(zs)]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
end