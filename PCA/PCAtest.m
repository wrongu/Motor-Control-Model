clc;

robo_connect;

trajectories = [];

for i = 1:5,

   user_entry = input('Press any key to start recording a movement');

   [r_gripper, l_gripper, angles] = track_trajectory(5, .25);

   trajectories(i)  = {angles};

end

%%

for i = 1:12,

trajmean(i,:) = mean([trajectories{1}(i,:);trajectories{2}(i,:);trajectories{3}(i,:);trajectories{4}(i,:);trajectories{5}(i,:)]);
trajstd(i,:) = std([trajectories{1}(i,:);trajectories{2}(i,:);trajectories{3}(i,:);trajectories{4}(i,:);trajectories{5}(i,:)]);

end

%%
% 
% for i = 1:12,
% 
% A = [trajectories{1}(i,:);trajectories{2}(i,:);trajectories{3}(i,:);trajectories{4}(i,:);trajectories{5}(i,:)];
% [COEFF,SCORE,latent,tsquare] = princomp(A);
% eigenvec(:,i) = COEFF(:,1);
% eigenvec2(:,i) = COEFF(:,2);
% 
% end


%%

for i = 1:11,

A = [trajectories{1}(1:12,i),trajectories{2}(1:12,i),trajectories{3}(1:12,i),trajectories{4}(1:12,i),trajectories{5}(1:12,i)]';
[COEFF,SCORE,latent,tsquare] = princomp(A);

eigenvec1(i,:) = COEFF(:,1);
eigenvec2(i,:) = COEFF(:,2);

end

%%

for i = 1:12,

eigentraj(i,:) = ForwardKinematics_V5(eigenvec(i,:));

end

%%

% for i = 1:12,
%
% eigentraj(i,:) = ForwardKinematics_V5(newmov(i,:));
%
% end
