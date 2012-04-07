%%Divya Gunasekaran
%%October 8, 2010

%Playing around with cells and structs

clear all

%Struct containing fields defining the cell
%Fields include center of cell (x, y) coordinate, width and height of cell,
%vector or array of registered postures, and the registration rate (?).
s = struct('center', [0, 0], 'width', 0, 'height', 0, 'r_postures', [0 0 0 0], 'l_postures', [0 0 0 0]);

%nxn cell array. Each cell holds the above struct
n=500;
A=cell(n); 

%Width and height of each cell
w = 20;
h = 20;

%Initialize variables holding centers of cells to zero
x=0;
y=0;

%Initialize cell array with centers, width, and height of each cell 
for i=1:n
    if (i == 1)
            y=-h*floor(n/2) + h/2;
        else
            %y = h*i -(h/2);
            y = y + h;
        end
    for j=1:n
        A{i, j} = s;
        %Compute the centers of each cell
        if (j==1)
            x=-w*floor(n/2) + w/2;
        
        else
            %x = w*j - (w/2);
            x = x + w;
        end
        
        A{i, j}.center = [x, y];
        A{i, j}.width = w;
        A{i, j}.height = h;
    end
end

i=1; %count of while loop iterations
continueReg = 0; 
cycleLimit = 100;
numRegPostures = 0;
numCycles = 0;
curr_regRate=0;
lambda = 50; %threshold for min difference between postures
             %randomly chosen right now
sigma = .05; %threshold for min difference between registration rates
           %randomly chosen right now

%For Graphing
numGenPosturesTotal = 0; %total number of postures generated -- unnecessary...
numRegPosturesTotal = 0; %total number of postures registered

vectorLength = n;
genPosturesVector = NaN(1, vectorLength); %vector of x-axis values
regPosturesVector = NaN(1, vectorLength); %vector of y-axis values


%While cells are not saturated
while(continueReg == 0)
    
    %Randomly generate a posture in angles
    newPosture = generatePosture();
    
    %CHECK BALANCE CONSTRAINTS HERE--NOT IMPLEMENTING
    
    %USE KINEMATICS EQUATIONS TO DETERMINE (x,y,z) FROM ANGLES
    %Using same set of angles for left and right arm
%    [leftArmCoord, rightArmCoord] = ForwardKinematics([newPosture newPosture]);
    
    leftArmCoord = ForwardKinematics(newPosture);
    leftArmCoord(1) = -leftArmCoord(1);
    
    rightArmCoord = ForwardKinematics(newPosture);
    
    %Find cell that the posture belongs to based on (x,y,z) coordinates
    [i_left, j_left] = findCell(leftArmCoord(1), leftArmCoord(2), leftArmCoord(3), n, w, h);
    [i_right, j_right] = findCell(rightArmCoord(1), rightArmCoord(2), rightArmCoord(3), n, w, h);
    
    %Check newly generated posture against each of cell's registered
    %postures and store it if posture is distinct
    [A{i_left, j_left}.l_postures, storePosture_left] = checkPostureRedundancy(A{i_left, j_left}.l_postures, newPosture, lambda);
    [A{i_right, j_right}.r_postures, storePosture_right] = checkPostureRedundancy(A{i_right, j_right}.r_postures, newPosture, lambda);
    
    
    %Keep track of number of registered postures for this cycle
    numRegPostures = numRegPostures + storePosture_left + storePosture_right;
    
    %Keep track of total number of generated and registered postures
    numGenPosturesTotal = numGenPosturesTotal + 2; %one posture for right arm, one posture for left arm
    numRegPosturesTotal = numRegPosturesTotal + storePosture_left + storePosture_right;    
    
    %Increment count of cycles
    numCycles = numCycles + 1;
    
    
    %If cycle limit has been reached
    if (numCycles == cycleLimit)
        %Calculate new registration rate
        [continueReg, curr_regRate] = checkRegRate(curr_regRate, numRegPostures, numCycles, sigma);
        %Reset count of cycles and registered postures
        numCycles = 0;
        numRegPostures = 0;
    end
    
    %Store total number of generated and registered postures in vector
    %if vectors are not full
    if (i <= vectorLength || i <= vectorLength)
        genPosturesVector(i) = numGenPosturesTotal; 
        regPosturesVector(i) = numRegPosturesTotal;
    %else if vectors are full
    else
        %double current size of vectors
        genPosturesVector  = [genPosturesVector NaN(1, vectorLength)];
        regPosturesVector  = [regPosturesVector NaN(1, vectorLength)];
        %update length of vector
        vectorLength = length(genPosturesVector); 
    end
    
    %increment count of while loop iterations
    i = i + 1;
    
end


%truncate size of vectors if there are unused values
genPosturesVector(i:end) = [];
regPosturesVector(i:end) = [];    

%plot growth
plot(genPosturesVector, regPosturesVector);
    
