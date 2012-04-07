%Divya Gunasekaran
%May 5, 2011

function [B,updated] = A_UpdateCell(cellIndex, start, goal, B, n)

%Constant representing infinity
inf = 1000000;
minRHS = inf;

if(cellIndex~=goal)
    %Get adjacent faces
    adjCells = A_Succ(B,cellIndex, n);
    
    %For each adjacent face
    for i=1:numel(adjCells)
        nbr = adjCells(i);
      
        %If goal estimate not infinity
        %Calculate look ahead cost (rhs) to neighboring cell
        if(B(nbr).g < inf)
            rhs = euclidDist(B(cellIndex).center,B(nbr).center) + B(nbr).g;
            if(rhs < minRHS)
                minRHS = rhs;
            end
        end
    end
    if(minRHS<inf)
        B(cellIndex).rhs = minRHS;
        %FacesArray{faceIndex}.point = minXYZ;
        [k1,k2] = A_CalculateKey(B,cellIndex,start);
        B(cellIndex).k1 = k1;
        B(cellIndex).k2 = k2;
        updated=1;
    else
        str = ['Cell ', num2str(cellIndex), ' not updated'];
        disp(str);
        updated=0;
    end
else
    %disp('Goal cell not updated');
    updated=0;
end