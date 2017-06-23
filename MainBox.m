 clc; clear all; close all
normVec = @(a) sqrt(sum(a.^2,2));
rng(1);

%% Defining system conditions
% robot state function
stateF = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

% environment definition (measures, probability functions, etc)
environement4;

%% Box particle filtering
NP = 256;
initBoxes;

% init position
[i,j] = findIndexes(Interval(x(1,1),x(1,2)),Boxes);
i = i-2:i+2; j = j-2:j+2;
w_boxes_0 = zeros(size(Boxes)); w_boxes_0(i,j) = 1; w_boxes_0 = w_boxes_0/sum(sum(w_boxes_0));
w_boxes = cell(N,1);
w_boxes{1} = w_boxes_0;
x_med_box=zeros(N,2);


figure(1);

axis([-5 15 -5 15]);axis square;
% plot (x(:,1),x(:,2),'k','LineWidth',1)
% plotBoxGrid(Boxes,'g','none',1)
scatter(S(:,1),S(:,2),'mx','linewidth',7)
hold on;
x_tank_list=zeros(3,N);
xm_tank_list=zeros(3,N);
xc_tank_list=zeros(3,N);

for k=1:N
    [xc,dxc,ddxc,vc,thetac]=consigne(k,ts);
    ur=control([x_med theta_measure v_measure],xc,dxc);
    [x,v,theta,v_measure, theta_measure, pe, U]=realState(N,k, x, v, theta,ur, ts,S,NS);
    [w_box_1,w_box_2,x_med] = Boxfilter1(Boxes,ts,stateF,U,pe,k,w_boxes{k});
    x_med_box(k,:)=x_med;
    w_boxes{k}=w_box_1;
    w_boxes{k+1}=w_box_2;
    disp(k);
    if k==1
        ang=pi/2;
    else
        ang=atan2(x_med(1,2)-x_med_box(k-1,2),x_med(1,1)-x_med_box(k-1,1));
    end
%     clf;
%     axis([-5 15 -5 15]);axis square; hold on;
    x_tank=[x(1);x(2);theta];
    xm_tank=[x_med(1);x_med(2);theta_measure];
    xc_tank=[xc; thetac];
    x_tank_list(:,k)=x_tank;
    xm_tank_list(:,k)=xm_tank;
    xc_tank_list(:,k)=xc_tank;
%     draw_tank(x_tank,'blue',0.2);
%     draw_tank(xm_tank,'red',0.2);
%     draw_tank(xc_tank,'black',0.2);
%     drawnow;
end
for l=1:N
    a = waitforbuttonpress;
    for k=1:N

        clf;
        axis([-5 15 -5 15]);axis square; hold on;
        draw_tank(x_tank_list(:,k),'blue',0.2);
        draw_tank(xm_tank_list(:,k),'red',0.2);
        draw_tank(xc_tank_list(:,k),'black',0.2);
        drawnow;
    end
end
