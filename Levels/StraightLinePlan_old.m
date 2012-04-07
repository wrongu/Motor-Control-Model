%Divya Gunasekaran
%May 6, 2011

%Primitive straight line path planner (can only plan in straight lines)

function [path, tElapsed] = StraightLinePlan_old(B, n, goal_index, startPt, goalPt, spacing)

% addpath('C:\Users\Administrator\Documents\Matlab\tcp_udp_ip');

tStart = tic;

%Length of line segment connecting start and goal_index points
total_dist = euclidDist(startPt,goalPt);

%Get number of points on path
tSpacing = (spacing / total_dist);

path=[];
t=0;
while(t<=1)
    %Parametric equation of 3d line between start and goal_index points
    intermedPt = startPt + (goalPt-startPt)*t;
    
    path = [path; intermedPt];
    
    t = t + tSpacing;
end

lastPt = path(end,:);

%Cell dimensions
w = B(1).width;
l = B(1).length;
h = B(1).height;

%Cell the last point in the path belongs to
[~,~,~,lastCell] = findCell(lastPt,n,w,l,h);

%If the last point lies in the same cell as the reach target
if(lastCell==goal_index)
    %Replace the last point with the reach target
    path(numPoints,:) = goalPt;
%Otherwise, add the reach target to the end of the path
else
    path(numPoints+1,:) = goalPt;
end

tElapsed = toc(tStart);
        