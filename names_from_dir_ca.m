% quick helper..
% richard lange

function ns = names_from_dir_ca(dir_results)
    num_directories = length(dir_results);
    ns = cell(1);
    for i = 1:num_directories
        contents = dir_results{i};
        num_dirs = length(contents);
        for j = 3:num_dirs
            sub = contents(j);
            if(~(sub.isdir))
                ns = [ns; sub.name];
            end
        end
    end
end