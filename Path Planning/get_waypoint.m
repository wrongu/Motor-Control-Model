% Richard Lange
% September 27, 2011
% 
% given 2 points, gets the center of mass of all obstacles between the
% points. Then, if 
%
% outputs:
%   way_point: [x y z] new point
%   success:
%       0 - no need to recurse. line of sight worked.
%       1 - recurse on [pointA; way_point]
%       2 - recurse on [way_point; pointB]
%       3 - recurse on both (neither Line of Sight was open)
%       4 - no point found anywhere


function [way_point success] = get_waypoint(B, pointA, pointB, location, radius_limit, preferred_direction)

    % default to halfway between pointA and pointB
    if(nargin < 4)
        location = 0.5;
    end
    if(nargin < 5)
        radius_limit = 7;
    end
    
    n = size(B, 1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    
    dist = euclidDist(pointA, pointB);
    if dist==0
        way_point = pointA;
        return;
    end
    
    normal = (pointB-pointA)/dist;
    
    start_point = pointA + normal * dist * location;
    
    % now have start point, which is along the segment AB at the point of
    % highest concentration of obstacles
    
    % continue outward by default
    if(nargin < 6)
        % default: preferred direction is vector back to origin
        preferred_direction = -start_point;
    end
    
    % check linear independence of preferred direction and plane normal:
    if(dot(preferred_direction/norm(preferred_direction), normal) == 0)
        % linearly dependent. use second choice of direction in an dup
        preferred_direction = [start_point(1)-3, start_point(2), start_point(3)+3];
    end
    
    % normal vector to the plane in which we'll generate points is normal
    % To generate a circle of points in this plane, we need a starting
    % vector that is perpendicular to normal, and close to the preferred
    % direction. this is achieved by projecting the preferred direction
    % onto the plane:
    
    perp_v = preferred_direction - dot(preferred_direction, normal) * normal;
    perp_v = perp_v/norm(perp_v);
    
    best_point = [];
    best_score = 0;
    v1 = perp_v;
    v2 = perp_v;
    success = 0;
    % once free point is found, increase radius by extra_space and return
    %   OUTDATED: nudge_point function now accomplishes something similar
    %   in a more intelligent way
    extra_space = 0; 
    
    
    % rotation matrices that go around the normal vector of the plane, in
    % each direction (check both sides of preferred direction
    % simultaneously)
    circle_divisions = 8;
    angle_step = 2*pi/circle_divisions;
    rot_mat_1 = rotationmat3D(angle_step, normal)';
    rot_mat_2 = rotationmat3D(-angle_step, normal)';
    
    % loop over points in a circle in the plane, and multiple circles of
    % different radii. use first point where there is a line of sight from 
    % both pointA and pointB, but store first free point found in case no
    % LoS
    %
    % test along radii in preferred direction, then increment angle, then
    % move outward from center again.
    for angle = 1 : ceil(circle_divisions/2)
        for radius = 0 : w : radius_limit
            % direction 1:
            test_point = start_point + radius*v1;
            this_score = 0;
            % score incremented for point free and for each line of sight
            if(~B(findCell(test_point,n,w,l,h)).obstacle)
                this_score = 2;
            end
            if(line_of_sight(B, pointA, test_point))
                this_score = this_score + 1;
            end
            if(line_of_sight(B, pointB, test_point))
                this_score = this_score + 1;
            end
            
            fprintf('point (%s)\tscore: %d\n', num2str(test_point), this_score);
            
            if(this_score == 4)
                % met all criteria: free space, 2 lines of sight
                way_point = test_point + extra_space*v1;
                way_point = nudge_point(B, way_point, 1);
                return;
            elseif(this_score > best_score)
                % did not meet full criteria, but met some: keep track of
                % best option so-far
                best_point = test_point + extra_space*v1;
                best_score = this_score;
            end
            
            % direction 2:
            test_point = start_point + radius*v2;
            this_score = 0;
            % score incremented for point free and for each line of sight
            if(~B(findCell(test_point,n,w,l,h)).obstacle)
                this_score = 2;
            end
            if(line_of_sight(B, pointA, test_point))
                this_score = this_score + 1;
            end
            if(line_of_sight(B, pointB, test_point))
                this_score = this_score + 1;
            end
            
            fprintf('point (%s)\tscore: %d\n', num2str(test_point), this_score);
            
            if(this_score == 4)
                % met all criteria: free space, 2 lines of sight
                way_point = test_point + extra_space*v2;
                way_point = nudge_point(B, way_point, 1);
                return;
            elseif(this_score > best_score)
                % did not meet full criteria, but met some: keep track of
                % best option so-far
                best_point = test_point + extra_space*v2;
                best_score = this_score;
            end
        end
        % each vector is rotated in its own direction (one CW, one CCW)
        v1 = v1 * rot_mat_1;
        v2 = v2 * rot_mat_2;
    end
    
    % no point found that has all line of sight free. use first free point.
    if(~isempty(best_point))
        disp('get_waypoint: no point found with 2 lines of sight. using best score');
        fprintf('top score: %d\n', best_score);
        way_point = best_point;
        way_point = nudge_point(B, way_point, 1);
        % 'success' is defined by which segments need to be re-waypoint-ed
        % check line of sight on each:
        % (see comments at top for how values of 'success' are defined)
        if(~line_of_sight(B, pointA, way_point))
            success = 1;
        end
        if(~line_of_sight(B, pointB, way_point))
            success = success + 2;
        end
        return;
    end
    
    % nothing found
    way_point = pointA;
    success = 4;
end
