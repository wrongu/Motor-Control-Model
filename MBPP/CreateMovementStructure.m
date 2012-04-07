n = 36

for k=1:n
%    z = h*(k - (n+1)/2);
    z = h*(k - (n+1)/2);
    for i=1:n
        x = w*(i - (n+1)/2);
        for j=1:n
            y = l*(j - (n+1)/2);
            % Compute the centers of each cell
            M(i, j, k).type = {[]};
            M(i, j, k).currentposture = [];
            M(i, j, k).direction = [];
            M(i, j, k).endpoint = [];
            M(i, j, k).startpoint = [];
            M(i, j, k).lastcell = [];
            M(i, j, k).nextcell = [];
            M(i, j, k).lastposture = [];
            M(i, j, k).nextposture = [];
            M(i, j, k).speed = [];
            M(i, j, k).center = [x, y, z];
            M(i, j, k).x = x;
            M(i, j, k).y = y;
            M(i, j, k).z = z;
            M(i, j, k).index = [i, j, k];
        end
    end
end
