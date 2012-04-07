% testing file for the self-intersection obstacle code

close all;
clear all;
clc;

initMBPP;

B = fillSelfObstacles(B);

plot_obstacles(B)