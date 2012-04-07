% Richard Lange
% August 24 2011
%
% Show movement through time using Blue for first and Red for last posture

function h = plot_movement_stills(B, movement, side)
    num_postures = size(movement, 1);
    color_order = [linspace(0,1,num_postures)' zeros(num_postures,1) linspace(1,0,num_postures)'];
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