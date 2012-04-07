
%Close connection to the robot
pnet('closeall');
if(exist('sock', 'var'))
    disp('Connection closed');
    clear sock;
end