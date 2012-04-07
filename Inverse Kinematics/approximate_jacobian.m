% Richard Lange
% August 17, 2011
%
% get an approximate jacobian matrix given the current joint angles and the
% _function_ that maps from joint angles to a position in space (different
% for left and right grippers. Also this makes it generalizable to other
% arm linkages). get_pt_func should return a single row of values

function J = approximate_jacobian(angles, get_pt_func)
    
    zero_pt = get_pt_func(angles)';
   
    J = zeros(length(zero_pt), length(angles));
    
    delta_angle = pi/32; % a small change in radians
    
    for i = 1:length(angles);
        angles_inc = angles;
        angles_inc(i) = angles_inc(i) + delta_angle;
        pt_inc = get_pt_func(angles_inc);
        delta_pt = pt_inc' - zero_pt;
        partial_deriv = delta_pt / delta_angle;
        J(:, i) = partial_deriv;
    end
end