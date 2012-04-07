sock = robo_connect(2)

for i = 1:5,
    
    input('Press any key')
    
    [~, ~, angles, ~] = track_trajectory(5, .2, sock)
    
    Movements(i) = {angles}
    
end