%%Divya Gunasekaran
%%October 14, 2010

%Function to detect collisions by computing potential energy between a
%point S and a cell 

%Inputs:
%(Sx, Sy) represents a point
%(cx, cy) is the center of a cell
%w, h is the width and height of the cell

function [p] = potential(Sx, Sy, cx, cy, w, h)
%Potential energy is zero if point is outside of the box
if abs(Sx - cx) >= w/2 || abs(Sy - cy) >= h/2
    p=0;
%Positive potential energy means a collision has occurred    
else
    p = (w/2 - abs(Sx - cx))^2 + (h/2 - abs(Sy - cy))^2;
end;
