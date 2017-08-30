function mat = boxthreshold( boxes, threshold )
%% boxthreshold : creates a presence matrix for where the robot has more than 'threshold' chances to be.
% -Inputs = 
%   -boxes - DOUBLE ARRAY, matrix of presence probabilities
%   -threshold - DOUBLE, total probability of presence
% -Outputs =
%   -mat - BINARY ARRAY, presence area of the robot in a matrix (same size as boxes)

    ind=find(boxes);
    mat=zeros(length(boxes));
    boxeslist=[boxes(ind) ind];
    sortedboxeslist=flip(sortrows(boxeslist,1));
    prop=0;
    k=1;
    while prop<threshold
        mat(int16(sortedboxeslist(k,2)))=1;
        prop=prop+sortedboxeslist(k,1);
        k=k+1;
    end
end

