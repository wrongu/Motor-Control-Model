%Divya Gunasekaran
%May 16, 2011

%Reset all cells to be obstacle-free for D* planning

function B = A_ResetObstacles(B,n)

nCube = n^3;

%Reset obstacle fields to 0 for all cells
for j=1:nCube
    B(j).obstacle = 0;
end