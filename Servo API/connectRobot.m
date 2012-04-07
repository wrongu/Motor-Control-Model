%Divya Gunasekaran
%Jan 26, 2010
%Robot functions

%Function to create a connection to robot

%Inputs
    %ip = IP address of robot, data type should be string
    %port = port number of robot to bind to

function[sock] = connectRobot(ip, port)

    sock = pnet('tcpconnect', ip, port);

end

