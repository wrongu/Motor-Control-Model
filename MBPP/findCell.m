% Divya Gunasekaran
% October 19, 2010

% Function to find the indices for the appropriate cell in a cell array 
% given (x,y,z) coordinates.

% Inputs*:
% x = x-coordinate in space
% y = y-coordinate in space
% z = z-coordinate in space
% w = width of the cell
% l = length of cell
% h = height of the cell
% n = dimensions of n*n*n cell array
% *dimensions in inches

function [i, j, k, absIndex] = findCell(position, n, w, l, h)

% x <--> i
% y <--> j
% z <--> k

x=position(1);
y=position(2);
z=position(3);

% i = floor((x + n)/w + 1);
% j = floor((y + n)/l + 1);
% k = floor((z + n)/h + 1);

% see initMBPP for explanation of this formula. Note that this is
% equivalent to the above (commented out) formula for w, h, l = 2. The
% formula below is general for all w, l, and h
i = floor(x/w + n/2 + 1);
j = floor(y/l + n/2 + 1);
k = floor(z/h + n/2 + 1);

% to flatten n*n*n array into 1*n^3 array, this is index:
absIndex = (k-1)*n^2 + (j-1)*n + i;