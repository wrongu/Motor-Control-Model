% TEST 2
% point above right treads (high elbow is the idea)
targetXYZ = [-1 -9 2.5];
side = 'right';
task = 'naive';
speed = 20;

MainController;

if(taskTable.loadFactor >= 1)
    taskTable = resize(taskTable);
end