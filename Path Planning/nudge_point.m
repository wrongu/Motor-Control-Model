% Richard Lange
% October 18, 2011
%
% helper function to move point away from immediate obstacles. Works by
% averaging the location of immediate obstacles and moving in the opposite
% direction of that center-of-mass.

function new_point = nudge_point(B, point, weight)
    % default to no change:
    new_point = point;

    n = size(B,1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    
    % get index of point
    [i0 j0 k0] = findCell(point, n, l, w, h);
    
    % obstacles in immediate 3x3x3 cube (in row vector):
    imm_obs = [B(i0-1:i0+1, j0-1:j0+1, k0-1:k0+1).obstacle];
    
    if(any(imm_obs))
        % obstacles in same 3x3x3 cube, indexed by i, j, k:
        [i_inds j_inds k_inds] = ind2sub([3 3 3], find(imm_obs));

        % average opposite direction of these indices to get "nudge" direction
        % of the point.
        % Opposite direction b/c the mapping from inds to direction is:
        %   index 1 ==> direction -1
        %   index 2 ==> direction 0
        %   index 3 ==> direction 1
        %
        % thus to get the direction, take (index - 2). to reverse it, (2 -
        % index), as seen below.
        %
        % since the average of 2 points is the same as the average of each of
        % their components, the mean can be taken on each index independently.
        %
        % lastly, since we're using unit space (one cell away = 1 spacing),
        % multiply by weight to go from unit cell coordinates to inches.


        i_nudge = mean((2-i_inds)*weight);
        j_nudge = mean((2-j_inds)*weight);
        k_nudge = mean((2-k_inds)*weight);

        new_point = new_point + [i_nudge j_nudge k_nudge];
    end
end