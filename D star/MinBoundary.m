%Divya Gunasekaran
%May 3, 2011

%corner1, corner2 = struct('pos',[x y z], 'g', int);
%corner1 and corner2 in specific order according to face coordinates

function [t,d3] = MinBoundary(corner1,corner2,fromPt)

dist1 = corner1.pos - fromPt;
dist2 = corner2.pos - fromPt;

diff = dist1 - dist2;
deltaDim = find(diff~=0);
index3 = deltaDim(1);

edgeLen = abs(corner1.pos(index3) - corner2.pos(index3));

%If fromPt is closer to corner1
if(abs(corner1.pos(index3)-fromPt(index3)) <= edgeLen/2)
    pos1 = corner1.pos;
    pos2 = corner2.pos;
    g1 = corner1.g;
    g2 = corner2.g;
    b = euclidDist(corner1.pos,fromPt);
    c = euclidDist(corner2.pos,fromPt);
%Else fromPt is closer to corner2
else
    pos1 = corner2.pos;
    pos2 = corner1.pos;
    g1 = corner2.g;
    g2 = corner1.g;
    c = euclidDist(corner1.pos,fromPt);
    b = euclidDist(corner2.pos,fromPt);
end


if(g1 <= g2)
    d3=pos1(index3);
else
    f = g1 - g2;
    if(f <= b)
        if(c <= f)
            d3 = pos2(index3);
        else
            y = min(f/sqrt(c^2 - f^2),edgeLen);
            if(pos1==corner1.pos)
                t = y;
                d3 = [];
                return;
            else
                t = edgeLen - y;
                d3 = [];
                return;
            end
        end
    else
        if(c <= b)
            d3 = pos2(index3);
        else
            %NOTE: in this case, we travel along bottom edge for a distance
            %x and then take a straight-line path directly to corner2
            %This is NOT currently implemented; instead, we take
            %straightline path to corner2
            x = edgeLen - min(b/sqrt(c^2-b^2),edgeLen);
            d3 = pos2(index3);
        end
    end
end

t = abs(d3-corner1.pos(index3));
