% Divya Gunasekaran
% Feb. 8, 2011
%
% modified by Richard Lange: August 2011
%   * now uses built in norm function, rather than a hard-coded sum of
%   squares
%
% Calculate Euclidean distance between two points in cartesian space

function d = euclidDist(point1, point2)

d = norm(point1 - point2);