% Richard Lange
% September 29, 2011
%
% This function returns true if there is no obstruction between the two
% given points
%
% INPUTS:
%   B = see initMBPP
%   points A and B = 1x3; [x y z]; endpoints of segment along which line of sight
%   will be tested
%   spacing = distance between points to check (w/2 default)
%
% OUTPUTS:
%   is_clear: boolean
%   location: a number between 0 and 1 giving the location of the largest
%   cluster of obstacles, where 0 means pointA, 1 means pointB, 0.5 is
%   halfway between them, etc.

function [is_clear, location] = line_of_sight(B, pointA, pointB, spacing)
    is_clear = 1;
    
    n = size(B, 1);
    w = B(1).width;
    h = B(1).height;
    l = B(1).length;
    
    if(nargin < 4)
        spacing = w/2;
    end
    
    dist = euclidDist(pointA, pointB);
    divisions = dist/spacing;
    
    xs = [linspace(pointA(1), pointB(1), divisions), pointB(1)]';
    ys = [linspace(pointA(2), pointB(2), divisions), pointB(2)]';
    zs = [linspace(pointA(3), pointB(3), divisions), pointB(3)]';
    
    test_pts = [xs ys zs];
    
    % keep track of obstacles and largest cluster size
    largest_cluster_size = 0;
    largest_cluster_id = -1;
    this_cluster_size = 0;
    this_cluster_id = 1;
    obstacles = zeros(size(xs));
    % loop down line segment
    for i = 1:length(xs)
        test_pt = test_pts(i, :);
        [~,~,~,test_ind] = findCell(test_pt, n, w, l, h);
        
        % while still finding obstacles, all tagged with same id
        if(B(test_ind).obstacle ~= 0)
            obstacles(i) = this_cluster_id;
            this_cluster_size = this_cluster_size + 1;
            if(this_cluster_size > largest_cluster_size)
                largest_cluster_size = this_cluster_size;
                largest_cluster_id = this_cluster_id;
            end
        else
            this_cluster_id = this_cluster_id + 1;
        end
    end
    
    avg_index = mean(find(obstacles == largest_cluster_id));
    if(isnan(avg_index))
        location = 0;
    else
        location = avg_index / length(xs);
    end
    
    if(largest_cluster_size > 0)
        is_clear = 0;
    end
    
end