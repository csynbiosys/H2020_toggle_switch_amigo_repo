close all; clear all; clear mex; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE:LPN3B
% This example regards a three step linear pathway. The objective is to find
% the enzyme activation profile compatible with the experimental data plus
% an underlying optimality principle.
%
% The problem is a generalization of the one described in:
% de Hijas-Liste, G.M. et al. (2014). Global dynamic optimization approach
% to predict activation in metabolic pathways. BMC systems biology, 8(1),1.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
%   First case: Solve the problem with matlab model (ode15s as IVP solver) and eSS with fmincon as
%   local solver
%

cprintf('*[1,0.5,0]','\n\n ---> 1st case: Matlab model (ode15s as IVP solver) and eSS with fmincon as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a fast test only, increase final time or change solvers for refined solutions.');
pause(6)

LPN3B_IOC_nonoise % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)

%
%   Second case: Solve the problem with C model (CVODES as IVP solver) and time varying step interpolation; 
%

clear all; close all;
cprintf('*[1,0.5,0]','\n\n ---> 2nd case: C model (CVODES as IVP solver) and eSS with fmincon as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: C compiler is required to proceed. Follow instalation instructions.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a fast test only, increase final time or change solvers for refined solutions.');
pause(10)


LPN3B_IOC_nonoise_C % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)

%
%   Third case: Solve the problem with C model (CVODES as IVP solver) and reoptimization; 
%

clear all; close all;
cprintf('*[1,0.5,0]','\n\n ---> 3rd case: C model; eSS with solnp as local solver and Re-Optimization with fmincon.');
cprintf('*[1,0.5,0]','\n\n WARNING: C compiler is required to proceed. Follow instalation instructions.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a fast test only, increase final time or change solvers for refined solutions.');
pause(10)



LPN3B_IOC_reopt_nonoise_C 

AMIGO_IOC(inputs)


%
%   4th case: Solve the problem with C model (CVODES as IVP solver). Case with experimental noise. 
%

clear all; close all;
cprintf('*[1,0.5,0]','\n\n ---> 4th case: With experimental noise. C model and eSS with solnp.');
cprintf('*[1,0.5,0]','\n\n WARNING: C compiler is required to proceed. Follow instalation instructions.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a fast test only, increase final time or change solvers for refined solutions.');
pause(10)



LPN3B_IOC_10noise 

AMIGO_IOC(inputs)

