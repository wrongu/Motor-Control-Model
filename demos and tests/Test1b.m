% TEST 1
% right arm to left side - requires torso
targetXYZ = [4.5 7 6.5];
side = 'right';
task = 'naive';
speed = 20;

MainController;

if(taskTable.loadFactor >= 1)
    taskTable = resize(taskTable);
end