% Richard Lange
% October 10, 2011
%
% move torsopitch servos together

function [] = torso_pitch(sock, pos)
    bounds = get_servo_info();
    bounds = bounds{1};
    
    pos = max(pos, min(bounds));
    pos = min(pos, max(bounds));
    
    str1 = ['TorsoPitchOne.position=' num2str(pos)];
    str2 = ['TorsoPitchTwo.position=' num2str(2*512-pos)];
    
    sendStr(sock, [str1 ';' str2], Inf, false);
end