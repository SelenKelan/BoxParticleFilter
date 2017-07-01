anormVec = @(a) sqrt(sum(a.^2,2));

%% path 2
ts = 0.05; 
th = 0:ts:1*pi;
N=length(th);

%real
x = [10 5];
dx = [0.1 0];
v = normVec(dx)/ts; 
theta = pi/2;

x_med=[10 5];
x_med2=x_med;
sigma=0.5; sigma_v = 0.02; sigma_theta = 0.002;
v_measure = v + 2*(rand(size(v))-0.5)*sigma_v; 
theta_measure = theta + 2*(rand(size(theta))-0.5)*sigma_theta;

    % Landmarks
S =     [5 5];
NS = size(S,1); % number of landmarks

     

