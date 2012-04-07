%Divya Gunasekaran
%May 6, 2011

% updated on 8/3/2011 by Richard Lange
% removed input `n` - can be found along with w, l, and h from B.
% removed input 'goal_index' - can be found with findCell on goalPt

%Primitive straight line path planner (can only plan in straight lines)

function [path, tElapsed] = StraightLinePlan(B, startPt, goalPt, spacing)

% addpath('C:\Users\Administrator\Documents\Matlab\tcp_udp_ip');

tStart = tic;

%Length of line segment connecting start and goal_index points
total_dist = euclidDist(startPt,goalPt);

if(total_dist < spacing)
    path = goalPt;
    tElapsed = toc(tStart);
    return;
end

num_steps = floor(total_dist/spacing);
path = zeros(num_steps+1,3);

% get vector of length <spacing> pointing from the st. point to the end pt.
st_to_end_vector = spacing * (goalPt - startPt)/total_dist;

for i=1:num_steps+1
    path(i,:) = startPt + (i-1)*st_to_end_vector;
end

lastPt = path(num_steps+1,:);

n = size(B,1);
w = B(1).width;
l = B(1).length;
h = B(1).height;

%Cell the last point in the path belongs to
[~,~,~,lastCell] = findCell(lastPt,n,w,l,h);
[~,~,~,goal_index] = findCell(goalPt,n,w,l,h);

%If the last point lies in the same cell as the reach target
if(lastCell==goal_index)
    %Replace the last point with the reach target
    path(end,:) = goalPt;
%Otherwise, add the reach target to the end of the path
else
    path(end+1,:) = goalPt;
end

tElapsed = toc(tStart);
        
end