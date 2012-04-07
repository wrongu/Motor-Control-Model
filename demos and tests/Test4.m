% TEST 4
% point on other side of cameras from Test3 - testing collision avoidance
targetXYZ = [6 0 11];
side = 'right';
task = 'naive';
speed = 20;

MainController;

if(taskTable.loadFactor >= 1)
    taskTable = resize(taskTable);
end