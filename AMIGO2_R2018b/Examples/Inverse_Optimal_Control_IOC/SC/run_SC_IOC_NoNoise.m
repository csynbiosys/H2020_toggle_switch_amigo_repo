close all; clear all; clear mex; clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE:SC - Central metabolism of {\it Saccharomyces cerevisiae} during
%            diauxic shift
%            The formulation is based on the problems studied by Klipp et al 2002
%            where the model considers six reactions: upper and lower glycolysis, 
%            ethanol formation and ethanol consumption, the TCA cycle and the 
%            respiratory chain.                      
%  
%            REF model: Klipp, E. et al. Prediction of temporal gene expression. 
%            EU J Biochem, 269(22), 5406–5413, 2002.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% 
%   First case: Solve the problem with matlab model (ode15s as IVP solver) and eSS with fmincon as
%   local solver
%

cprintf('*[1,0.5,0]','\n\n ---> 1st case: Matlab model (ode15s as IVP solver) and eSS with fmincon as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a 10 min test only, increase final time or change solvers for refined solutions.');
pause(6)

SC_IOCP_NoNoise % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)


pause(2)
clear all; close all;


%
%   Second case: Solve the problem with C model (CVODES as IVP solver); 
%


cprintf('*[1,0.5,0]','\n\n ---> 2nd case: C model (CVODES as IVP solver) and eSS with fmincon as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: C compiler is required to proceed. Follow instalation instructions.');

pause(6)


SC_IOCP_NoNoise_C % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)


