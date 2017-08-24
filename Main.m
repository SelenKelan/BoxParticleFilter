clc; clear all; close all


%% Defining system conditions
% robot state function
stateF = @(X,U,ts) X + ts*U(1)*[cos(U(2)) , sin(U(2))];

% environment definition (measures, probability functions, etc)
environement;

%% Box particle filtering

initBoxes;

% init boxes
[i,j] = findIndexes(Interval(x(1,1),x(1,2)),Boxes);
i = i-2:i+2; j = j-2:j+2;
w_boxes_0 = zeros(size(Boxes)); w_boxes_0(i,j) = 1; w_boxes_0 = w_boxes_0/sum(sum(w_boxes_0));
w_boxes = cell(N,1);
w_boxes{1} = w_boxes_0;
x_med_box=zeros(N,2);

% Init lists
x_tank_list=zeros(3,N);
xm_tank_list=zeros(3,N);
xc_tank_list=zeros(3,N);
mats=cell(N,1);
hit=cell(N,1);


% Main Loop
for k=1:N
    %display iteration number
    disp(k);
    %create control vector
    [xc,dxc,ddxc,vc,thetac]=consigne(k,ts);
    ur=control([x_med2 theta_measure v_measure],xc,dxc);
    %look for potential collision
    mats{k}=boxthreshold(w_boxes{k},0.8);
    hit{k}=mats{k}==envimat;
    touch=find(hit{k});
    %if colision, add repulse vector to control vector
    if ~isempty(touch)
        [boxX,boxY]=locator(x_med2(1),x_med2(2),Boxes);
        ur=ur+[normVec([Mx(boxX,boxY),My(boxX,boxY)]) ; atan2(Mx(boxX,boxY),My(boxX,boxY))];
    end
    %new step for the state of the system
    [x,v,theta,v_measure, theta_measure, pe, U]=realState(N, x, v, theta,ur, ts,S,NS);
    %box particle filtering
    [w_box_1,w_box_2,x_med] = Boxfilter1(Boxes,ts,stateF,U,pe,w_boxes{k});
    x_med_box(k,:)=x_med;
    w_boxes{k}=w_box_1;
    w_boxes{k+1}=w_box_2;
    %low pass filter (gliding median) on median position from BPF
    if k>5
        x_med2=sum(x_med_box(k-5:k,:))/5;
    else
        x_med2=x_med;
    end
    %creating positions of real, self-measured and consign robots
    x_tank=[x(1);x(2);theta];
    xm_tank=[x_med2(1);x_med2(2);theta_measure];
    xc_tank=[xc; thetac];
    %saving those positions in lists.
    x_tank_list(:,k)=x_tank;
    xm_tank_list(:,k)=xm_tank;
    xc_tank_list(:,k)=xc_tank;
end

%Displaying the results after the end of all calculations
figure(1);
[enrow,encol]=find(envimat==1);
for l=1:N
    %iterate the representation when stopped by pressing any key.
    a = waitforbuttonpress;
    for k=1:N
        
        figure(1);
        clf;
        axis([-10 20 -10 20]);axis square; hold on;
        %plot free boxes
        [row,col]=find(mats{k});
        for i=1:length(row)
            plot(Boxes{row(i),col(i)},'green','green',1);
        end
        %plot walls
%         for i=1:length(enrow)
%             plot(Boxes{enrow(i),encol(i)},'black','black',1);
%         end

        %plot colliding boxes
        [row,col]=find(hit{k});
        for i=1:length(row)
            plot(Boxes{row(i),col(i)},'red','red',1);
        end
        %plot robots
        draw_tank(x_tank_list(:,k),'blue',0.2);
        draw_tank(xm_tank_list(:,k),'red',0.2);
        draw_tank(xc_tank_list(:,k),'black',0.2);
        
        drawnow;

    end
end
