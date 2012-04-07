% FULL DEMO/TESTING

% Before running this script, go to the parent folder and run init.m

% Richard Lange
% July 27, 2011

refresh;
use_robot = false;

if(use_robot)
    eval(['load(''servo_stats_' num2str(robo_number) ''')']);
    servo_controller = rps_to_speed;
    clear rps_to_speed;
end

% cont = input('Do you want to continue? (y or n)','s');
% if cont == 'n',
%     return
% end
 if(use_robot)
    zero_servos(sock);
 end
disp('press return when the robot is in fully-zeroed position');
pause;
Test1;
disp('Test 1 complete. press a key to continue');
pause;

Test1b;
disp('Test 1b complete. press a key to continue');
pause;

Test2;
disp('Test 2 complete. press a key to continue');
pause;

Test3;
disp('Test 2 complete. press a key to continue');
pause;

Test4;
disp('Test 2 complete. press a key to continue');
pause;


% a new round of testing from zero
 if(use_robot)
    zero_servos(sock);
 end
disp('press return when the robot is in fully-zeroed position');
pause;

Test5;
disp('Test 5 complete. press a key to continue');
pause;

robo_disconnect;