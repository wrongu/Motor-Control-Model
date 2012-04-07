ind = find(level_time_stats(:,3) == 0)
ind = [0; ind];

stats = cell(1);

for i = 1:length(ind)
    
    if ind(i) == ind(i+1)-1,
        break
    end
    
    range = (ind(i)+1):(ind(i+1)-1);
    
    stats(i).levels = level_time_stats(range,1);
    stats(i).codes  = level_time_stats(range,2);
    stats(i).times  = level_time_stats(range,3);
    
end

disp('parsing done');