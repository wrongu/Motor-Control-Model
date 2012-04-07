%helper function for ForwardKinematics function

function A = AffineTransform(angle,axis,dist)

R = rotationmat3D(angle,axis);

A = [[R, dist'];[zeros(1,length(dist)), 1]];

end