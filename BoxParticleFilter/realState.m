function [x,v,theta,v_measure, theta_measure, pe, U]=realState(N,k, x, v, theta,ur, ts,S,NS)
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end
% noise
sigma=0.5; sigma_v = 0.02; sigma_theta = 0.002;
% accuracy_x = [1, 1]; % box dimensions
%State modifier

xtot=[x(1);x(2);theta;v];
xtot=xtot+f(xtot,ur)*ts;
x=[xtot(1) xtot(2)];
theta=xtot(3);
v=xtot(4);


%% Theta: Definition of measure and error distribution

% angle distance (data to be measured)
v_measure = v + 2*(rand(size(v))-0.5)*sigma_v; 
theta_measure = theta + 2*(rand(size(theta))-0.5)*sigma_theta;

theta_distance_real = zeros(N,NS);
for i = 1:NS
    %@minus?
    x_s = minus(x,S(i,:));
    theta_distance_real(i) = atan2(x_s(2),x_s(1)) - theta;
end
theta_distance_measure = theta_distance_real + randn(size(theta_distance_real))*sqrt(sigma); % Measured distance

% measure function (angle distance between the heading and the landmark at
% each state
measure_Func = @(x,y,s) atan2(y - s(2),x - s(1));

% cell array with function for each landmark
pe = cell(NS,1);
for m = 1:NS
        pe{m} = @(x,y) normpdf(measure_Func(x,y,S(m,:)) - theta,theta_distance_measure(m),sqrt(sigma));
end

U = [Interval(v_measure).inflate(sigma_v),Interval(theta_measure).inflate(sigma_theta)];

end