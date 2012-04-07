% Richard Lange
% July 27 2011

% brainbot wakeup - put servos all in 512

function success = zero_servos(sock)

    [~, ideal, servoNames] = get_servo_info();

    for p=1:numel(servoNames)
        servo = servoNames{p};
        ideal_position = ideal(p);
%         disp([servo '.position=' num2str(ideal_position) ';']);
        sendStr(sock,[servo '.speed=30;'], 0.5, false);
        sendStr(sock,[servo '.position=' num2str(ideal_position) ';'], 0.5, false);
    end
    
    success=1;
end