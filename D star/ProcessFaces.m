%Divya Gunasekaran
%April 25, 2011
%To be used in D* algorithm


function [B,numFaces] = ProcessFaces(B, n)

nSq = n^2;
numCubes = n^3;
faceIndex = 1;

inf = 1000000;

%Initialized face structure
%Goal cost estimate and rhs are set to infinity
face = struct('center', [], 'g', inf, 'rhs', inf, 'k1', NaN, 'k2', NaN, 'point', [],'next',NaN);

%structure to hold face nodes
global FacesArray;
FacesArray = cell(n*n*n,1);

for i=1:numCubes
    cubeFaces = zeros(1,6);
    
    if(i==1)  
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'left');
        cubeFaces(1) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
       
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'back');
        cubeFaces(4) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'bottom');
        cubeFaces(6) = faceIndex;
        faceIndex = faceIndex + 1;
        
    end
    
    if(1 < i && i <= n)
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
       
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'back');
        cubeFaces(4) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'bottom');
        cubeFaces(6) = faceIndex;
        faceIndex = faceIndex + 1;
        
        leftIndex = B(i-1).faces(2); %right face of cube to the left
        cubeFaces(1) = leftIndex;
    end
    
    if(mod(i,n)==1 && i~=1 && i<=400)
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'left');
        cubeFaces(1) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'bottom');
        cubeFaces(6) = faceIndex;
        faceIndex = faceIndex + 1;
        
        backIndex = B(i-n).faces(3); %front face of cube behind
        cubeFaces(4) = backIndex;
    end
    
    if(n < i && i<=nSq && mod(i,n)~=1)
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'bottom');
        cubeFaces(6) = faceIndex;
        faceIndex = faceIndex + 1;
        
        leftIndex = B(i-1).faces(2); %right face of cube to the left
        backIndex = B(i-n).faces(3); %front face of cube behind
        cubeFaces(1) = leftIndex;
        cubeFaces(4) = backIndex;
    end
    
    if(i>nSq && mod(i,nSq)==1)
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'left');
        cubeFaces(1) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
       
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'back');
        cubeFaces(4) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
        
        bottomIndex = B(i-nSq).faces(5); %top face of cube on bottom
        cubeFaces(6) = bottomIndex;
    end
    
    if(i>nSq && mod(i,nSq)<=n && mod(i,nSq)>1)
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
       
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'back');
        cubeFaces(4) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
    
        leftIndex = B(i-1).faces(2); %right face of cube to the left
        bottomIndex = B(i-nSq).faces(5); %top face of cube on bottom
        cubeFaces(1) = leftIndex;
        cubeFaces(6) = bottomIndex;
    end
    
    if(i>nSq && mod(i,n)==1 && mod(i,nSq)~=1)
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'left');
        cubeFaces(1) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
        
        backIndex = B(i-n).faces(3); %front face of cube behind
        bottomIndex = B(i-nSq).faces(5); %top face of cube on bottom
        cubeFaces(4) = backIndex;
        cubeFaces(6) = bottomIndex;
    end
    
    if(i>nSq && (mod(i,nSq)>n || mod(i,nSq)==0) && mod(i,n)~=1)
         FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'right');
        cubeFaces(2) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'front');
        cubeFaces(3) = faceIndex;
        faceIndex = faceIndex + 1;
        
        FacesArray{faceIndex} = face;
        FacesArray{faceIndex}.center = getFace(B, i, 'top');
        cubeFaces(5) = faceIndex;
        faceIndex = faceIndex + 1;
        
        leftIndex = B(i-1).faces(2); %right face of cube to the left
        backIndex = B(i-n).faces(3); %front face of cube behind
        bottomIndex = B(i-nSq).faces(5); %top face of cube on bottom
        cubeFaces(1) = leftIndex;
        cubeFaces(4) = backIndex;
        cubeFaces(6) = bottomIndex;
    end
    
    B(i).faces = cubeFaces;
end

%truncate leftover cell array entries
for j=faceIndex:(n*n*n)
    FacesArray{j} = [];   
end

numFaces = faceIndex - 1;
        