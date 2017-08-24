%*********************************************************************** 
%									 
%	-- 2D box particle filtering. 
%
%
%	- Usage = 
%		[w_boxes_1,w_boxes_2,x_med] = Boxfilter1(Boxes,ts,stateFunction,stateInput,pe,w_boxes_in)
%
%	- inputs =
%		- Boxes - CELL ARRAY, defines all boxes
%       - ts - DOUBLE, sampling time
%       - stateFunction - LAMBDA FUNCTION, state evolution
%       - stateInput - INTERVAL, state function input
%       - pe - CELL ARRAY, landmark distribution functions in (x,y) and time
%       - w_boxes_in - DOUBLE ARRAY, probability distribution at previous step
%
%	- outputs = 	
%       - w_boxes_1 - DOUBLE ARRAY, probability distribution at current step
%       - w_boxes_2 - DOUBLE ARRAY, probability distribution at next step
%       - x_med - DOUBLE ARRAY, estimation using w_boxes
%									 
%	-> MATLAB version used:	
%		- R2016b (9.1.0.441655) 64-bit	
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
%   -> Modified by Raphaël Abellan--Romita
%		- at IRI (Barcelona, Catalonia, Spain)							 								 
%									 
% 	Code version:	2.0
%
%	last edited in:	24/08/2017 						 
%									 
%***********************************************************************
function [w_boxes_1,w_boxes_2,x_med] = Boxfilter1(Boxes,ts,stateFunction,stateInput,pe,w_boxes_in)
   
    


    %% Main loop
    % here the box particle filtering algorithm is implemented
    pek = cell(size(pe));
        
    %% Measurement update
    for m = 1:length(pek)
        pek{m} = @(x,y) pe{m}(x,y);
    end  

    % measurement update
    [w_boxes_1,x_med] = measurementUpdate(w_boxes_in,Boxes,pek);    



    %% State update Resampling    
    % Use input to calculate stateUpdate;
    w_boxes_2 = stateUpdate(w_boxes_1,Boxes,stateFunction,stateInput,ts);
end
