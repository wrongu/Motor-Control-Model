% Divya Gunasekaran
% October 8, 2010

clear all;
clc;
close all;

initMBPP;

%{
THIS SECTION WAS COPY PASTED FROM initMBPP. initMBPP HAS SINCE BEEN CHANGED SO WE RUN IT INSTEAD.

%Width, length, and height of each cell
w = 2;
l = 2;
h = 2;

inf = 1000000;

%Struct containing fields defining the cell
%Fields include center of cell (x, y, z) coordinate, width, length, and height of cell,
%vector or array of registered postures for the right arm and for the left arm.
s = struct('center', [0, 0, 0], 'width', w, 'length', l, 'height', h, ...
    'r_postures', [0 0 0 0 0 0 0], 'l_postures', [0 0 0 0 0 0 0], ...
    'obstacle', 0, 'g',inf, 'rhs',inf, 'k1',inf,'k2',inf);

%nxnxn cell array. Each cell holds the above struct
n=20;
B=cell(n, n, n); 


%Initialize variables holding centers of cells to zero
x=0;
y=0;
z=0;

%Initialize cell array with centers, width, length, and height of each cell
for k=1:n
    if (k == 1)
            z=-h*floor(n/2) + h/2;
    else
        %y = h*i -(h/2);
        z = z + h;
    end
    for j=1:n
        if (j == 1)
            y=-l*floor(n/2) + l/2;
        else
            %y = h*i -(h/2);
            y = y + l;
        end
        for i=1:n
            B(i, j, k} = s;
            %Compute the centers of each cell
            if (i==1)
                x=-w*floor(n/2) + w/2;

            else
                %x = w*j - (w/2);
                x = x + w;
            end

            B(i, j, k).center = [x, y, z];
        end
    end
end
%}

i=1; %count of while loop iterations
continueReg = 1; 
cycleLimit = 100;
numRegPostures = 0;
numCycles = 0;
curr_regRate=0;
reg_rates = zeros(100, 1);
lambda = 1; %threshold for min difference between postures 
% (euclidean distance between radians of joint angles)
            
sigma = .6; 
% threshold for min difference between registration rates
% at last testing, 0.6 threshold resulted in 32225 postures registered (out
% of 55000 total)

%For Graphing
numGenPosturesTotal = 0; %total number of postures generated -- unnecessary...
numRegPosturesTotal = 0; %total number of postures registered

vectorLength = n;
genPosturesVector = NaN(1, vectorLength); %vector of x-axis values
regPosturesVector = NaN(1, vectorLength); %vector of y-axis values


%While cells are not saturated
while(continueReg == 1)
    
    try
    
    %Randomly generate a posture in angles (radians)
    newPosture = generatePosture();
    
    %CHECK BALANCE CONSTRAINTS HERE--NOT IMPLEMENTING
    
    %USE KINEMATICS EQUATIONS TO DETERMINE (x,y,z) FROM ANGLES
    %Using same set of angles for left and right arm    
    [rightArmCoord, leftArmCoord] = ForwardKinematics_V5(newPosture);
    
    %Find cell that the posture belongs to based on (x,y,z) coordinates
    [i_left, j_left, k_left] = findCell(leftArmCoord, n, w, l, h);
    [i_right, j_right, k_right] = findCell(rightArmCoord, n, w, l, h);
    
    rightPosture = [newPosture(1) newPosture(2) newPosture(3) newPosture(4) newPosture(5) newPosture(6) newPosture(7)];
    leftPosture = [newPosture(1) newPosture(2) newPosture(3) newPosture(8) newPosture(9) newPosture(10) newPosture(11)];
    
    %Check newly generated posture against each of cell's registered
    %postures and store it if posture is distinct
    [B(i_left, j_left, k_left).l_postures, storePosture_left] = checkPostureRedundancy(B(i_left, j_left, k_left).l_postures, leftPosture, lambda);
    [B(i_right, j_right, k_right).r_postures, storePosture_right] = checkPostureRedundancy(B(i_right, j_right, k_right).r_postures, rightPosture, lambda);
    
    if storePosture_left,
        B(i_left, j_left, k_left).Lposind(end+1,:) = B(i_left, j_left, k_left).index;
    end
    
    if storePosture_left,
        B(i_right, j_right, k_right).Rposind(end+1,:) = B(i_right, j_right, k_right).index;
    end
    
    
    %Keep track of number of registered postures for this cycle
    numRegPostures = numRegPostures + storePosture_left + storePosture_right;
    
    %Keep track of total number of generated and registered postures
    numGenPosturesTotal = numGenPosturesTotal + 2; % one posture for right arm, one posture for left arm
    numRegPosturesTotal = numRegPosturesTotal + storePosture_left + storePosture_right;    
    
    fprintf('%d postures generated so far\n', numGenPosturesTotal);
    fprintf('%d postures registered so far\n\n', numRegPosturesTotal);
    
    %Increment count of cycles
    numCycles = numCycles + 1;
    
    
    %If cycle limit has been reached
    if (numCycles == cycleLimit)
        %Calculate new registration rate
        [continueReg, curr_regRate] = checkRegRate(numRegPostures, numCycles, sigma);
        %Reset count of cycles and registered postures
        numCycles = 0;
        numRegPostures = 0;
        reg_rates(floor(i/cycleLimit)) = curr_regRate;
    end
    
    %Store total number of generated and registered postures in vector
    %if vectors are not full
    if (i <= vectorLength)
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
    
    catch
        [i_left, j_left, k_left]
        [i_right, j_right, k_right]
    end
    
end


%truncate size of vectors if there are unused values
genPosturesVector(i:end) = [];
regPosturesVector(i:end) = [];    

%plot growth

plot(genPosturesVector, regPosturesVector);
xlabel('Number of generated postures');
ylabel('Number of stored postures');

