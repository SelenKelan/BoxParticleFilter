function mat = boxthreshold( boxes, threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ind=find(boxes);
mat=zeros(length(boxes));
for k=1:length(ind)
    if boxes(ind(k))>threshold
        mat(ind(k))=1;
    end
end

end

