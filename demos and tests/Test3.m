% TEST 3
% point up by right of cameras ('ear' I guess)
targetXYZ = [0 -4.5 11];
side = 'right';
task = 'naive';
speed = 20;

MainController;

if(taskTable.loadFactor >= 1)
    taskTable = resize(taskTable);
end