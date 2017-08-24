function mat = boxthreshold( boxes, threshold )
%boxthreshold : creates a presence matrix for the robot to have more than
%'threshold' chances to be.
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

