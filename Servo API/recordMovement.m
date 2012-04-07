robo_connect

for i = 1:5,
    
    input('Press any key')
    
    [~, ~, angles, ~] = track_trajectory(5, .2)
    
    Movements(i) = {angles}
    
end