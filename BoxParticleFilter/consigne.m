function [ xc,dxc,ddxc,vc,thetac ] = consigne( k,ts )
%consigne : creates a series of consign vectors for a robot to follow.
    th=k*ts;
    speed=0.7;
    normVec = @(a) sqrt(sum(a.^2,2));
    xc = 8*[cos(speed*th)+0.7;sin(speed*th)+0.7];
    dxc = 8*[-speed*sin(speed*th);speed*cos(speed*th)];
    ddxc=8*[-speed*speed*cos(speed*th);-speed*speed*sin(speed*th)];
    vc = normVec(dxc)/ts; 
    thetac = atan2(dxc(2),dxc(1));

end

