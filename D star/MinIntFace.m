%Divya Gunasekaran
%May 3, 2011

%Get face coordinates of minimum point on interior of face
%Inputs are the minimum boundary coordinates 

function [t,u] = MinIntFace(t0,t1,u0,u1)

t = ((t1-t0)*u0 + t0) / (2-(t1-t0)*(u1-u0));

u = (u1-u0)*t + u0;