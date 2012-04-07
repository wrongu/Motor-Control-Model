function EnactMovement(sock, movement, speed, side)
    numPostures = size(movement,1);
    disp('Enacting movement.')
    for i=2:numPostures
        fprintf('\tposture %d\n', i-1);
        EnactPosture(sock,movement(i,:),speed,side);
        pause(1);
    end
    fprintf('\n');
end