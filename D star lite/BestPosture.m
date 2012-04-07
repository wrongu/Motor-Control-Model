function [collision, nextcell, nextpoint, nextposture] = BestPosture(currentcell, initPosture, adjIndex, B, side)

currentposture = full_posture_to_partial(initPosture, 'right');

collision = 1;

for i = 1:length(adjIndex),
    
    costvec(i) =  euclidDist(B(currentcell).center,B(adjIndex(i)).center) + B(adjIndex(i)).g;
    
end

[~,ind] = sort(costvec);

PotentialMoves = adjIndex(ind);

for nearcell = 1:length(PotentialMoves),
    
    isValid = 0;
    
    PotentialPostures = vertcat(B(PotentialMoves(nearcell)).r_postures);
    
    [numpos,~] = size(PotentialPostures);
    
    for i = 1:numpos,
        
%         movement = [currentposture;PotentialPostures(i,:)];
%         movement = break_down_movement(movement, pi/64);
%         
%         [numpos2,~] = size(movement);
%         
%         collis = [];
%         
%         for j = 1:numpos2,
%             
%             [collis(j)] = CheckPostureCollisions(B,movement(i,:),side);
%             
%         end
%         
%         isValid(i) = all(collis);

           isValid(i) = CheckPostureCollisions(B,PotentialPostures(i,:),side);
        
    end
    
    if find(isValid) ~= 0,
        
        availablepos = PotentialPostures(find(isValid),:);
        
        [numpos,~] = size(availablepos);
        
        if numpos ~= 0,
            
            for i = 1:numpos,
                
                s(i) = sum(circ_var([currentposture; availablepos(i,:)]));
%                s(i) = sum([3 3 3 1 1 1 1] .* circ_var([currentposture; availablepos(i,:)]));
                
            end
            
            [a,b]= min(s);
            
            collision = 0;
            
            nextposture = availablepos(b,:);
            
            nextposture = partial_posture_to_full(nextposture, 'right');
            
            nextpoint = ForwardKinematics_V5(nextposture);
            
            nextcell = PotentialMoves(nearcell);
            
            break
            
        end
        
    end
    
end

end

