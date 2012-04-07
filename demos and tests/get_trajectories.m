
num_traj = 1;
trajectories = cell(1, num_traj);

for i = 1:num_traj,

   user_entry = input('Press any key to start recording a movement');
   tstart = tic();
   [r_gripper, l_gripper, angles] = track_trajectory(5, .2, sock, {'TorsoYaw'});
    fprintf('total time: %f seconds \n', toc(tstart));
   
   trajectories(i)  = {angles};

end