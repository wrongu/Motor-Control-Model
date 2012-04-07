% Richard Lange
% reset environment

%robo_disconnect;
clearvars -except B_orig rootFolderPath use_robot test_sequence;
close all;
clc;
disp('loading B');
if(~exist('B_orig', 'var'))
    if(~exist('rootFolderPath', 'var'))
        init;
    end
    load(fullfile(rootFolderPath, 'Saved Data/init_1.mat'));
    B_orig = B;
end
    B = B_orig;
    n = size(B,1);
    w = B(1).width;
    l = B(1).length;
    h = B(1).height;
    thresh = w/2;
    taskMap = containers.Map();
    
if (exist('use_robot', 'var') && use_robot)
    robo_number = get_current_robo_num();
    sock = robo_connect(robo_number);
else
    use_robot = false;
end
B_orig = B;
% MBPPmodel_new;
% B = fillSelfObstacles(B);