%Divya Gunasekaran
%April 25, 2011
%D* algorithm

%Get adjacent cells for given index

function validAdjCells = A_Succ_reduced(B,cellIndex, n)

% addpath('C:\Users\Administrator\Documents\Matlab\MBPP');

nSq = n*n;
nCube = n*n*n;
adjCells = zeros(1,26);
i = 1;

% GET INDICES OF ADJACENT CELLS -- take care of boundary conditions
%If there are cells to the right
if(mod(cellIndex,n)~=0)
    i_centerLevelRight = cellIndex + 1;
    adjCells(i) = i_centerLevelRight;
    i = i + 1;   
end

%If there are cells to the left
if(mod(cellIndex,n)~=1)
    i_centerLevelLeft = cellIndex - 1;
    adjCells(i) = i_centerLevelLeft;
    i = i + 1; 
end

%If there are cells to the top
if(cellIndex <= (nCube-nSq))
    i_centerTopMiddle = cellIndex + nSq;
    adjCells(i) = i_centerTopMiddle;
    i = i + 1;
end

%If there are cells to the bottom
if(cellIndex > nSq)
    i_centerBottomMiddle = cellIndex - nSq;
    adjCells(i) = i_centerBottomMiddle;
    i = i + 1;
end

%If there are cells to the front
rem = mod(cellIndex,nSq);
if(rem<(nSq-n) && rem~=0)
    i_frontLevelMiddle = cellIndex + n;
    adjCells(i) = i_frontLevelMiddle;
    i = i + 1;
  
end

%If there are cells to the back
rem = mod(cellIndex,nSq);
if(rem > n || rem==0)
    i_backLevelMiddle = cellIndex - n;
    adjCells(i) = i_backLevelMiddle;
    i = i + 1;
end
    
           
adjCells(i:end)=[]; %truncate end of vector

%Run through adjacent cells and only return obstacle-free adjacent cells
k=1;
validAdjCells = [];
for j=1:numel(adjCells)
    adjCellIndex = adjCells(j);
    if(~B(adjCellIndex).obstacle)
        validAdjCells(k) = adjCellIndex;
        k = k + 1;
    end
end

