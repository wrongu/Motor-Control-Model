function obs = getObstacles(B, flag_type)
    dim = size(B);
    obs = NaN(dim);
    for i=1:dim(1)
        for j=1:dim(2)
            for k=1:dim(3)
                if(abs(B(i,j,k).obstacle))
                    if(nargin < 2 || any(B(i,j,k).obstacle_types == flag_type))
                        obs(i,j,k) = 1;
                    end
                end
            end
        end
    end
end