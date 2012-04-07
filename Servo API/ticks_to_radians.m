% Richard Lange
% October 10, 2011
%
% convert ticks to radians

function rad = ticks_to_radians(ticks)
    rad = ticks*300/1024*pi/180;
end