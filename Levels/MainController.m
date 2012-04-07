% ######################
% ### INITIALIZATION ###
% ######################

% make sure initMBPP was run first (also fillSelfObstacles is recommended)
if(~(exist('B', 'var')));
    initMBPP;
    B = fillSelfObstacles(B);
end

% save original state of B if not already done
if(~(exist('B_orig', 'var')));
    B_orig = B;
end

% check to see if it was specified whether robots or internal-simulation is
% being used
%   not using the robot also prevents plots and pauses

if(~exist('use_robot', 'var'))
    use_robot = false;
    % default to quick internal simulation
end

% make sure a servo controller was loaded (if using robot)
if(use_robot && ~(exist('servo_controller', 'var')));
    eval(['load(''servo_stats_' num2str(get_current_robo_num()) ''')']);
    servo_controller = rps_to_speed;
    clear rps_to_speed;
end

% Cell Dimensions
w = B(1).width;
l = B(1).length;
h = B(1).height;

% general info on servos (used throughout code):
[servo_bounds, ideal_pos, servoNames, ideal_rad] = get_servo_info();

% Get robot's current starting posture
if(use_robot)
    allAngles = GetCurrPosture(sock);
%     curPosture = partial_posture_to_full(allAngles, side);
else
    if(~exist('curPosture', 'var'))
        allAngles = ideal_rad;
        % default to 'zero' position    
        % NOTE: may change this to selecting random posture from starting cell
        % as defined in whichever script/function calls this one
    else
        allAngles = partial_posture_to_full(curPosture,side);
    end
    
end

% Calculate xyz coordinates of starting position and reduce angles depending
% on side (right or left) of arm

[right left rightJts leftJts] = ForwardKinematics_V5(allAngles);
curPosture = full_posture_to_partial(allAngles, side);

if(strcmp(side, 'right'))
    startXYZ = right;
elseif (strcmp(side, 'left'))
    startXYZ = left;
else
    disp('Error: please specify left or right side');
    return;
end

% Get cell indices of initial and final positions, which will be used as
% keys for movement lookup and storage
[~, ~, ~,key1] = findCell(startXYZ, n, w, l, h);
[~, ~, ~,key2] = findCell(targetXYZ, n, w, l, h);
key = [key1, key2];

tStart = tic; % for timing duration of processes

% #################
% ### MAIN LOOP ###
% #################

% Loop variables
path = [];	% Nx3 points for end effector
movement = [];          % Nx7 positions for servos on given side
collision_locs=NaN(1,3);% Mx3 points in B where collisions occured
done = false;           % loop control
planned = false;        % true if level 3 or 4 has run
generated = false;      % true if valid movement generated by level 2
adjusted = false;       % true if 
level = 1;              % the actual level var used by switch statement

num_simple_plan = 0;    % count # times level 3 executed
max_simple_plan = 2;    % after this many tries with level 3, go to level 4

hlevel = 0;
level4 = 0;

while(~done)
    
    level_time_stats(level_stats_index,1) = level;
    tstart = tic();
    
    switch(level)
        
        % ################################
        % ### LEVEL 1 - MEMORY LOOK-UP ###
        % ################################
        
        case 1
            disp('Level 1 entered');
            
            retMovement = [];
            
            % ############################
            % ### MEMORY & ADJUSTMENTS ###
            % ############################
            
            % If not given movement nor path yet, check memory
            if(isempty(movement) && isempty(path))
                
                disp('Looking up stored movements...');


                % if memory lookup failed, go to level 2
                if(isempty(retMovement))
                    disp('No usable movements found. Going to level 2...');
                    level = 2;
                    
                    if(exist('test_sequence', 'var'))
                        level_time_stats(level_stats_index,2) = 0;
                    end
                % If we find a movement whose score is above the min threshold
                else
                    
                    
                    movement = retMovement;
                    
                    level = 0; % 2
                    
                    if(exist('test_sequence', 'var'))
                        level_time_stats(level_stats_index,2) = 2;
                    end
                end
            end
            
        case 0
            
            % ##########################
            % ### MOVEMENT EXECUTION ###
            % ##########################
            
            if(~isempty(movement))
                
                % Check if movement is collision-free, simultaneously
                % getting info on collision locations (used by level 3)
                [is_valid collision_locs] = CheckMovement(B, movement, side);
                if(~is_valid)
                    disp('Stored movement results in collisions. Going to level 2...');
                    
                    movement = [];
                    level = 2;
                    
                    
                    if(exist('test_sequence', 'var'))
                        level_time_stats(level_stats_index,2) = -1;
                    end
                end
                
                
                % starting movement execution - stop algorithm timer
                tElapsed = toc(tStart);
                
                if(exist('test_sequence', 'var'))
                    level_time_stats(level_stats_index,2) = level_time_stats(level_stats_index,2) + 3;
                end
                
                % for safety, allow user to see movement before enacting
                if(use_robot)
                    plot_movement_stills(B, movement, side);
                    title('Enacting this Movement: Press ctrl+C to quit');
                    pause;
                end
                
                % PHYSICALLY ENACT MOVEMENT
                if(use_robot)
                    % smooth movement
                    EnactMovement2(sock, movement, side, 1.5, servo_controller);
                    %                     % non-smooth movement
                    %                     EnactMovement(sock, movement, speed, side);
                else
                    % if not using robot, just update to end posture
                    curPosture = movement(end, :);
                end
                
                % UPDATE INTERNAL REPRESENTATION OF OBSTACLES
                % (if not doing a sequenced test, since new posture is not used)
                if(~exist('test_sequence', 'var'))
                    B = update_self_obstacles(B, movement(end,:));
                end
      
                Mov = addtoM(movement,task,side,Mov)
                
                % Algorithm Finished
                disp('Target achieved.');
                done = 1;
                
                % We have a path, but not a movement
                % Go to Level 2 for movement generation given a path
            else
                disp('Path available, but no movements. Going to level 2...');
                level = 2;
                
                if(exist('test_sequence', 'var'))
                    level_time_stats(level_stats_index,2) = 3;
                end
            end
            


        % #####################################
        % ### LEVEL 2 - MOVEMENT GENERATION ###
        % #####################################
        
        case 2

            disp('Level 2 entered');

            % If a path is available, generate a movement for that path and
            % store it
            if(isempty(path))
                path = [startXYZ; targetXYZ];
            end
    
            % Generate movement from path
            [B, movement] = GenMovement(B, curPosture, path, side, thresh);

            % increase resolution of movement by linearly interpolating 
            % postures (makes checking collisions and visualization easier)
            movement = break_down_movement(movement, pi/64);

            % check for collisions
            [is_valid collision_locs failed_posture] = CheckMovement(B, movement, side);
            
            if(~is_valid && use_robot)
                obs_com = mean(collision_locs, 1);
                fig = plot_posture(B, ...
                    partial_posture_to_full(failed_posture, side), 'full');
                plot_3D_axes_thru_point(obs_com, [-10 10], fig);
                title('Level 2: Posture that Results in Collision');
            end
            
            if(use_robot)
                fig = plot_movement_stills(B, movement, side);
                [~, handle] = plot_path(B, path, [0 0 0], fig);
                set(handle, 'LineWidth', 2);
                title('Level 2 Movement for Path');
            end
            
            if(exist('test_sequence', 'var'))
                level_time_stats(level_stats_index, 2) = is_valid;
            end
            
            % Could not generate a collision-free movement
            if(isempty(movement) || ~is_valid)
                % either go to level 3 or 4, depending on number of
                % times level 3 was attempted.
                if(num_simple_plan < max_simple_plan)
                    disp('Level 2 failed. Trying level 3');
                    level = 3;
                else
                    disp('Could not generate a collision-free movement. Going to level 4.');
                    level = 4;
                    
                    
                    % ##########
                    %                         fig = plot_movement_stills(B, movement, side);
                    %                         [~, handle] = plot_path(B, path, [0 0 0], fig);
                    %                         if(~is_valid)
                    %                             obs_com = mean(collision_locs, 1);
                    %                             plot_3D_axes_thru_point(obs_com, [-10 10], fig);
                    %                         end
                    %                         set(handle, 'LineWidth', 2);
                    %                         title('Level 2 Movement for Path');
                    %                         pause;
                    % ##########
                    
                end
                
                % collision-free movement generated - enact it.
            else
                generated = 1;
                level = 0;
            end
            
            % #################################
            % ### LEVEL 3 - SIMPLE PLANNING ###
            % #################################
            
        case 3
            
            disp('Level 3 entered');
            
            % WAYPOINTS ALGORITHM
            collisions_com = mean(collision_locs, 1);
            
            % if path has at least 2 points, build from that
            if(exist('path', 'var') && size(path, 1) >= 2)
                [new_path is_valid wp_ind type_wp] = add_waypoints_2(B, path, collisions_com);
                
                % otherwise, initialize path to [start; goal] and add waypoints
                % from there
            else
                [new_path is_valid wp_ind type_wp] = add_waypoints_2(B, [startXYZ; targetXYZ], collisions_com);
            end
            
            if(exist('test_sequence', 'var'))
                level_time_stats(level_stats_index,2) = type_wp;
            end
            
            if(~isempty(wp_ind))
                % cut corners from new waypoint to end (do not remove
                % most recently added point)
                first_wp = min(wp_ind);
                path = vertcat(new_path(1:first_wp-1, :), ...
                    cut_path_corners(B, new_path(first_wp:end, :)));
            else
                path = new_path;
            end
            
            num_simple_plan = num_simple_plan + 1;
            level = 2;
            
            if(use_robot)
                plot_path(B, path);
                title(['path generated from ' num2str(num_simple_plan) ...
                    ' iteration(s) of waypoint algorithm (CORNERS CUT)']);
            end
            
            
            % ##################################
            % ### LEVEL 4 - COMPLEX PLANNING ###
            % ##################################
            
        case 4
            
            tic
            
            level4 = level4 + 1;
            
            disp('Level 4 entered');
            
            if level4 == 2,
                disp('break out')
                level = 5;
                
                done = -1;
                disp('No path exists. Target is unreachable.');
                
                if(exist('test_sequence', 'var'))
                    % if unsuccessful, tag '-1'
                    level_time_stats(level_stats_index,2) = -1;
                end
                
            else
                 
                 
                curPostureFull = allAngles;
                
                [path,movement,tElapsed,Bmod] = A_ComputePath(curPostureFull,targetXYZ,B,thresh);
                
                movement = break_down_movement(movement, pi/16);
                is_valid = CheckMovement(B,movement,side);
                planned = 1;
                
                %If movement is valid, go to Level 1 to enact it
                %path
                if(is_valid)
                    level = 0;
                    if(use_robot)
                        plot_path(B, path);
                    end
                    
                    if(exist('test_sequence', 'var'))
                        % if successful forward, tag '1'
                        level_time_stats(level_stats_index,2) = 1;
                    end
                    %Else no path exists
                end
               
            end
                 
                 
%                 % ##########
%                 fig = plot_movement_stills(B, movement, side);
%                 [~, handle] = plot_path(B, path, [0 0 0], fig);
%                 if(~is_valid)
%                     obs_com = mean(collision_locs, 1);
%                     plot_3D_axes_thru_point(obs_com, [-10 10], fig);
%                 end
%                 set(handle, 'LineWidth', 2);
%                 title(['Level 4 Movement for Path. Validity: ' num2str(is_valid)]);
%                 pause;
%             % ##########

toc

%DEFAULT
otherwise
    disp('Error: Main controller entered nonexistent level');
    level_stats_index = level_stats_index + 1;
    level_time_stats(level_stats_index,:) = [0 0 0];
    done = -1;
    return;
end

tstop=toc(tstart);
hlevel,level
hlevel = max(hlevel,level)
level_time_stats(level_stats_index,end) = tstop;
level_stats_index = level_stats_index + 1;
fprintf('\n\n ======= level completed =======\n\n');

if(use_robot)
    pause;
end
close all;

end

level_stats_index = level_stats_index + 1;
level_time_stats(level_stats_index,:) = [0 0 0];
