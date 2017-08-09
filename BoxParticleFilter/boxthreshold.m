function mat = boxthreshold( boxes, threshold )
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

