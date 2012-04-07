%Daniel Muldrew
%October 22, 2010

%Function  for converting angles to (x,y,z) position for left and
%right arms

%angles is currently a vector of length 4
 

function point = ForwardKinematics(angles)

state = AugmentedMat(eye(3), zeros(1,3));

state = AffineTransform(-angles(1),state(1:3,2),[.5 -1 0]) * state;

state = AffineTransform(-angles(2),state(1:3,3),[0 -4.125 0]) * state;

state = AffineTransform(-angles(3),state(1:3,3),[0 -7.75 0]) * state;

state = AffineTransform(-angles(4),state(1:3,2),[0 0 0]) * state;

point = state(1:3,4);

end

