function [yesno,restofarm] = CheckAvailablePostures(B,index,side)
   
restofarm = [];

if side == 'right',
    
    PotentialPostures = B(index).r_postures;
    
elseif side == 'left',
    
    PotentialPostures = B(index).l_postures;
    
end

[numpos,~] = size(PotentialPostures);

remainingarm = cell(1,numpos);

if numpos ~= 0,
    
    for i = 1:numpos,
        
        [good(i),~,remainingarm{i}] = CheckPostureCollisions(B,PotentialPostures(i,:),side);
        
    end
    
    yesno = any(good);
    
else
    
    yesno = 0;
    
end

A = [remainingarm{:}];

if iscell(A),
    if ~isempty([A{:}])
        restofarm = unique([A{:}]);
    end
end

end