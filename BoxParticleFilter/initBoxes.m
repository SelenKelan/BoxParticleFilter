bound = 1;
boxes = ceil([sqrt(NP) sqrt(NP)]); Nboxes = prod(boxes);
x_min = [0 0] - 10*bound;
x_max = [10 10] + 10*bound;
accuracy_x = ceil(x_max - x_min)./boxes;

% initialising boxes
i_max = boxes(1); j_max = boxes(2);
pos_x1 = x_min(1) + (0:i_max)*accuracy_x(1);
pos_x2 = x_min(2) + (0:j_max)*accuracy_x(2);

Boxes = cell(boxes);
for i=1:i_max
    for j=1:j_max
       Boxes{i,j} = Interval(pos_x1(i:i+1),pos_x2(j:j+1));
    end
end