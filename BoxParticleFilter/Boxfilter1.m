%*********************************************************************** 
%									 
%	-- 2D box particle filtering. 
%
%
%	- Usage = 
%		[w_boxes,x_med] = BoxPFilter2D(N,Boxes,ts,stateFunction,stateInput,pe,show,w_boxes0)
%
%	- inputs =
%		- N - INT, number of boxes (can be slightly different if the number
%		doesn't have an integer square root).
%		- Boxes - CELL ARRAY, defines all boxes
%       - ts - DOUBLE, sampling time
%       - stateFunction - LAMBDA FUNCTION, state evolution
%       - stateInput - CELL ARRAY, state function input
%       - pe - CELL ARRAY, landmark distribution functions in (x,y) and time
%       - [OPTIONAL] show - BOOL, if true, show the number of each time
%       step (default = false).
%       - [OPTIONAL] w_boxes0 - DOUBLE ARRAY, probability distribution at
%       initial time (default = ).
%
%	- outputs = 	
%       - w_boxes - CELL ARRAY, probability distribution at each step
%       - x_med - DOUBLE ARRAY, estimation using w_boxes
%									 
%	-> MATLAB version used:	
%		- R2012b (8.0.0.783) 64-bit	
%				 
% 	-> Special toolboxes used: 
%		-- none	--
%
% 	-> Other dependencies: 
%		- Interval.m
%		- measurementUpdate.m
%		- stateUpdate.m
%									 
%	-> Created by Evandro Bernardes	 								 
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	1.0
%
%	last edited in:	31/05/2017 						 
%									 
%***********************************************************************
function [w_boxes_1,w_boxes_2,x_med] = Boxfilter1(Boxes,ts,stateFunction,stateInput,pe,k,w_boxes_in)
   
    


    %% Main loop
    % here the box particle filtering algorithm is implemented
    pek = cell(size(pe));
        
    %% Measurement update
    for m = 1:length(pek)
        pek{m} = @(x,y) pe{m}(x,y,k);
    end  

    % measurement update
    [w_boxes_1,x_med] = measurementUpdate(w_boxes_in,Boxes,pek);    



    %% State update Resampling    
    % Use input to calculate stateUpdate;
    w_boxes_2 = stateUpdate(w_boxes_1,Boxes,stateFunction,stateInput,ts);
end
