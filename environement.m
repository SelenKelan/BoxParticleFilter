%% Environement definition
%

anormVec = @(a) sqrt(sum(a.^2,2));
normVec = @(a) sqrt(sum(a.^2,2));
rng(1);

% path
tn=4;%duration of the simulation
ts = 0.05;%size of the steps
th = 0:ts:tn*pi;
N=length(th);%number of steps

%real
x = [10 5];%starting position vector
dx = [0.1 0];%starting speed vector
v = normVec(dx)/ts;% starting speed
theta = pi/2;% starting angle

x_med=[10 5];
x_med2=x_med;
% 
sigma=0.5; sigma_v = 0.02; sigma_theta = 0.002;
v_measure = v + 2*(rand(size(v))-0.5)*sigma_v;% measured speed with noise
theta_measure = theta + 2*(rand(size(theta))-0.5)*sigma_theta;% measured angle with noise

% Landmarks
S =     [-5 -5;-5 20;20 20;20 -5];%landmarks definition
NS = size(S,1); % number of landmarks

% boxes
NP = 1024;%number of boxes

% environement matrix
% ones are walls, twos are free floor
envimat=2*ones(sqrt(NP),sqrt(NP));
envimat(:,1:4)=1;
envimat(1:4,:)=1;
envimat(:,end-3:end)=1;
envimat(end-3:end,:)=1;

% vector field matrix
[Mx,My]=fieldmat(envimat);
% to display it :
% quiver(Mx,My);
