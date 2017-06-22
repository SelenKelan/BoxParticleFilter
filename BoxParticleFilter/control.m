    function u = control(x,w,dw)
        A = [-x(4)*sin(x(3)), cos(x(3));
             x(4)*cos(x(3)), sin(x(3)) ];
        Y = [x(1); x(2)];
        dY= [x(4)*cos(x(3));x(4)*sin(x(3))]; 
        V = (w-Y)+2*(dw-dY);
        u = A\V;
    end
