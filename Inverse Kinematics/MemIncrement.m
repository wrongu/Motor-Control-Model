function increment = MemIncrement(currentposture, func, goal, offset, M),

currentpoint = ForwardKinematics_V5(currentposture);

adjind = find(([M.x] < currentpoint(1) + offset) & ([M.x] > currentpoint(1) - offset) & ([M.y] < currentpoint(2) + offset) & ([M.y] > currentpoint(2) - offset) & ([M.z] < currentpoint(3) + offset) & ([M.z] > currentpoint(3) - offset));

relevantpostures = [];

for i = adjind,
    
    a = {M(i).type};
    b = func;
    
    ind = cellfun(@(s)~isempty(strfind(s,b)), a,'UniformOutput',0)
    
    relevantpostures = [relevantpostures; vertcat(M(ind))]
    
end