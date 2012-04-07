function M = registermovement(movement, M, type, startpoint, endpoint)

[numpos,~] = size(movement);

for i = 1:numpos,
    
   path(i,:) = ForwardKinematics_V5(nextposture);

end

dx=diff(path(1,:));
dy=diff(path(2,:));
dz=diff(path(3,:));

% sum absolute values of the changes to get vector magnitude of change (square of the distance)
mag=[sqrt(dx.^2 + dy.^2 + dz.^2) 0];

Saccades.mag = mag;

v1 = [dx 0; dy 0; dz 0];
v2 = [0 dx; 0 dy; 0 dz];

angles = acosd(sum(v1.*v2)./sqrt(sum(v1.^2).*sum(v2.^2)));

cumdx = cumsum(dx);
cumdy = cumsum(dy);

anglemag=[sqrt(cumdx.^2 + cumdy.^2)./(1:length(cumdx)) 0];

for i = 1:numpos,
    
            M(i).type = type;
            M(i).currentposture = [];
            M(i).direction = angles(i);
            M(i).endpoint = [];
            M(i).startpoint = [];
            M(i).lastcell = [];
            M(i).nextcell = [];
            M(i).lastposture = [];
            M(i).nextposture = [];
            M(i).speed = [];
            M(i).center = [x, y, z];
            M(i).x = x;
            M(i).y = y;
            M(i).z = z;
            M(i).index = 1;

            
end