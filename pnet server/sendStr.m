%Divya Gunasekaran
%Jan 26, 2010
%Robot functions

%Function to send string over tcp connection to robot
%and display data that the server returns

function [resp] = sendStr(sock, str, timeout, printout)

    if(nargin < 4)
        printout = true;
    end

    msg = [str, sprintf('\n\r')];
    
    if(printout)
        disp(['SEND :: ' msg]);
    end
    
    %Send string over socket
    pnet(sock, 'write', msg);

    %Block until the server finishes returning data, then display data
    resp = [];
    start = tic;
    while(isempty(resp) && toc(start) < timeout)
        resp = pnet(sock,'readline');
    end
    if(printout)
        if(isempty(resp))
            disp('TIMEOUT');
        else
            disp(['RECV :: ' resp]);
        end
    end

end


