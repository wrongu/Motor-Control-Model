% TEST 1
% point low in front
targetXYZ = [10 0 2];
side = 'right';
task = 'naive';
speed = 20;

MainController;

if(taskTable.loadFactor >= 1)
    taskTable = resize(taskTable);
end