%Divya Gunasekaran
%April 25, 2011
%D* algorithm

%Get adjacent cells for given index

function [validAdjCells,checkedcells,invalidAdjCells] = A_Succ(B,cellIndex, n)

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
    
    %If there is a cell to the bottom right
    if(cellIndex > nSq)
        i_centerBottomRight = cellIndex + 1 - nSq;
        adjCells(i) = i_centerBottomRight;
        i = i + 1;
    end
    
    %If there is a cell to the top right
    if(cellIndex <= (nCube-nSq))
        i_centerTopRight = cellIndex + 1 + nSq;
        adjCells(i) = i_centerTopRight;
        i = i + 1;
    end
    
    %If there are cells to the right and front
    rem = mod(cellIndex,nSq);
    if(rem<(nSq-n) && rem~=0)
        i_frontLevelRight = cellIndex + 1 + n;
        adjCells(i) = i_frontLevelRight;
        i = i + 1;
        
        %If there is a cell to the right, front, bottom
        if(cellIndex > nSq)
            i_frontBottomRight = cellIndex + 1 - nSq + n;
            adjCells(i) = i_frontBottomRight;
            i = i + 1;
        end
        
        %If there is a cell to the right, front, top
        if(cellIndex <= (nCube-nSq))
            i_frontTopRight = cellIndex + 1 + nSq + n;
            adjCells(i) = i_frontTopRight;
            i = i + 1;
        end
    end
    
    %If there are cells to the right and back
    rem = mod(cellIndex,nSq);
    if(rem > n || rem==0)
    	i_backLevelRight = cellIndex + 1 - n;
        adjCells(i) = i_backLevelRight;
        i = i + 1;

        %If there is a cell to the right, back, bottom
        if(cellIndex > nSq)
            i_backBottomRight = cellIndex + 1 - nSq - n;
            adjCells(i) = i_backBottomRight;
            i = i + 1;
        end

        %If there is a cell to the right, back, top
        if(cellIndex <= (nCube-nSq))
            i_backTopRight = cellIndex + 1 + nSq - n;
            adjCells(i) = i_backTopRight;
            i = i + 1;
        end
    end      
end

%If there are cells to the left
if(mod(cellIndex,n)~=1)
    i_centerLevelLeft = cellIndex - 1;
    adjCells(i) = i_centerLevelLeft;
    i = i + 1;
    
    %If there is a cell to the bottom left
    if(cellIndex > nSq)
        i_centerBottomLeft = cellIndex - 1 - nSq;
        adjCells(i) = i_centerBottomLeft;
        i = i + 1;
    end
    
    %If there is a cell to the top left
    if(cellIndex <= (nCube-nSq))
        i_centerTopLeft = cellIndex - 1 + nSq;
        adjCells(i) = i_centerTopLeft;
        i = i + 1;
    end
    
    %If there are cells to the left and front
    rem = mod(cellIndex,nSq);
    if(rem<(nSq-n) && rem~=0)
        i_frontLevelLeft = cellIndex - 1 + n;
        adjCells(i) = i_frontLevelLeft;
        i = i + 1;
        
        %If there is a cell to the left, front, bottom
        if(cellIndex > nSq)
            i_frontBottomLeft = cellIndex - 1 - nSq + n;
            adjCells(i) = i_frontBottomLeft;
            i = i + 1;
        end
        
        %If there is a cell to the left, front, top
        if(cellIndex <= (nCube-nSq))
            i_frontTopLeft = cellIndex - 1 + nSq + n;
            adjCells(i) = i_frontTopLeft;
            i = i + 1;
        end
    end
    
    %If there are cells to the left and back
    rem = mod(cellIndex,nSq);
    if(rem > n || rem==0)
    	i_backLevelLeft = cellIndex - 1 - n;
        adjCells(i) = i_backLevelLeft;
        i = i + 1;

        %If there is a cell to the left, back, bottom
        if(cellIndex > nSq)
            i_backBottomLeft = cellIndex - 1 - nSq - n;
            adjCells(i) = i_backBottomLeft;
            i = i + 1;
        end

        %If there is a cell to the left, back, top
        if(cellIndex <= (nCube-nSq))
            i_backTopLeft = cellIndex - 1 + nSq - n;
            adjCells(i) = i_backTopLeft;
            i = i + 1;
        end
    end      
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
    
    %If there is a cell to the front and bottom
    if(cellIndex > nSq)
        i_frontBottomMiddle = cellIndex - nSq + n;
        adjCells(i) = i_frontBottomMiddle;
        i = i + 1;
    end
    
    %If there is a cell to the front and top
    if(cellIndex <= (nCube-nSq))
        i_frontTopMiddle = cellIndex + nSq + n;
        adjCells(i) = i_frontTopMiddle;
        i = i + 1;
    end
end

%If there are cells to the back
rem = mod(cellIndex,nSq);
if(rem > n || rem==0)
    i_backLevelMiddle = cellIndex - n;
    adjCells(i) = i_backLevelMiddle;
    i = i + 1;
    
    %If there is a cell to the back and bottom
    if(cellIndex > nSq)
        i_backBottomMiddle = cellIndex - nSq - n;
        adjCells(i) = i_backBottomMiddle;
        i = i + 1;  
    end
    
    %If there is a cell to the back and top
    if(cellIndex <= (nCube-nSq))
        i_backTopMiddle = cellIndex + nSq - n;
        adjCells(i) = i_backTopMiddle;
        i = i + 1;
    end
end
    
           
adjCells(i:end)=[]; %truncate end of vector

%Run through adjacent cells and only return obstacle-free adjacent cells
k=1;
i=1;
num = 1;

validAdjCells = [];
invalidAdjCells = [];
checkedcells = [];
restofarm = [];


for j=1:numel(adjCells)
    
    adjCellIndex = adjCells(j);
    
    if(B(adjCellIndex).obstacle == 0),
        
%         [possible,armcells] = CheckAvailablePostures(B,adjCellIndex,'right');
%         
%         if possible,
            validAdjCells(k) = adjCellIndex;
            k = k + 1;
%             checkedcells(num) = adjCellIndex;
%             num = num + 1;
%         else
%             invalidAdjCells(i) = adjCellIndex;
%             i = i + 1;
%             restofarm = unique([restofarm, armcells]);
%         end
% 
%     elseif B(adjCellIndex).obstacle == -1,
%         
%         invalidAdjCells(i) = adjCellIndex;
%         i = i + 1;
%     
%     elseif B(adjCellIndex).obstacle == -2,
%         
%         validAdjCells(k) = adjCellIndex;
%         k = k + 1;
%         
%     end

end

% validAdjCells = setdiff(validAdjCells,restofarm);
% checkedcells = setdiff(checkedcells,restofarm);
% invalidAdjCells = union(invalidAdjCells,restofarm);

end

