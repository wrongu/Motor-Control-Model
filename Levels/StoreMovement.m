%Divya Gunasekaran
%May 16, 2011

%Store a movement and all subsets of that movement in the given HashTable

function StoreMovement(B,taskTable,movement,side,thresh,weight_s,weight_v)

n = size(B, 1);
w = B(1).width;
l = B(1).length;
h = B(1).height;

numPostures = size(movement,1 );

%i is the index of the starting posture of the movement to be stored
for i=1:(numPostures-1)
    %j is the index of the final posture of the movement to be stored
    for j=(i+1):numPostures
        
        %Calculate start point and cell index of start point
        startPosture = movement(i,:);
        start = GetPosturePosition(startPosture, side);
        [~,~,~,key1] = findCell(start, n, w, l, h);
        
        %Calculate final point and cell index of final point
        finalPosture = movement(j,:);
        final = GetPosturePosition(finalPosture, side);
        [~,~,~,key2] = findCell(final, n, w, l, h);
        
        %Get movement and rating
        mvmtToStore = movement(i:j,:);
        rating = RateMovement(mvmtToStore,final,side,weight_s,weight_v);
        
        %Create the struct holding the data that will be stored 
        data.init = start;
        data.final = final;
        data.key = [key1,key2];
        data.movement = mvmtToStore;
        data.score = rating;
        
        %Add the entry to the given HashTable
        addEntry(taskTable,[key1,key2],data,thresh);
        
        %Add the reverse of that movement
        backMvmt = movement(j:i,:);
        backRating = RateMovement(mvmtToStore,final,side,weight_s,weight_v);
        
        data.init = final;
        data.final = start;
        data.key = [key2,key1];
        data.movement = backMvmt;
        data.score = backRating;
        
        %Add the reverse movement to the given HashTable
        addEntry(taskTable,[key2,key1],data,thresh);
        
    end
end