function flags = get_flag_types(B)
    n = size(B,1);
    flags = 0;
    for i=1:n^3
        flags = unique(horzcat(B(i).obstacle_types, flags));
    end
end