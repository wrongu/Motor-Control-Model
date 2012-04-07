% Richard Lange
% July 14, 2011

% For generality, this script gets the path of the root folder for this
% project on the machine that is running it and puts it into the string
% 'rootFolderPath'

rootFolderName = 'Hierarchical Motor Control';
fullpath = pwd;

ind = strfind(fullpath, rootFolderName);
rootFolderPath = fullfile(fullpath(1:ind-1), rootFolderName);

addpath(rootFolderPath);

clear fullpath rootFolderName ind;