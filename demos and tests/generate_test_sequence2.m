% test_sequence = generate_test_sequence(B_orig, num_trials, task, side)
%
% returns a (num_trials x 1) struct test_sequence with fields
%   start_posture   1x7 joint angles (the usual)
%   goal_point      1x3 goal point [x y z]
%   obstacles        1xM obstacle struct, where M is # of obstacles:
%                       anywhere between 0 and 3
%
% written by Richard Lange 
% December 8, 2011

function test_sequence = generate_test_sequence2(B_orig, num_trials, task, side, max_num_obs)
    test_sequence = struct('start_posture', zeros(1,7), 'goal_point', ...
        [0 0 0], 'obstacles', obstacle_new(1,1,1));
    
    % need B_orig dimensions for findCell
    n = size(B_orig, 1);
    w = B_orig(1).width;
    l = B_orig(1).length;
    h = B_orig(1).height;
    
    % get goal space
    [goal_center goal_span] = get_goal_space_by_task(task, side);
    
    % get all free postures now so they can be sorted and filtered
    disp('pulling out all postures');
    if(strcmp(side, 'right'))
        all_postures = vertcat(B_orig.r_postures);
    else
        all_postures = vertcat(B_orig.l_postures);
    end
    
%     % remove postures that have collisions by filtering with
%     % 'CheckPostureCollisions' function
%     disp('filtering by collisions');
%     all_postures = all_postures(arrayfun(@(i) CheckPostureCollisions(B_orig, all_postures(i,:), side), 1:length(all_postures)),:);
    
    % sort postures by increasing absolute-value torsoyaw (so postures
    % facing forward are the first entries)
    disp('sorting postures')
    abs_postures = abs(all_postures);
    [~, sort_inds] = sort(abs_postures);
    all_postures = all_postures(sort_inds(:,1), :);
    
    for i=1:num_trials
        if(mod(i,10) == 0)
            fprintf('Generating test %d\n', i);
        end
        % reset B
        B = B_orig;
        
        % ########################
        % ### RANDOM OBSTACLES ###
        % ########################
        
        % random number of obstacles
        M = round(rand*max_num_obs);
        for j=1:M
            obstacle = obstacle_new(4, 1.5, 8);
            test_sequence(i,1).obstacles(j,1) = obstacle;
            B = points_to_obstacles(B, obstacle_to_points(obstacle, w/2));
        end
        
        % ############################
        % ### RANDOM START POSTURE ###
        % ############################
        
        % keep picking a posture from known postures until a free one is
        % found
        posture_in_obstacle = true;
        count = 1;
        while(posture_in_obstacle)
%             fprintf('pick start posture, loop %d\n', count);
            count = count+1;
            % pick random cell that is free, weight towards zeros by
            % cubing random number
            rand_ind = floor(rand^3*size(all_postures,1))+1;
            posture = all_postures(rand_ind,:);

            % check if posture is free
            posture_in_obstacle = ~CheckPostureCollisions(B, posture, side);

        end
        % save posture to struct
        test_sequence(i,1).start_posture = posture;
        
        % ###################
        % ### RANDOM GOAL ###
        % ###################
        
        % generate goal point in spannable space that is not in an obstacle
        goal_in_obstacle = true;
        while(goal_in_obstacle)
            goal_pt = goal_center + ...
                (rand*2-1)*goal_span(1,:) + ...
                (rand*2-1)*goal_span(2,:) + ...
                (rand*2-1)*goal_span(3,:);
            [~,~,~,ind] = findCell(goal_pt, n,w,l,h);
            goal_in_obstacle = (B(ind).obstacle ~= 0);
        end
        % save goal to struct
        test_sequence(i,1).goal_point = goal_pt;
    end
end