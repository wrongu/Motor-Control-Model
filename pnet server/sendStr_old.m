%Divya Gunasekaran
%Jan 26, 2010
%Robot functions

%Function to send string over tcp connection to robot
%and display data that the server returns

function[resp] = sendStr(sock, str, print)

if(nargin == 3 && print)
    disp(['SEND :: ', str]);
end

%Send string over socket
pnet(sock, 'write', [str, sprintf('\n\r')]);

%Block until the server finishes returning data
resp = [];
while ~isempty(resp);
    resp = pnet(sock,'readline');
end
%Then display data
resp = pnet(sock, 'readline');
if(nargin == 3 && print)
    disp(['RECV :: ', resp]);
end
    
end


