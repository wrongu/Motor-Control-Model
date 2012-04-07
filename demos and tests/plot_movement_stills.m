% Richard Lange
% August 24 2011
%
% Show movement through time using Blue for first and Red for last posture
%
% April 7, 2012: added color_segment_indices functionality so that blocks
% of movement can be colored the same (no gradient)

function h = plot_movement_stills(B, movement, side, color_segment_indices, colors)
    num_postures = size(movement, 1);
    color_order = [linspace(0,1,num_postures)' zeros(num_postures,1) linspace(1,0,num_postures)'];
    if(nargin > 3)
        if(nargin < 5)
            colors = [[0.8 0 0]; [0 0.8 0]; [0 0 0.8]; [0.8 0.8 0]; [0 0.8 0.8]; [0.8 0 0.8]];
        end
        color_order = zeros(num_postures, 3);
        color_segment_indices = [1, color_segment_indices, num_postures];
        for i = 1:length(color_segment_indices)-1
            colors_ind = mod(i-1, length(colors))+1;
            posture_inds = color_segment_indices(i):color_segment_indices(i+1);
            disp('coloring postures in range')
            disp(posture_inds);
            disp('with color')
            disp(colors(colors_ind, :))
            color_order(posture_inds, :) = repmat(colors(colors_ind, :), length(posture_inds), 1);
        end
    end
    h = plot_obstacles_color(B);

    hold all;
    
    for i = 1:num_postures
        if(~strcmp(side, 'full'))
            posture = partial_posture_to_full(movement(i,:),side);
        else
            posture = movement(i,:);
        end

        [~, ~, rjoints, ljoints] = ForwardKinematics_V5(posture);

        rxs = rjoints(:,1);
        rys = rjoints(:,2);
        rzs = rjoints(:,3);

        lxs = ljoints(:,1);
        lys = ljoints(:,2);
        lzs = ljoints(:,3);
        
        if(strcmp(side, 'right') || strcmp(side, 'full'))
            plot3(rxs, rys, rzs, 'marker', '+', 'Color', color_order(i,:));
        end
        if(strcmp(side,'left') || strcmp(side, 'full'))
            plot3(lxs, lys, lzs, 'marker', '+', 'Color', color_order(i,:));
        end
    end
    
    axis square;
    hold off;
    
end