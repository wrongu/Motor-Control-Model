%Divya Gunasekaran
%Jan 28, 2010
%Robot functions

%Function to move torso
%Note: Restricting "position difference" to known safe values of <= 50 and
%>= -20.

function[iResult] = moveTorso(sock, positionDiff, speed)

%Constant
torsoBasePos = 512;

if(positionDiff <= 50 && positionDiff >= -20)
    iResult1=moveServo(sock, 'TorsoPitchOne', speed, torsoBasePos + positionDiff);
    iResult2=moveServo(sock, 'TorsoPitchTwo', speed, torsoBasePos - positionDiff);
    iResult = iResult1 || iResult2;
else
    disp('Error: Position difference is out of range of known safe values.');
    iResult = -1;
end

end