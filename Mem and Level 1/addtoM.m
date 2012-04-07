function Mold = addtoM(movement,type,arm,Mold)

[len,~] = size(movement);

dx=diff(movement)
ndx = normr(dx)

mag=[sqrt(sum(dx.^2)) 0];

v1 = [dx; zeros(1,7)];
v2 = [zeros(1,7); dx];

angles = acosd(sum(v1.*v2,2)./sqrt(sum(v1.^2,2).*sum(v2.^2,2)))

%cumdx = cumsum(dx);

%anglemag=[sqrt(sum(cumdx.^2))./(1:length(cumdx)) 0];

for i = 1:len,

[rightArmCoord(i,:), leftArmCoord(i,:)] = ForwardKinematics_V5(partial_posture_to_full(movement(i,:),arm));

end

for i = 1:len,
    
    if i-1 < 1,
        
        j = [];
        k = i+1;
        
    elseif i+1 > len,
        
        j = i-1;
        k = [];
        
    else
        
        j = i-1
        k = i+1;
        
    end
    
    M(i).type = {type};
    M(i).currentposture = movement(i,:);
    M(i).direction = angles(i);
    M(i).endpoint = rightArmCoord(end,:);
    M(i).startpoint = rightArmCoord(1,:);
    M(i).lastposture = movement(j,:);
    M(i).nextposture = movement(k,:);
    M(i).jointdifference = dx(k-1,:);
    M(i).normjointdiff = ndx(k-1,:);
    M(i).rightArmCoord = rightArmCoord(i,:);
    M(i).leftArmCoord = leftArmCoord(i,:);
    M(i).x = M(i).rightArmCoord(1);
    M(i).y = M(i).rightArmCoord(2);
    M(i).z = M(i).rightArmCoord(3);
    M(i).index = i;
    M(i).nextindex = j;
    M(i).lastindex = k;
    
end

if length(Mold) ~= 1,
    
    Mold = [Mold, M];
    
end

end