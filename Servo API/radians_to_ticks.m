% Richard Lange
% November 15, 2011
%
% convert radians to ticks

function tick = radians_to_ticks(radians,tick_zero)
   	tick = tick_zero+radians*180/pi*1024/300;
end