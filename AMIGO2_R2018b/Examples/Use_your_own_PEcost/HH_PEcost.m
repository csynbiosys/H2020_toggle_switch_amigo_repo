function [f,h,g] = HH_PEcost(theta)

% Example of user provided PE cost function
% Input arguments are: theta: parameter values 
% Output arguments are: f corresponds to the cost function (least squares, etc)
%                       h corresponds to constraints
%                       g corresponds to the vector of residuals (some
%                       least squares solvers included in the tool will
%                       require residuals)



theta = theta(:);

% Experimental data 
ndata=11;
exp_data=[0.631115                     
     	2.984205                                      
 		3.898819                                      
 		5.230199
 		4.198258
 		6.030247
 		3.295123
 		2.757383
 		1.800544
 		2.646096
 		2.625807 ];


% Initialice cost; constraints; residuals
f=0.0;
h=0;
g = zeros(1,ndata);

    
% Perform simulation for each set of experimental conditions
 
 y_0=[0 0.3177 0.053 0.5959];       % Initial conditions for each experiment       
 t_f=40;                               % Experiments duration
 inputs.exps.n_s{1}=11;                               % Number of sampling times
 t_s=[0:4:40];   
 u=[5 0];
 iflag=1;
[yteor iflag]=feval('HHbbmodel',0,t_f,t_s,y_0,theta,u,[0 0],[0 20 t_f],1);
            
% OBJECTIVE FUNCTION CALCULATION.
            
ms=yteor(:,1);    % Observable

g = ms-exp_data;  % residuals         

f=g'*g;   % Least squares
                  

return