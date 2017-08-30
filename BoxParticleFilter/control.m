function u = control(x,w,dw)
%% control : creates control vector from state and trajectory vector
% -Inputs= 
%   -x - DOUBLE ARRAY, robot state vector
%   -w - DOUBLE ARRAY, consign vector
%   -dw - DOUBLE ARRAY, derivative consign vector
% -Outputs = 
%   -u - DOUBLE ARRAY, control vector

    A = [-x(4)*sin(x(3)), cos(x(3));
         x(4)*cos(x(3)), sin(x(3)) ];
    Y = [x(1); x(2)];
    dY= [x(4)*cos(x(3));x(4)*sin(x(3))]; 
    V = (w-Y)+2*(dw-dY);
    u = A\V;
end
