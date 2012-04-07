function w = CalculateWeight(currentposture,weight,M)

len = length(M);

currentposture = full_posture_to_partial(currentposture, 'right')

d = sum((vertcat(M.currentposture)-currentposture(ones(1,len),:)).^2,2);

ind = ~cellfun('isempty',{M.normjointdiff})

w = weight*(vertcat(M(ind).normjointdiff)'.*(1/len))*((ones(length(d(ind)),1)./d(ind)));

%w = (vertcat(M(ind).normjointdiff)'.*(1/len))*(ones(length(d(ind)),1));

end