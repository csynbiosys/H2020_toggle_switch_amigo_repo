close all; clear all; clear mex; clc;


% 
%   First case: Solve the problem with matlab model (ode15s as IVP solver) and eSS with nl2sol as
%   local solver
%
%   EpoR is parametrized with linear-wise interpolation 


cprintf('*[1,0.5,0]','\n\n ---> 1st case: Matlab model (ode15s as IVP solver) and eSS with nl2sol as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a 5 min test only, increase final time or change solvers for refined solutions.');
pause(6)

JAK_STAT_IOC % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)




% 
%   Second case: Solve the problem with matlab model (ode15s as IVP solver) and eSS with nl2sol as
%   local solver
%
%   EpoR is parametrized with linear-wise interpolation 


clear all; close all;
cprintf('*[1,0.5,0]','\n\n ---> 2nd case: C model (CVODES as IVP solver) and eSS with nls2sol as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: C compiler is required to proceed. Follow instalation instructions.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a fast test only, increase final time or change solvers for refined solutions.');
pause(10)

JAK_STAT_IOC_C % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)
