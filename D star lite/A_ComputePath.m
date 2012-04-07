% Divya Gunasekaran
% May 5, 2011
% Compute D* algorithm

function [path,Movement,tElapsed,B] = A_ComputePath(currentposture,goalPt,B,thresh)

h = figure

tStart = tic;

%cost = zeros(36,36,36);

startPt = ForwardKinematics_V5(currentposture)

[~,~,~,start] = findCell(startPt, 36, 1, 1, 1)
[~,~,~,goal] = findCell(goalPt, 36, 1, 1, 1)

%% INITIALIZATION
n = size(B, 1);
%nSq = n^2;
nCube = n^3;

pq = pq_createMin(nCube); %Min priority queue with a max of n cubed elems

%Initialize start 
%Get dimensions of cells
%w = B(1).width;
%l = B(1).length;
%h = B(1}.height;

%Initialize goal 
%Make sure the goal is not contained within an obstruction
if(B(goal).obstacle)
    disp('The target is inside an obstacle. No possible path.');
    path = [];
    return;
end
B(goal).rhs = 0;
[k1,k2] = A_CalculateKey(B,goal,start);
B(goal).k1 = k1;
B(goal).k2 = k2;
%Push goal onto priority queue
pq_pushMin(pq,goal,B(goal).k1,B(goal).k2);


%% COMPUTE PATH

[~,k1_old,k2_old] = pq_topMin(pq);
[k1_start,k2_start] = A_CalculateKey(B,start,start);

m=0;%TESTING

%While start node is inconsistent or there are nodes on priority queue with
%priority less than that of the start node
while(k1_old<k1_start || (k1_old==k1_start && k2_old<k2_start) ...
        || B(start).rhs~=B(start).g)
    
    m=m+1;
%     disp('Popping from queue:');

priorityqueuesize = pq_sizeMin(pq)
    
    [cellIndex,~,~] = pq_popMin(pq);
    
%     disp('Actual keys of what was just popped:');
    
    [k1_pop,k2_pop] = A_CalculateKey(B,cellIndex,start);
   
    %If key of node at top of queue is not up to date
    if(k1_old < k1_pop || (k1_old==k1_pop && k2_old<k2_pop))
        
%         disp('Node not up to date');
%         
        B(cellIndex).k1 = k1_pop;
        B(cellIndex).k2 = k2_pop;
        %Push node back on queue with updated key
        pq_pushMin(pq,cellIndex,B(cellIndex).k1,B(cellIndex).k2);
   
    %Else if node at top of queue is overconsistent
    elseif(B(cellIndex).g > B(cellIndex).rhs)
        
%         disp('Overconsistent node');
%         
        %Make node consistent
        B(cellIndex).g = B(cellIndex).rhs;
        
        %Update all of node's neighbors and push onto queue
        
        %        [adjCells,checkedcells,impossiblecells] = A_Succ(B,cellIndex, n);
        adjCells = A_Succ(B,cellIndex, n);
        
        for i=1:numel(adjCells)
            adjIndex = adjCells(i);
            if(adjIndex~=cellIndex)
                [B,updated] = A_UpdateCell(adjIndex, start, goal, B, n);
                if pq_sizeMin(pq) > 0,
                    pq_removeMin(pq,adjIndex); %Remove if in the priority queue
                end
                rmpriorityqueuesize = pq_sizeMin(pq)
%                                  str = ['updated:',num2str(updated),' g:',num2str(B(adjIndex).g),' rhs:',num2str(B(adjIndex).rhs)];
%                                  disp(str);
                if(updated && B(adjIndex).g~=B(adjIndex).rhs)
%                     str = ['Cell ', num2str(adjIndex), ' pushed onto stack'];
%                     disp(str);
                    pq_pushMin(pq,adjIndex,B(adjIndex).k1,B(adjIndex).k2);
                end
            end
        end
        
%         for i=1:numel(impossiblecells),
% %            impossiblecells(i);
%             B(impossiblecells(i)).obstacle = -1;
%         end
%         
%         if ~isempty(impossiblecells)
%             h = plot_obstacles(B,h);
%         end
%         
%         for i=1:numel(checkedcells),
%             %            checkedcells(i);
%             B(checkedcells(i)).obstacle = -2;
%         end
%         
        %Else node is underconsistent
    else
        %  disp('Underconsistent node');
        
        %Set goal cost estimate to infinity
        B(cellIndex).g = Inf;
        %Update node and all of node's neighbors and push onto queue
        adjFaces = A_Succ(B,cellIndex,n);
        adjCells = [cellIndex adjFaces];
        for i=1:numel(adjCells)
            adjIndex = adjCells(i);
            [B,updated] = A_UpdateCell(adjIndex, start, goal, B, n);
            if pq_sizeMin(pq) > 0,
                pq_removeMin(pq,adjIndex);
            end
            rmpriorityqueuesize = pq_sizeMin(pq) %Remove if in the priority queue
            if(updated && B(adjIndex).g~=B(adjIndex).rhs)
                %str = ['Cell ', num2str(adjIndex), ' pushed onto stack'];
                pq_pushMin(pq,adjIndex,B(adjIndex).k1,B(adjIndex).k2);
            end
        end
    end
    
    %Check size of queue
    if(pq_sizeMin(pq) > 0)
        [~,k1_old,k2_old] = pq_topMin(pq);
        [k1_start,k2_start] = A_CalculateKey(B,start,start);
%         str=['Gstart is ', num2str(B(start).g), ' and RHSstart is ', num2str(B(start).rhs)];
%         disp(str);
    %Else if queue is empty, break out of while loop
    else
        break;
    end
    
end

numPoints=1;
curr = start;
path = [];
%B(start).obstacle=1;
Movement = [];

t = cputime

while(curr~=goal && euclidDist(B(curr).center,goalPt)>=thresh)
    
    %%Add the cell with the minimum cost to the path
    path = [path; B(curr).center];
    
    B(curr).center
    
    %Find the adjacent cell with the least cost
    minCost = Inf;
    minNext = NaN;
    
    %   disp('Adjacent cells:');
    adjCells = A_Succ(B,curr,n);
    
    [collision,  minNext, nextpoint, nextposture] = BestPosture(curr, currentposture, adjCells, B, 'right');
    
    currentposture = nextposture;
    
    if cputime - t > 60*5
            ghdfhfdhd
        end
    
    %If there are no more cells to investigate
    if(collision)
        %There is no possible path
        %       path = [];
        str = ['Note: No path is possible from cell ', num2str(start), ' to cell ', num2str(goal)];
        disp(str);
        return;
    else
        %Prevent the path to return to a cell it has already visited
        %        B(curr).obstacle = 1;
        curr = minNext;
        numPoints = numPoints + 1
        Movement = [Movement; nextposture];
        B(curr).obstacle = 1;
        
    end
    
end

%Add goal point to path
path = [path; goalPt]

%Delete priority queue

disp('attempting to delete')
pq_deleteMin(pq);

tElapsed = toc(tStart);

