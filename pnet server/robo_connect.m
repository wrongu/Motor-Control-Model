function sock = robo_connect(robo_number)
    switch(robo_number)
        case 1
            IP = '192.168.1.104';
        case 2
            IP = '192.168.1.115';
        case 3
            IP = '192.168.1.117';
        otherwise
            sock = robo_connect(1);
            return;
    end
        PORT = 54000;

    %Create TCP connection to robot
    sock = connectRobot(IP, PORT);
    if(sock < 0)
        fprintf('Could not connect to robot %d\n', robo_number);
        robo_disconnect;
        return;
    else
        disp('Connected to robot');
    end
end