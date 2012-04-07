%Divya Gunasekaran
%May 5, 2011

function [] = UpdateGoalFace(faceIndex, start, goal, B, n)

global FacesArray;

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
    side = GetFaceSide(B,n,nbrFace);
    %For faces that are neither start nor goal, get the point on the face
    %closest to the goal
    if(nbrFace~=start && nbrFace~=goal)
        [rhs,xyz] = GetRHSFace(nbrFace,side,fromPt,goal,start,B,1);
        FacesArray{nbrFace}.point = xyz;
    end
end

   