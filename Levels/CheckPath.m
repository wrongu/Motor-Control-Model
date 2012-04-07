%Divya Gunasekaran
%May 6, 2011

% modified on 3 August 2011 by Richard Lange
% Chages: removed argument 'n' - can be found with w l and h calculations

%Returns 0 if the given path comes into contact with obstacles and 1
%otherwise

function isValid = CheckPath(B,path)

% addpath('C:\Users\Administrator\Documents\Matlab\MBPP');

%Get cell dimensions
n = size(B,1);
w = B(1).width;
l = B(1).length;
h = B(1).height;

numPoints = size(path,1);
%If the path is empty, it is automatically invalid
if(numPoints == 0)
    isValid = 0;
    return;
else
    %Else, for each point on the path
    for r=1:numPoints
        %Determine the cell to which the point belongs
        position = path(r,:);
        [i,j,k] = findCell(position,n,w,l,h);
        %If the cell is blocked
        if(B(i,j,k).obstacle)
            %return invalid
            isValid = 0;
            return;
        end
    end
end

%Else if all points are valid, return valid
isValid = 1;