%Divya Gunasekaran
%May 16, 2011

%Rate movements based on two costs: spatial error cost and a travel cost,
%as given by Rosenbaum (2001). 
    %Spatial error cost is based on the Euclidean
%distance between the xyz-position of the final posture in the movement and
%the xyz-position of the final point in the path. An ideal spatial error
%cost is 0, but we add 1 so that an ideal spatial error cost is 1 and
%unideal spatial error costs are greater than one.
    %Travel cost is based on joint angular displacement. 
%In our rating system, we divide the sum of the
%travel costs across the intermediate postures by the travel cost from the
%start posture to the final posture.  Therefore, the ideal travel cost
%rating will be 1 and unideal travel cost ratings will be greater than 1.
    %We take the reciprocal of each cost and weight each cost. The rating
%of the movement is the sum of these costs. Therefore, higher ratings are
%more desirable.

function rating = RateMovement(movement,final,side,weight_s,weight_v)

numPostures = size(movement,1);

padding = zeros(1,4);

%Determine the xyz-coordinates of the final posture and use it to calculate
%the spatial error cost
if(strcmp(side,'right'))
    finalPosture = [movement(end,:) padding];
    [right,~,~,~] = ForwardKinematics_V5(finalPosture);
    spatialCost = euclidDist(right,final);
elseif(strcmp(side,'left'))
    finalPosture = [movement(end,1:3) padding movement(end,4:7)];
    [~,left,~,~] = ForwardKinematics_V5(finalPosture);
    spatialCost = euclidDist(left,final);
else 
    disp('Error: Please enter right or left for side');
    return;
end

%Calculate the travel cost
%displaceSum = 0;
travelCostSum = 0;

for i=1:numPostures-1
    posture = movement(i,:);
    nextPosture = movement(i+1,:);
    
    %displaceSum = displaceSum + sum(abs(posture-nextPosture));
    travelCostSum = travelCostSum + TravelCost(posture,nextPosture);
end

%rating = displaceSum / sum(abs(movement(1,:)-movement(end,:)));
travelRating = (TravelCost(movement(1,:),movement(end,:))/travelCostSum)*weight_v;
spatialRating = weight_s/(spatialCost+1);
rating = travelRating + spatialRating;

