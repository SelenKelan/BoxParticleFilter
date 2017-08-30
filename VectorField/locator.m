function [a,b]=locator(x,y,Boxes)
%% locator : finds the box in which the robot is
% -Inputs =
%   -x - lattitude of the robot
%   -y - longitude of the robot
%   -Boxes - matrix of interval boxes of the playground
% -Output =
%   -a -first index of interval in which the robot is in Boxes
%   -b -second index of interval in which the robot is in Boxes

    for i=1:length(Boxes)
        for j=1:length(Boxes)
            if contains(Boxes{i,j}(1),x)
                if contains(Boxes{i,j}(2),y)
                    a=i;
                    b=j;
                end
            end
        end
    end    
end