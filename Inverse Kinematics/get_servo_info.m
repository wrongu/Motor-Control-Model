% Richard Lange
% August 18, 2011
%
% OUTPUTS:
%   bounds = safe range of values for servos to live
%   ideal = hardcoded 'comfortable' position for each servo
%   names = servo names
%
% 1: TorsoYaw
% 2: TorsoPitchOne
% 3: TorsoPitchTwo*
% 4: RightShoulderRotator*
% 5: RightShoulderPitch*
% 6: RightElbow*
% 7: RightWrist*
% 8: LeftShoulderRotator
% 9: LeftShoulderPitch
% 10: LeftElbow
% 11: LeftWrist
% 12: HeadPitch
% 13: HeadYaw
%
% * indicates servos whose positive direction of ticks corresponds to a
% negative angle change

function [bounds ideal servoNames ideal_rad] = get_servo_info()
    
    servoNames = {'TorsoYaw', 'TorsoPitchOne', 'TorsoPitchTwo', ...
        'RightShoulderRotator', 'RightShoulderPitch', 'RightElbow', 'RightWrist', ...
        'LeftShoulderRotator', 'LeftShoulderPitch', 'LeftElbow', 'LeftWrist', ...
        'HeadPitch', 'HeadYaw'};
    
    full_range = [0, 1024];
    bounds = {full_range, [500,525], [500,525], ...
        full_range, [170, 829], [24, 544], full_range, ...
        full_range, [195, 854], [480, 1000], full_range, ...
        [412 612], [412 612]};

    %ideal = [512, 512, 512, 490, 490, 490, 512, 534, 534, 534, 512, 512, 512];
    ideal = [512, 512, 512, ... torso
        512, 512, 512, 815, ... right arm
        512, 512, 512, 815, ... left arm
        512, 512];            % head
    ideal_rad = (ideal - 512) * (300 / 1024) * (pi / 180);
end