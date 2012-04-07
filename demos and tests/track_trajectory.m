% [r_gripper, l_gripper, angles, delays] = track_trajectory(total_time,t_interval, sock, skip_servos)
%
% Richard Lange
% August 10, 2011
% 
% function to track brainbot arm trajectories through time
% useful for motion capture
%
% INPUTS:
%   total_time = time, in seconds, to record
%   t_interval = time interval between measurements. (NOTE: this is the 
%    amount of pause time in each loop. does not account for inherent delay 
%    in measurements
% 
% OUTPUTS: [x y z] are across the rows. N positions recorded for M joints
%   r_gripper = Nx3 matrix of positions of right gripper
%   l_gripper = likewise for left
%   curAngles = Nx7 = current joint angles (in radians) through time
%   skip_servos = servos to ignore (use if overheating, for example).

function [r_gripper, l_gripper, angles, delays] = track_trajectory(total_time, t_interval, sock, skip_servos)

if(nargin < 4)
    skip_servos = {};
end

min_t_interval = 0.2;
if(t_interval < min_t_interval)
    t_interval = min_t_interval;
    fprintf('setting t_interval to %f. any faster causes connection problems.\n', t_interval);
end

N = total_time / t_interval;
tstart_all = tic;

% r_gripper = zeros(N, 3);
% l_gripper = zeros(N, 3);
% r_joints = zeros(M, N, 3);
% l_joints = zeros(M, N, 3);

i = 1; % keep track of index

% 'old angles' set to ideal positions initially so that if any servos are
% skipped, they are set to their ideal position automatically
[~,~,~,old_angles] = get_servo_info();
M = length(old_angles);

delays = zeros(1, N);
angles = repmat(old_angles,N,1);
r_gripper = zeros(N,3);
l_gripper = zeros(N,3);

while(i <= N) % && toc(tstart_all) < total_time)
    fprintf('recording posture %d\n', i);
    tstart = tic();
    cur_angles= GetCurrPosture(sock, old_angles, skip_servos);
    delays(i) = toc(tstart);
    [cur_rg, cur_lg, ~, ~] = ForwardKinematics_V5(cur_angles);
    
    r_gripper(i, :) = cur_rg;
    l_gripper(i, :) = cur_lg;
    angles(i, :) = cur_angles;
    
    i = i+1;
    old_angles = cur_angles;
    
    pause(t_interval);
end

robo_disconnect;

end