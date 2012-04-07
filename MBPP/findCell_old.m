%%Divya Gunasekaran
%%October 19, 2010

%Function to find the indices for the appropriate cell in a cell array 
%given (x,y,z) coordinates.

%Inputs:
%x = x-coordinate in space
%y = y-coordinate in space
%z = z-coordinate in space 
%w = width of the cell
%l = length of cell
%h = height of the cell
%n = dimensions of nxnxn cell array

function [i, j, k] = findCell(position, n, w, l, h)
x_count=0;
y_count=0;
z_count=0;

x=position(1);
y=position(2);
z=position(3);

%Compute i index
if (x < 0)
    x = x + w;
    while(x < 0)
        x_count = x_count + 1;
        x = x + w;
    end
    i = (n/2)-x_count;
else
    x = x - w;
    while(x > 0)
        x_count = x_count + 1;
        x = x - w;
    end
    i = (n/2) + 1 + x_count;
end

%Compute j index
if (y > 0)
    y = y - l;
    while(y > 0)
        y_count = y_count + 1;
        y = y - l;
    end
    j = (n/2) + 1 + y_count;
else
    y = y + l;
    while(y < 0)
        y_count = y_count + 1;
        y = y + l;
    end
    j = (n/2)-y_count;
end

%Compute k index
if (z > 0)
    z = z - h;
    while(z > 0)
        z_count = z_count + 1;
        z = z - h;
    end
    k = (n/2) + 1 + z_count;
else
    z = z + h;
    while(z < 0)
        z_count = z_count + 1;
        z = z + h;
    end
    k = (n/2)-z_count;
end

% i = floor((y + (h/2))/h);
% j = floor((x+(w/2))/w);
% z=0; %z is currently unused as our model is in 2D
