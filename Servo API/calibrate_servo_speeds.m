% Richard Lange
% November 15, 2011
%
% Function to calibrate servo speeds for a given robot. Computed values are
% then stored in a file for future use because this function takes a while to
% execute

function[rps_to_speed stats_by_servo stats_by_speed] = calibrate_servo_speeds(robo_number)

    robo_disconnect;
    sock = robo_connect(robo_number);
    [~,~,servoNames] = get_servo_info();
    
    speeds = [20 40 60 80];
    
    % stats_by_speed is a 1x<speeds> cell array where each entry is a 1x<servoNames> vector
    % of radian-per-second speeds. 
    stats_by_speed = arrayfun(@(s) get_servo_time_stats(sock, s, 300, 0.06), ...
        speeds, 'UniformOutput', false);
    
    % stats_by_servo is a 1x<servoNames> cell array with each entry the
    % <speeds>x1 radians-per-second vector for that servo
    stats_by_servo = mat2cell(cell2mat(stats_by_speed'), 4, ones(1,13));
    
    % mean radian-per-second value at each speed (<speeds>x1 array)
    means = cellfun(@(data) mean(data), stats_by_speed)';
    
    
    % construct struct that maps a servo to radians-per-sec per speed unit
    %   *including* a pseudo-servo called 'mean' which will act as the
    %   default
        % prepend names and stats with mean data
    servoNames = horzcat('mean', servoNames);
    stats_by_servo = horzcat({means}, stats_by_servo);
        % regress each (assuming radians_per_second is a linear function of
        % speed)
    regressions = cellfun(@(servostats) polyfit(servostats, speeds', 1), ...
        stats_by_servo, 'UniformOutput', false);
    rps_to_speed = cell2struct(regressions, servoNames, 2);
    
    % SAVE stats in file
    save(['servo_stats_' num2str(robo_number) '.mat'], 'rps_to_speed');
    
    % PLOT of rads per sec vs servo @ each speed
    figure();
    colors = 'mbgrkc';
    h = zeros(size(speeds));
    % plot data for each speed on same graph:
    for i=1:length(speeds)
        colorchar = colors(mod(i, length(colors)+1));
        % convert char to [r g b]
        color = bitget(find('kbgcrmyw'==colorchar)-1, 1:3);
        % plot both data and mean value
        data = stats_by_speed{i};
        hold on;
        h(i) = plot(data, 'Color', color);
        line([0 length(servoNames)], [means(i) means(i)], ...
            'Color', color, 'LineStyle', '--');
        hold off;
    end
    ylabel('Radians per Second');
    set(gca, 'XTickLabel', servoNames);
    legend(h, arrayfun(@(s) ['speed = ' num2str(s)], speeds, 'UniformOutput', false));
    
    % close connection
    robo_disconnect;
end