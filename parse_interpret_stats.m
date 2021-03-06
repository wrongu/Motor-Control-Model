% run this script after running execute_test_sequence to get statistics and
% useful information about the tests

if(~exist('test_sequence', 'var'))
    disp('key variable test_sequence does not exist. run generate_test_sequence first.');
elseif(~exist('level_time_stats', 'var'))
    disp('key variable level_time_stats does not exist. run execute_test_sequence first.');
else
    maxlevel = 5;
    parse_stats;
    n = length(stats);
    
    n_obs = arrayfun(@(t) length(t.obstacles), test_sequence);
    
    total_times = zeros(n, 1);
    highest_level = zeros(n, 1);
    times_by_level = zeros(n, maxlevel+1); % column c is level c-1
    highest_level_by_n_obs = zeros(max(n_obs)+1, maxlevel+1); % row i col j is 'num times max level was j-1 when # obs was i-1'
    n_lvl3_per_trial = zeros(n, 1);
    
    for i = 1:length(stats),
        fprintf('trial %d\n', i);
        trial = stats(i);
        total_times(i) = sum(trial.times);
        highest_level(i) = max(trial.levels);
        n_lvl3_per_trial(i) = sum(trial.levels==3);
        hlbno = highest_level_by_n_obs(length(test_sequence(i).obstacles)+1, highest_level(i)+1);
        highest_level_by_n_obs(length(test_sequence(i).obstacles)+1, highest_level(i)+1) = hlbno + 1;
        for L = 0:maxlevel,
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
    subplot(1,3,1);
    hist(highest_level, 0:4);
    grid on;
    title('Highest Level Reached');
    subplot(1,3,2);
    hist(n_lvl3_per_trial, 0:4);
    grid on;
    title('Number of times entered level 3 in a single trial');
    subplot(1,3,3);
    bar(highest_level_by_n_obs);
    hold on;
    grid on;
    xlabel('# obstacles');
    ylabel('# occurrences');
    legend('max lvl 0', 'max lvl 1', 'max lvl 2', 'max lvl 3', 'max lvl 4');
    title('max level for each trial vs. number of obstacles');
    hold off;
    suptitle('Histograms for Levels');
    
    % SCATTER PLOTS
    figure();
    scatter(n_obs, total_times);
    xlabel('num obstacles');
    ylabel('time taken');
    
    disp('plotting done');
end