ind = find(level_time_stats(:,3) == 0);
ind = [0; ind; length(level_time_stats)];

stats=[];

stats_ind = 1;
for i = 1:length(ind)-1
    % range from index after this zero to index before next zero
    range = (ind(i)+1):(ind(i+1)-1);
    if(isempty(range))
        continue
    end
    
    stats(stats_ind).levels = level_time_stats(range,1);
    stats(stats_ind).codes  = level_time_stats(range,2);
    stats(stats_ind).times  = level_time_stats(range,3);
    stats_ind = stats_ind+1;
end

disp('parsing done');