% Richard Lange
% function to move a servo to a position and sleep until it reaches there

function [t_elapsed] = sleep_movement(sock, servo, pos, sleep_time, tolerance)
    if(nargin < 5)
        tolerance = 12;
        if(nargin < 4)
            sleep_time = 0.08;
        end
    end
    
    [~,cur_pos] = getAngle(sock, servo, 512);
    
    % send move command and start timer
    if(~isempty(findstr(servo,'TorsoPitch')))
        torso_pitch(sock, pos);
    else
        sendStr(sock, [servo '.position=' num2str(pos)], Inf, false);
    end
    tstart = tic;
    % while still moving, update reading of current position and sleep
    while(abs(pos-cur_pos) > tolerance)
        pause(sleep_time);
        [~,cur_pos] = getAngle(sock, servo, 512);
    end
    t_elapsed = toc(tstart);
end