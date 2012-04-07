function [collision, nextcell, nextpoint, nextposture] = BestPosture(currentcell, initPosture, adjIndex, B, side)

currentposture = full_posture_to_partial(initPosture, side);

collision = 1;

for i = 1:length(adjIndex),
    
    cost(i) =  euclidDist(B(currentcell).center,B(adjIndex(i)).center) + B(adjIndex(i)).g;
    
end

[~,ind] = sort(cost);

PotentialMoves = adjIndex(ind);

for nearcell = 1:length(PotentialMoves),
    
    isValid = 0;
    
    new_angles = InverseKinematics(B(nearcell).center, currentposture, side, B(1).width/2)
    
    PotentialPostures = vertcat(B(PotentialMoves(nearcell)).r_postures);
    
    PotentialPostures = [new_angles; PotentialPostures];
    
    [numpos,~] = size(PotentialPostures);
    
    for i = 1:numpos,
        
        [isValid(i)] = CheckPostureCollisions(B,PotentialPostures(i,:),side);
        
    end
    
    if ~isempty(find(isValid)),
        
        availablepos = PotentialPostures(find(isValid), :);
        
        [numpos,~] = size(availablepos);
        
        if numpos ~= 0,
            
            s = zeros(1,numpos);
            
            for i = 1:numpos,
                
                s(i) = sum(circ_var([currentposture; availablepos(i,:)]));
                %                s(i) = sum([3 3 3 1 1 1 1] .* circ_var([currentposture; availablepos(i,:)]));
                
            end
            
            [~,b]= sort(s);
            
            for i=1:length(b),

                collision = 0;

                nextposture = availablepos(b(i),:);

                nextposture = partial_posture_to_full(nextposture, side);

                nextpoint = ForwardKinematics_V5(nextposture);

                nextcell = PotentialMoves(nearcell);

                interp_postures = break_down_movement([nextposture; initPosture],pi/16);

                is_valid = CheckMovement(B,interp_postures,side);

                if(is_valid) 

                   break
                   
                end
            
            end
            
        end
        
    else
        
        disp('deadend')
        
    end
    
    if nearcell == length(PotentialMoves),
        disp('no possible path')
        collision
    end
        
    
end



end

