% Richard Lange
% July 21, 2011

% Fill the Brainbot's 3D cell representation of obstacles in its space with
% the treads. The triangular shape is more complicated than other shapes in
% the brainbot, so it is done in this separate function

% Inputs:
%   B - the Cell array of all 3D space (created in initMBPP.m)
%   method - if 1 (default), just fill bounding box of treads. if 2, fill
%   with the triangle geometry taken into account.
%   flag - the number to put in the 3D array that 'flags' the obstacle

function B = fillObstacles_Treads(B, method, flag)
    if nargin < 2
        method = 1;
    end
    
    n = nthroot(numel(B), 3);
    w = B(1,1,1).width;
    l = B(1,1,1).length;
    h = B(1,1,1).height;
    
    switch(method)
        case 1
            % Bounding Box - same method as fillSelfObstacles.m
            xlow = -4;
            xhi = 8.5;

            ylow = -7.5;
            yhi = -5.5;

            zlow = -3;
            zhi = 2;

            % right tread (neg y)

            B = points_to_obstacles(B, ...
                rectangle_3D([xhi-xlow, yhi-ylow, zhi-zlow], ...
                [xlow ylow zlow], [0 0 1], w/2)', flag);

            % left tread (pos y)
            ylow = 5.5;
            yhi = 7.5;
    
            B = points_to_obstacles(B, ...
                rectangle_3D([xhi-xlow, yhi-ylow, zhi-zlow], ...
                [xlow ylow zlow], [0 0 1], w/2)', flag);

        case 2
            % Triangle
            % Using the endpts in the (x,z) plane, fill interior by
            % stepping along the lines that connect the points then filling
            % the space between them. This is repeated for each y step.
            
            % [x, z] points:
            ptA = [5.5 -3];
            ptB = [-4.5 -3];
            ptC = [-1 2];
            
            ylow_right = -7.5;
            yhi_right = -5.5;
            y_right = [ylow_right:l:yhi_right, yhi_right];
            
            ylow_left = -yhi_right;
            yhi_left = -ylow_right;
            y_left = [ylow_left:l:yhi_left, yhi_left];
            
            y = [y_right, y_left];
            
            % normalized vectors and slopes (m = y/x) between all pairs of points:
            v_AB = ptB - ptA;
                v_AB = v_AB / norm(v_AB);
                m_AB = v_AB(2) / v_AB(1);
            v_AC = ptC - ptA;
                v_AC = v_AC / norm(v_AC);
                m_AC = v_AC(2) / v_AC(1);
            v_BC = ptC - ptB;
                v_BC = v_BC / norm(v_BC);
                m_BC = v_BC(2) / v_BC(1);
            
            x_max = max(max(ptA(1), ptB(1)), ptC(1));
            x_min = min(min(ptA(1), ptB(1)), ptC(1));
            x = [x_min:w:x_max, x_max];
            
            z_box_max = max(max(ptA(2), ptB(2)), ptC(2));
            z_box_min = min(min(ptA(2), ptB(2)), ptC(2));
            
            for j=y
                for i=x
                    % we have 3 line segments: A-B, B-C, and C-A
                    % at any given x, we need to fill the space between the
                    % z values of 2 vectors. This is done by getting the z
                    % value of the 3 line segments at some grid-value of x
                    % then selecting the 2 that are on the border of the
                    % triangle. this is done by taking the 2 points that
                    % are in the bounding box of the triangle.
                    % [(x_min, z_box_min) to (x_max, z_box_max)] 
                    z_AB = ptA(2) + (m_AB * (i - ptA(1)));
                    z_BC = ptB(2) + (m_BC * (i - ptB(1)));
                    z_CA = ptC(2) + (m_AC * (i - ptC(1)));
                    
                    z_bounds = [0 0];
                    
                    if(pt_in_box([i z_AB], z_box_max, z_box_min, x_min, x_max))
                        z_bounds(1) = z_AB;
                        if(pt_in_box([i z_CA], z_box_max, z_box_min, x_min, x_max))
                            z_bounds(2) = z_CA;
                        elseif(pt_in_box([i z_BC], z_box_max, z_box_min, x_min, x_max))
                            z_bounds(2) = z_BC;
                        end
                    else
                        z_bounds = [z_CA; z_BC];
                    end
                    
                    z_min = min(z_bounds);
                    z_max = max(z_bounds);
                    z = [z_min:h:z_max, z_max];
                    for k=z
                        [~, ~, ~, ind] = findCell([i,j,k], n, w, l, h);
                        B(ind).obstacle = flag;
                        B(ind).obstacle_locations = ...
                            vertcat(B(ind).obstacle_locations, [i j k]);
                        B(ind).obstacle_types = ...
                            horzcat(B(ind).obstacle_types, flag);
                    end
                end
            end

        otherwise
            % default to bounding box
            B = fillObstacles_Treads(B, 1, flag);
    end
end

function in = pt_in_box(pt, top, bottom, left, right)
    in = ((pt(1) >= left) & (pt(1) <= right) & (pt(2) >= bottom) & (pt(2) <= top));
end