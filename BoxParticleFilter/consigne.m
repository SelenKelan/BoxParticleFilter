function [ xc,vc,thetac ] = consigne( k,ts )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    th=k*ts;
    normVec = @(a) sqrt(sum(a.^2,2));
    xc = 5*[cos(th),sin(th)]; xc = xc + 5;
    dxc = 5*[-sin(th),cos(th)];
    vc = normVec(dxc)/ts; 
    thetac = atan2(dxc(2),dxc(1));

end

