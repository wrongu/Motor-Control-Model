function int = CalculateInteraction(currentposture,weight,M)

len = length(M);

currentposture = full_posture_to_partial(currentposture, 'right')

d = sqrt(sum((vertcat(M.currentposture)-currentposture(ones(1,len),:)).^2,2));

ind = ~cellfun('isempty',{M.normjointdiff})

sum(ind) ~= 0

if sum(ind) ~= 0,
    
    int = weight*(vertcat(M(ind).normjointdiff)'.*(1/len))*((ones(length(d(ind)),1)./d(ind)));
    
else
    
    int = zeros(7,1),
    
end

%int= (vertcat(M(ind).normjointdiff)'.*(1/len))*(ones(length(d(ind)),1));

end