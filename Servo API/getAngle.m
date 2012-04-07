%Divya Gunasekaran
%Jan 31, 2010
%Robot functions

%Function to get angle in radians for the given servo

function [rad ticks] = getAngle(sock, servo, zero)

%Query robot for position of servo
str = [servo, '.position'];
resp = sendStr(sock, str, Inf, false);

n = length(resp); %Length of string returned by robot
index = strfind(resp, ']') + 2; %starting index of position

posStr = resp(index:n); %get position as a string
ticks = str2double(posStr); %convert string to number

%Convert position to angle
deg = (ticks-zero)*300/1024;  %degrees
rad = deg*pi/180;   %radians (better for trig calculations)

end