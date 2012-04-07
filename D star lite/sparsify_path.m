% sparsify_path.m
% written by Richard Lange
% August 31, 2011
%
% given a path, this function uses ExtractMovements - a function that
% detects large changes in a path - to pick out the main components of the
% path.

function sparse_path = sparsify_path(path)
    result = ExtractMovements(path)
    
    indices = result.starttime;
    
    sparse_path = zeros(1+length(indices), 3);
    sparse_path(1,:) = path(1,:);
    for i = 1:length(indices)
        j = indices(i);
        sparse_path(i,:) = path(j,:);
    end
    sparse_path(length(indices)+1,:) = path(end,:);
end