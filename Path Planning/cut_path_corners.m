% Richard Lange
% October 11, 2011
%
% This function, given a path p, returns a new path (np) that cuts the
% corners of p where a line of sight is open.

function np = cut_path_corners(B, p)

    num_points = size(p, 1);
    np = p;
    i = 1;
    
    % loop checking each segment. if clear to 2 ahead, remove point 1 ahead
    % as long as points are being removed, i should not be incremented
    while i < num_points - 2;
        if(line_of_sight(B, np(i,:), np(i+2,:)))
            % clear path from i to i+2 ==> cut out i+1
            np = [np(1:i, :); np(i+2:end, :)];
            num_points = num_points - 1;
        else
            i = i+1;
        end
    end
end