% Richard Lange
% November 15 2011
%
% function to convert from (time and radians) to a speed for a given servo.
% This uses the *saved* stats generated by calibrate_servo_speeds.
%
% usage:
%   servo_controller = load('servo_stats_<robot number>', 'rps_to_speed')
%   servo_controller = servo_controller.rps_to_speed;
%   servospeed = get_speed_by_dist_time(rad, t, name, servo_controller)

function[speed] = get_speed_by_dist_time(radians, seconds, servoName, servo_controller)
    
    if(~isfield(servo_controller,servoName))
        servoName = 'mean';
    end
    
    radians_per_sec = radians/seconds;
    
    poly = servo_controller.(servoName);
    
    speed_min = 20;
    speed_max = 85;
    
    speed = polyval(poly, radians_per_sec);
    speed = round(speed);
    speed = min(speed, speed_max);
    speed = max(speed_min, speed);
    
    if(speed == speed_min || speed == speed_max)
        fprintf('speed capped at %d for servo %s\n', speed, servoName);
    end
end