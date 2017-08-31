%*********************************************************************** 
%									 
%	-- 2D box particle filtering. 
%
%
%	- Usage = 
%		[x,v,theta,v_measure, theta_measure, pe, U]=realState(N, x, v, theta,ur, ts,S,NS)
%
%	- inputs =
%       - N - INT, number of boxes
%       - x - DOUBLE ARRAY, position vector
%       - v - DOUBLE, robot speed
%       - theta - DOUBLE, robot cap
%       - ur - DOUBLE ARRAY, consign vector
%       - ts - DOUBLE, step size
%       - S - DOUBLE ARRAY, landmarks
%       - NS - INT, number of landmarks
%
%	- outputs = 	
%       - x - DOUBLE ARRAY, position vector
%       - v - DOUBLE, robot speed
%       - theta - DOUBLE, robot cap
%       - v_measure - DOUBLE, robot speed with noise
%       - theta_measure - DOUBLE, robot cap with noise
%       - pe - CELL ARRAY, function for each landmark
%       - U - INTERVAL, measured speed and cap in interval
%									 
%	-> MATLAB version used:	
%		- R2016b (9.1.0.441655) 64-bit	
%				 
% 	-> Special toolboxes used: 
%		-- none	--
%
% 	-> Other dependencies: 
%		- Interval.m
%									 
%	-> Created by Evandro Bernardes	
%   -> Modified by Raphaël Abellan--Romita
%		- at IRI (Barcelona, Catalonia, Spain)											 								 
%									 
% 	Code version:	2.0
%
%	last edited in:	24/08/2017 						 
%									 
%***********************************************************************


function [x,v,theta,v_measure, theta_measure, pe, U]=realState(N, x, v, theta,ur, ts,S,NS)
    % lambda-function type for derivative vector creation
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end

% noise values
sigma=0.5; % global noise
sigma_v = 0.02; % speed sensor noise
sigma_theta = 0.002; % cap sensor noise
% accuracy_x = [1, 1]; % box dimensions

%State modifier
xtot=[x(1);x(2);theta;v];
% simulaneous modification. sequential may create problems.
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