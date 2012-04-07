% EnactMovement2 uses the servo_controller struct to dynamically set speeds
% (see calibrate_servo_speeds) and create a more fluid movement than the
% original EnactMovement function

function EnactMovement2(sock, movement, side, timestep_per_rad, servo_controller)

    numPostures = size(movement,1);
    
    [~,zeros,full_servo_names] = get_servo_info;
    servo_names = full_posture_to_partial(full_servo_names, side);
    zeros = full_posture_to_partial(zeros, side);
    
    disp('Enacting movement.')
    for i=2:numPostures
        % get all positions
        this_posture = movement(i,:);
        posture_travel = abs(this_posture - movement(i-1,:));
        
        max_travel = max(posture_travel);
        timestep = max_travel * timestep_per_rad;
        
        for j=1:length(this_posture)
            name = servo_names{j};
            speed = get_speed_by_dist_time(posture_travel(j), timestep, name, servo_controller);
            pos = round(radians_to_ticks(this_posture(j), zeros(j)));
            
            moveServo(sock, name, speed, pos);
        end
%         pause(timestep);
    end
end