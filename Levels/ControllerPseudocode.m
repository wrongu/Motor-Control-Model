%Divya Gunasekaran
%May 9, 2011

%Pseudocode for multilevel motor control system

%Initialization
path = [];
movement = [];
done = 0;
level = 1;

while(done==0)
    
    %CONTROLLER
    switch(level)
        %LOOK UP/MOVEMENT GENERATION
        %Look up stored movements OR generate a movement given a path
        %This level cannot do path planning
        case 1: 
            %Do not have a movement or path to work off of
            if(no movement && no path)
                Look up stored movements
                if(there exists a movement we can use)
                    movement = stored movement;
                    continue;
                else
                    level = 2;
                    continue;
                end
                
            %We have a movement that we can execute
            elseif(movement exists)
                execute movement;
                done = 1; %We have achieved the reach target
            
            %We have a path, but not a movement
            %Generate the movement for the given path
            else
                Generate new movement from path;
                continue;
            end
            
            
        %LEARNING
        %Not yet conceptualized
        case 2:
            Use PCA to generate new but similar movement
            if(fail)
                level = 3;
                continue;
            end
            
            
        %SIMPLE PLANNING (HILL CLIMBING)
        %Can only plan a straight line
        case 3: 
            path = Straight line from start to goal
            if(path is valid)
                level = 1;
            else
                level = 4;
            end
            continue;
            
        
        %COMPLEX PLANNING (D* Lite)    
        case 4:
            path = D* from start to goal
            if(path is valid)
                level = 1;
            else
                done = -1; %No path exists
            end
    end
end