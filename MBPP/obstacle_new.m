% obstacle = obstacle_new(min_dim, max_dim, max_off)
%
% returns 'obstacle' struct with fields:
%   type        string. 'ring', 'box', 'cylinder', or 'line'
%   offset      1x3 point indicating location
%   axis        1x3 vector giving orientation (rotated z axis for box)
%   dimensions   1x3 vector giving dimensions.
%               line: [n/a n/a n/a]
%               ring/cylinder: [diameter n/a n/a]
%               box (pre-rotation): [x-dim y-dim z-dim]

function obstacle = obstacle_new(min_dim, max_dim, max_off)
    all_types = {'box', 'ring', 'cylinder', 'line'};
    type = all_types{floor(rand*length(all_types))+1};
    
    % pick random offset
    offset = (sqrt(rand(1,3))*2-1)*max_off;
    % pick random axis by generating random spherical coord and converting
    % to cartesian
    [x y z] = sph2cart(rand*2*pi, rand*2*pi, rand*(max_dim-min_dim)+min_dim);
    axis = [x y z];
    % pick random positive dimensions
    dimensions = (rand(1,3) * (max_dim-min_dim) + min_dim);
    % flip randomly to negative dimensions
    signs = (rand(1,3)>0.5)*2 - 1;
    dimensions = dimensions .* signs;
    
    % return as a struct
    obstacle = struct('type', type, 'offset', offset, ...
        'axis', axis, 'dimensions', dimensions);
    
%     fprintf('Generated Obstacle\n');
%     disp(obstacle);
end