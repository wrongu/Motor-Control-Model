%% Test number of postures / cell size
%for right side
i=20;
j=20;


for k=1:40
 
    postureArray = A{i,j,k}.r_postures;
    [numPostures numAngles] = size(postureArray);
    XYZ = [];
    if(numPostures > 1)
        for m=2:numPostures
            posture = postureArray(m,:);
            angles = [posture 0 0 0 0];
            xyz = ForwardKinematics_V5(angles);
            XYZ = [XYZ; xyz'];

        end

        scatter3(XYZ(:,1),XYZ(:,2),XYZ(:,3));

        hold on;
    end
end

%% Test standard deviation of xyz-position of postures for cell size

index=1;
stdDevVector = zeros(1,1000);
for i=1:10
    for j=1:10
        for k=1:10
            postureArray = A{i,j,k}.r_postures;
            [numPostures numAngles] = size(postureArray);
            center=A{i,j,k}.center;
            if(numPostures > 1)
                sumDiff=0;

                for m=2:numPostures

                    angles = [postureArray(m,:) 0 0 0 0];
                     xyz = ForwardKinematics_V5(angles);
                     xyz = xyz';
                     diff = sum((center-xyz).^2);
                     sumDiff = sumDiff + diff;
                            
                    

                end
                
                stdDev = sqrt(sumDiff / (numPostures-1));
                stdDevVector(index) = stdDev;
                index = index+1;
     
            end
        end
    end
end


stdDevVector(index:end) = [];
% disp(stdDevVector);
avgStdDev = mean(stdDevVector)

%% Test lambda and sigma

clear all

index=1;

    s = struct('center', [0, 0, 0], 'width', 0, 'length', 0, 'height', 0, 'r_postures', [0 0 0 0 0 0 0], 'l_postures', [0 0 0 0 0 0 0]);

    %nxnxn cell array. Each cell holds the above struct
    n=20;
    A=cell(n, n, n); 

    %Width, length, and height of each cell
    w = 2;
    l = 2;
    h = 2;

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
                A{i, j, k} = s;
                %Compute the centers of each cell
                if (i==1)
                    x=-w*floor(n/2) + w/2;

                else
                    %x = w*j - (w/2);
                    x = x + w;
                end

                A{i, j, k}.center = [x, y, z];
                A{i, j, k}.width = w;
                A{i, j, k}.length = l;
                A{i, j, k}.height = h;
            end
        end
    end

    i=1; %count of while loop iterations
    continueReg = 0; 
    cycleLimit = 100;
    numRegPostures = 0;
    numCycles = 0;
    curr_regRate=0;
    lambda = 1; %threshold for min difference between postures
                 %randomly chosen right now
    sigma = .1; %threshold for min difference between registration rates
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
        [rightArmCoord, leftArmCoord] = ForwardKinematics_V5(newPosture);

    %     leftArmCoord(1) = -leftArmCoord(1); %change the sign of the x-coordinate
    %     
    %     rightArmCoord = ForwardKinematics(newPosture);

        %Find cell that the posture belongs to based on (x,y,z) coordinates
        [i_left, j_left, k_left] = findCell(leftArmCoord, n, w, l, h);
        [i_right, j_right, k_right] = findCell(rightArmCoord, n, w, l, h);

        rightPosture = [newPosture(1) newPosture(2) newPosture(3) newPosture(4) newPosture(5) newPosture(6) newPosture(7)];
        leftPosture = [newPosture(1) newPosture(2) newPosture(3) newPosture(8) newPosture(9) newPosture(10) newPosture(11)];

        %Check newly generated posture against each of cell's registered
        %postures and store it if posture is distinct
        [A{i_left, j_left, k_left}.l_postures, storePosture_left] = checkPostureRedundancy(A{i_left, j_left, k_left}.l_postures, leftPosture, lambda);
        [A{i_right, j_right, k_right}.r_postures, storePosture_right] = checkPostureRedundancy(A{i_right, j_right, k_right}.r_postures, rightPosture, lambda);


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
            [continueReg, curr_regRate] = checkRegRate(numRegPostures, numCycles, sigma);
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
   
    hold on
    
    totalGenVector(index) = numGenPosturesTotal
    totalRegVector(index) = numRegPosturesTotal
    index = index+1;


