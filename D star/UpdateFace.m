%Divya Gunasekaran
%May 5, 2011

function updated = UpdateFace(faceIndex, start, goal, B, n)

global FacesArray;


%Constant representing infinity
inf = 1000000;
minRHS = inf;
minXYZ = [];
minNbr = NaN;

if(faceIndex~=goal)
    %Get adjacent faces
    %point = FacesArray{faceIndex}.center;
    if(numel(FacesArray{faceIndex}.point))
        fromPt = FacesArray{faceIndex}.point;
    else
        fromPt = FacesArray{faceIndex}.center;
    end
    [adjFaces,side] = Succ(faceIndex, fromPt, B, n);
    
    
    %For each adjacent face
    for i=1:numel(adjFaces)
        nbrFace = adjFaces(i);
        %If goal estimate not infinity
        %Calculate look ahead cost (rhs) to neighboring face
        if(FacesArray{nbrFace}.g < inf)
            side = GetFaceSide(B,n,nbrFace);
            if(nbrFace~=start && nbrFace~=goal && ~numel(FacesArray{nbrFace}.point))
                [rhs,xyz] = GetRHSFace(nbrFace,side,fromPt,goal,start,B,1);
                %FacesArray{nbrFace}.point = xyz;
            elseif(nbrFace==goal)
                rhs = euclidDist(FacesArray{faceIndex}.point,FacesArray{goal}.point);
            else
                rhs = FacesArray{nbrFace}.g ...
                    + euclidDist(FacesArray{faceIndex}.point,FacesArray{nbrFace}.point);
            end
            if(rhs < minRHS)
                minRHS = rhs
               % minXYZ = xyz
                minNbr = nbrFace
            end
        end
    end
    if(minRHS<inf)
        FacesArray{faceIndex}.rhs = minRHS;
        %FacesArray{faceIndex}.point = minXYZ;
        [k1,k2] = CalculateKey(faceIndex,start)
        FacesArray{faceIndex}.k1 = k1;
        FacesArray{faceIndex}.k2 = k2;
        FacesArray{faceIndex}.next = minNbr;
        str = ['Face ', num2str(faceIndex), ' updated with above values'];
        disp(str);
        updated=1;
    else
        str = ['Face ', num2str(faceIndex), ' not updated'];
        disp(str);
        updated=0;
    end
else
    disp('Goal face not updated');
    updated=0;
end