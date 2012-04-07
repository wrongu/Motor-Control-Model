num_trials = 100;

disp('loading B');
load(fullfile(rootFolderPath, 'Saved Data/init_1.mat'));
    n = size(B,1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    thresh = w/2;
    taskMap = containers.Map();
    
B_orig = B;

M = [];

robo_number = 2;
use_robot = false;

eval(['load(''servo_stats_' num2str(robo_number) ''')']);
servo_controller = rps_to_speed;
clear rps_to_speed;

thresh = w/2;

% cont = input('Do you want to continue? (y or n)','s');
% if cont == 'n',
%     return
% end


highestlevel = zeros(1,num_trials);

% a guesstimate of the size: 4 levels per trial + one row of zeros
level_time_stats = zeros(num_trials*5,3);
% keep track of the row
level_stats_index = 1;

for trial_num = 1:num_trials
    try
        
        disp(trial_num)
        targetXYZ = 16*rand(1,3)-8;
        side = 'right';
        task = 'naive';
        speed = 20;
        
        MainController;
        
        M = addtoM(movement,'reaching','right',M)
        
        MovementStruct(trial_num) = {movement}
        
        if(taskTable.loadFactor >= 1)
            taskTable = resize(taskTable);
        end
        
        highestlevel(trial_num) = hlevel;
    
    catch err
        highestlevel(trial_num) = hlevel;
        fprintf('internal simulation error at level %d: trial %d\n', level, trial_num);
    end
    % add a zero row to stats to indicate next trial:
    level_time_stats(level_stats_index, :) = [0 0];
    level_stats_index = level_stats_index+1;
end