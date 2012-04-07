% Richard Lange
% September 29, 2011
%
% given a path, this function returns a new path that avoids obstacles in B
% using waypoints.
%
% if obstacles_COM (center of mass) is specified as some [x y z], the 
% segments of the given path are searched for the closest to that COM. If
% the closest segment was some AB, a point C is added to the path (AB -->
% ACB) such that C is on the opposite side of AB of COM (weighted by
% 'weight')
%
% max_points_added is the max number of points that can be added before
% giving up
%
% output value 'type_wp`
%    0         if no waypoint found
%    negative  if replaced vertex (avoid given obst. COM), where index of 
%                 vertex replaced = -type_wp
%    positive  if added to segment (where i = segment num), where index of
%                 segment = type_wp

function [new_path is_valid waypoint_ind type_wp] = add_waypoints_2(B, path, obstacles_COM, weight)
    if(nargin < 5)
        weight = 0.5;
    end
    num_segments = size(path, 1) - 1;
    
    waypoint_ind = [];
    type_wp = 0;
    
    % keep track of closest object to COM (either pt or segment)
    min_seg_dist = Inf;
    
    closest_seg_ind = 0;
    COM_proj_closest_seg = [];
    
    min_pt_dist = Inf;
    closest_pt_ind = 0;
    
    
    % LOOP OVER SEGMENTS
    i = 1;
    while i <= num_segments
        fprintf('add_waypoints: checking segment %d of %d\n', i, num_segments);
        ptA = path(i, :);
        ptB = path(i+1, :);
        
        % GET CLOSEST OBJECT TO COM (segment or point)

        % check closet point:
        ptA, obstacles_COM
        this_pt_dist = euclidDist(ptA, obstacles_COM);
        if(this_pt_dist < min_pt_dist)
            closest_pt_ind = i;
            min_pt_dist = this_pt_dist;
        end

        % Check closest segment:
        %   (normal distance from obst_COM to segment AB)

        % unit vector from B to A
        unit_v = (ptA-ptB)/norm(ptB-ptA);
        % vectors from B and A to COM
        obst_v_B = obstacles_COM - ptB;
        obst_v_A = obstacles_COM - ptA;
        % <vector from B to COM> projected onto AB (triangle leg 1)
        B_COM_proj_AB = dot(unit_v, obst_v_B);
        A_COM_proj_AB = dot(-unit_v, obst_v_A);

        % If the dot of of COM with AB is positive with respect to both
        % A and B, then the projected COM will lie *between* A and B
        if(B_COM_proj_AB >= 0 && A_COM_proj_AB >= 0)

            % dist from B to COM (triangle hypotenuse)
            dist_BC = norm(obst_v_B);
            % normal dist (triangle leg 2): pythagorean theorem
            dist_norm = sqrt(dist_BC^2 - B_COM_proj_AB^2);

            % if now closest, store for use later
            if(dist_norm < min_seg_dist)
                closest_seg_ind = i;
                COM_proj_closest_seg = ptB + B_COM_proj_AB*unit_v;
                min_seg_dist = dist_norm;
            end
        end
        
        i = i+1;
    end
    
    % USE CLOSEST-FEATURE INFO TO GENERATE NEW WAYPOINT
    
    fprintf('closest vertex was index %d at dist %f\n', closest_pt_ind, min_pt_dist);
    fprintf('closest segment was number %d at dist %f\n', closest_seg_ind, min_seg_dist);
    % check which object was closer: a vertex or a segment
    if(min_pt_dist < min_seg_dist)
        % here, we know vertex was closer. we'll replace the ith index
        % of the path (the closest vertex to obstacle_COM) with a
        % waypoint
        best_test_pt = path(closest_pt_ind,:) + ...
            weight*(path(closest_pt_ind,:)-obstacles_COM);
        limit_test_pt = path(closest_pt_ind,:);
    else
        % to mirror point C across point D: D + (D-C). the following is the
        % same formula except weighted (scaled when reflected)
        best_test_pt = COM_proj_closest_seg + ...
            weight*(COM_proj_closest_seg - obstacles_COM);
        limit_test_pt = COM_proj_closest_seg;
    end


    dist = euclidDist(best_test_pt, limit_test_pt);
    num_test_pts = ceil(dist*2/B(1).width);

    % testing points on line from [best test pt] to [limit test pt]
    % use first that is free.
    test_pts = [linspace(best_test_pt(1), limit_test_pt(1), num_test_pts)', ...
        linspace(best_test_pt(2), limit_test_pt(2), num_test_pts)', ...
        linspace(best_test_pt(3), limit_test_pt(3), num_test_pts)'];

    % CHECK EACH POTENTIAL WAYPOINT FOR NO OBSTACLES
    way_pt = [];
    for p=1:num_test_pts
        [~,~,~, ind] = findCell(test_pts(p,:), size(B,1), B(1).width, ...
            B(1).length, B(1).height);
        if(ind < size(B,1)^3)
            if(~B(ind).obstacle)
                way_pt = test_pts(p,:);
                break;
            end
        end
    end

    
    % IF FOUND GOOD WAYPOINT
    if(~isempty(way_pt))
        fprintf('Added Waypoint away from obstacle COM ');
        if(min_pt_dist < min_seg_dist)
            fprintf('by replacing vertex %d\n', closest_pt_ind);
            path = [path(1:closest_pt_ind-1, :); way_pt; path(closest_pt_ind+1:end, :)];
            waypoint_ind = horzcat(waypoint_ind, closest_pt_ind);
            type_wp = -closest_pt_ind;
        else
            fprintf('by adding point to segment %d\n', closest_seg_ind);
            path = [path(1:closest_seg_ind, :); way_pt; path(closest_seg_ind+1:end, :)];
            waypoint_ind = horzcat(waypoint_ind, closest_seg_ind+1);
            type_wp = closest_seg_ind;
        end
    end
    
    is_valid = 1;
    new_path = path;
end