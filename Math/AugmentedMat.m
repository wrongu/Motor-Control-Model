%helper function for ForwardKinematics

function A = AugmentedMat(axis, point)

A = [[axis, point'];[zeros(1,length(point)), 1]];

end