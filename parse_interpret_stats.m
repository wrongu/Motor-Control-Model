% run this script after running execute_test_sequence to get statistics and
% useful information about the tests

if(~exist('level_time_stats', 'var'))
    disp('key variable level_time_stats does not exist. run execute_test_sequence first.');
else
    parse_stats;
    n = length(stats);
    
    total_times = zeros(n, 1);
    highest_level = zeros(n, 1);
    times_by_level = zeros(n, 5); % column c is level c-1
    n_lvl3_per_trial = zeros(n, 1);
    
    for i = 1:length(stats),
        trial = stats(i);
        total_times(i) = sum(trial.times);
        highest_level(i) = max(trial.levels);
        n_lvl3_per_trial(i) = sum(trial.levels==3);
        for L = 0:4,
            times_by_level(i, L+1) = mean(trial.times(trial.levels == L));
        end
    end
    disp('interpretation done');
    
    % BOX-WHISKER TIMING
    figure();
    subplot(2,2,[1 3]);
    boxplot(total_times);
    ylabel('time (s)');
    title('Total Time per Test');
    set(gca, 'XTickLabel', {''}, 'YGrid', 'on');
    subplot(2,2,2);
    boxplot(times_by_level);
    title('Time per Level');
    ylabel('time (s)');
    xlabel('level');
    set(gca, 'XTick', 1:5, 'XTickLabel', {'0', '1', '2', '3', '4'}, 'YGrid', 'on');
    suptitle(['Timing Stats for ' num2str(n) ' trials']);
    % LOG times
    subplot(2,2,4);
    boxplot(log(times_by_level));
    title('Log of Time per Level');
    ylabel('log(time (s))');
    xlabel('level');
    set(gca, 'XTick', 1:5, 'XTickLabel', {'0', '1', '2', '3', '4'}, 'YGrid', 'on');
    suptitle(['Timing Stats for ' num2str(n) ' trials']);
    
    % HISTOGRAMS
    figure();
    subplot(1,2,1);
    hist(highest_level, 0:4);
    title('Highest Level Reached');
    subplot(1,2,2);
    hist(n_lvl3_per_trial, 0:4);
    title('Number of times entered level 3 in a single trial');
    
    disp('plotting done');
end