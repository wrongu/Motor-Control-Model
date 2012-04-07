% Divya Gunasekaran
% May 16, 2011

% Script to initialize Memory Based Posture Planning framework
% as given in Park, Singh, Martin (2006)  

% Width, length, and height of each cell
w = 1;
l = 1;
h = 1;

inf = 1000000;

% Struct containing fields defining each cell
% Fields include center of cell (x, y, z) coordinate, width, length, and height of cell,
% vector or array of registered postures for the right arm and for the left arm.
s = struct('center', [0, 0, 0], 'width', w, 'length', l, 'height', h, ...
    'r_postures', [0 0 0 0 0 0 0], 'l_postures', [0 0 0 0 0 0 0], ...
    'obstacle', 0, 'g',inf, 'rhs',inf, 'k1',inf,'k2',inf);

%n*n*n cell array. Each cell holds the above struct
n=36/w; % brainbot's wingspan is 32 inches
B=cell(n, n, n); 


%Initialize variables holding centers of cells to zero
x=0;
y=0;
z=0;

% correspondence between cartesian coordinates and width, length, height:
% x <--> i <--> width
% y <--> j <--> length
% z <--> k <--> height

% Initialize cell array with centers, width, length, and height of each
% cell

% the formulas below work as follows: assume working with x, w, and i. The
% goal is to get a vector of n values centered around 0 with spacing w.
% x(i) = w*(i - (n+1)/2)
% (n+1)/2 is the middle of the range 1:n, and thus our 'zero'
% i is the index, so zero'ing i is (i - (n+1)/2), then we just scale by w.
% this also makes the inverse easy to solve for (used in findCell.m):
% i(x) = x/w + (n+1)/2
for k=1:n
    z = h*(k - (n+1)/2);
    for i=1:n
        x = w*(i - (n+1)/2);
        for j=1:n
            y = l*(j - (n+1)/2);
            % Compute the centers of each cell
            B(i, j, k) = s;
            B(i, j, k).center = [x, y, z];
        end
    end
end

%Create an empty map that will map ethological functions (given as strings)
%to HashTable objects that store movements for a particular type of task
taskMap = containers.Map();