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
hold on;

% plot (x(:,1),x(:,2),'k','LineWidth',1)
% plotBoxGrid(Boxes,'g','none',1)
scatter(S(:,1),S(:,2),'mx','linewidth',7)


for k=1:N
    [xc,vc,thetac]=consigne(k,ts);
    
    U = [Interval(v_measure(k)).inflate(sigma_v),Interval(theta_measure(k)).inflate(sigma_theta)];
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
    x_tank=[x_med ang];
    xc_tank=[xc thetac];
    draw_tank(x_tank,'red',0.2);
    draw_tank(xc_tank,'black',0.2);
    drawnow;
end
%% Plots
% 
% figure (1); 
% %subplot(2,1,1); 
% hold on
% plot (x(:,1),x(:,2),'k','LineWidth',3)
% plot (x_med_box(:,1),x_med_box(:,2),'r','LineWidth',2)
% scatter(S(:,1),S(:,2),'mx','linewidth',7)
% plotBoxGrid(Boxes,'g','none',1)
% plotDistance(x,x_med_box,'b');
% legend ('real','Box particle model 1','Location','northwest')
