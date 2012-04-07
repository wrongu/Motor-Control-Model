% Richard Lange
% October 10, 2011
%
% INPUTS
%   sock: pnet socket connection
%   speed: speed of servos
%   range: range for servo to travel in ticks *not* radians.
%       (zero-range/2 to zero+range/2)
%
% OUTPUTS:
%   radians_per_sec: vector of radians per sec

function radians_per_sec = get_servo_time_stats(sock, speed, range, sleep_time)

    tolerance = 10;

    if(nargin < 4)
        sleep_time = 0.05;
        if(nargin < 3)
            range = 300;
        end
    end

    zero_servos(sock);
    pause(4);

    [all_bounds, zeros, servoNames, ~] = get_servo_info();
    
    rads = zeros(size(servoNames));
    times = zeros(size(servoNames));
    
    for i=1:length(servoNames)
        servo = servoNames{i};
        % test just one torsopitch. for torsopitchtwo, copy stats from 1:
        if(~isempty(findstr(servo,'TorsoPitchTwo')))
            rads(i) = rads(i-1);
            times(i) = times(i-1);
            continue;
        end
        zero = zeros(i);
        bounds = all_bounds{i};
        range_hi = min([zero+range/2, max(bounds)]);
        range_lo = max([zero-range/2, min(bounds)]);
        rads(i) = ticks_to_radians(abs(range_hi-range_lo));
        
        fprintf('\ntesting servo:\t%s\n', servo);
        
        % set speed
        sendStr(sock, [servo '.speed=' num2str(speed)], Inf, false);
        % go to lo position
        sleep_movement(sock, servo, range_lo, sleep_time, tolerance);
        % time movement hi
        t1 = sleep_movement(sock, servo, range_hi, sleep_time, tolerance);
        % time movement lo
        t2 = sleep_movement(sock, servo, range_hi, sleep_time, tolerance);
        % set back to zero
        sleep_movement(sock, servo, zero, sleep_time, tolerance);
        % record average of 2 times
        times(i) = (t1+t2)/2;
    end
    
    radians_per_sec = rads./times;
    
end