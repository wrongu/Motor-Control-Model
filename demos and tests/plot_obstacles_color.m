% Richard Lange
% 3 August 2011

% plot obstacles of space B using PATCH3Darray library downloaded online.

function fig_out = plot_obstacles_color(B, fig_in)
    if(nargin < 2)
        fig_out = figure();
    else
        fig_out = figure(fig_in);
    end
    
    n = size(B,1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    
    % get all types of obstacle flags
    all_flags = get_flag_types(B);
    all_flags = all_flags(all_flags ~=0);
    num_flags = length(all_flags);
    colors = winter(num_flags);

        xs = linspace(-(n*w)/2, (n*w)/2, n);
        ys = linspace(-(n*l)/2, (n*l)/2, n);
        zs = linspace(-(n*h)/2, (n*h)/2, n);
    
    for i=1:num_flags
        obs = getObstacles(B, all_flags(i));
        if(~any(obs))
            disp('no obstacles');
            obs(1) = 1;
        end

        if(i>1)
            hold on;
        end
        
        PATCH_3Darray(obs, xs, ys, zs, 'col', colors(i,:));
        
        if(i>1)
            hold off;
        end
        
    end
    
        axis([min(xs) max(xs) min(ys) max(ys) min(zs) max(zs)]);
        xlabel('x');
        ylabel('y');
        zlabel('z');
end