%Divya Gunasekaran
%May 16, 2011

%Reset all costs and keys of each node to infinity for D* planning

function B = A_ResetCosts(B,n)

nCube = n^3;

%Initialize all costs and keys to infinity for every cell
for j=1:nCube
    B(j).g = inf;
    B(j).rhs = inf;
    B(j).k1 = inf;
    B(j).k2 = inf;
end