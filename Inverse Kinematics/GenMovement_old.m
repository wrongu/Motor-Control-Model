%Divya Gunasekaran
%May 9, 2011

%Generate a new movement given a path of points

function [B,movement,retry] = GenMovement(B,n,goal,initPosture,path,side,weight_s,weight_v,thresh)

%Get dimensions of cells and postures
w = B(1).width;
l = B(1).length;
h = B(1).height;
if(strcmp(side,'right'))
    [~,angleDim] = size(B(1).r_postures);
elseif(strcmp(side,'left'))
    [~,angleDim] = size(B(1).l_postures);
end

genLimit = 1000;
retry = 0;

[numPoints, ~] = size(path);
movement = zeros(numPoints,angleDim);

%For each point on the path
for r=1:numPoints
    disp(r);
    
    position = path(r,:);
    
    %CHECK IF STORED POSTURES CAN BE USED
    [posture,cell] = selectPosture1(B,position,initPosture,side,weight_s,weight_v);
    posturePos = GetPosturePosition(posture,side);
    isValid = CheckPostureCollisions(B,n,posture,side);
    
    %If there are no applicable stored postures
    %GENERATE A NEW POSTURE WITH GRADIENT DESCENT
    if(isempty(posture) || ~isValid || euclidDist(posturePos,position)>thresh)
        
        disp('Generating new posture');
        
        %Generate a new posture using gradient descent
        stepSize = .5;
        [posture,currXYZ,isValid] = GenPostureDescent(initPosture, position, stepSize, side, thresh);

        %Find the cell corresponding to the current point
        [i,j,k,cellIndex] = findCell(currXYZ,n,w,l,h);
        
        %Store the newly generated posture in the appropriate cell
        if(strcmp(side,'right'))
            %Store newly generated right posture in cell array
            [B(i,j,k}.r_postures, stored] = checkPostureRedundancy(B{i,j,k).r_postures, posture, 0);
        elseif(strcmp(side,'left'))
            %Store newly generated left posture in cell array
            [B(i,j,k}.l_postures, stored] = checkPostureRedundancy(B{i,j,k).l_postures, posture, 0);
        else
            disp('Error: Enter left or right for side');
            movement = [];
            return;
        end
    end
    
    isValid = CheckPostureCollisions(B,n,posture,side);
    
    %IF THE POSTURE RESULTS IN COLLISIONS
    if(~isValid)    
        disp('Posture results in collision');
        
        %Get all stored postures for the cell the given point belongs to
        if(strcmp(side,'right'))
            storedPostures = B(cell).r_postures;
        elseif(strcmp(side,'left'))
            storedPostures = B(cell).l_postures;
        end
        
        %Pick any stored posture that does not result in collisions
        [numPostures numAngles] = size(storedPostures); %Get dimensions of matrix of postures
        for m=2:numPostures
            posture = storedPostures(m,:);
            isValid = CheckPostureCollisions(B,n,posture,side);
            if(isValid)
                break;
            end
        end
        
%         %If no stored postures work, randomly generate postures 
%         numGen = 0;
%         while(numGen < genLimit)
%             posture = generatePosture();
%             posturePos = GetPosturePosition(posture, side);
%             [i,j,k,cellIndex] = findCell(posturePos,n,w,l,h);
%             %If posture belongs to the proper cell
%             if(cellIndex == cell)
%                 %And if posture is collision-free
%                 isValid = CheckPostureCollisions(B,n,posture,side);
%                 if(isValid)
%                     break;
%                 end
%             end
%             numGen = numGen + 1;
%         end
        
        %If could not find a stored collision-free posture
        if(~isValid)
            if(cell~=goal)
                B(cell).obstacle = 1;
                retry = 1;
            end
            movement = [];
            return; 
        end
            
    end
        
        
    %Add the posture to the movement 
    movement(r,:) = posture;
    %Set initPosture to "current" posture
    initPosture = posture;

        
end


