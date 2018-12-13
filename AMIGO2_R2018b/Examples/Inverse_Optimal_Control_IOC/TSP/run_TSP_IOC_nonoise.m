close all; clear all; clear mex; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: The three step pathway by Mendes (2001)
%        Mendes P, 2001. Modeling large biological systems from functional
%        genomic data: Parameter estimation. In Foundations of systems 
%        biology (ed. H. Kitano), pp. 163–186. MIT Press, Cambridge, MA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 
%   First case: Solve the problem with matlab model (ode15s as IVP solver) and eSS with fmincon as
%   local solver
%

cprintf('*[1,0.5,0]','\n\n ---> 1st case: Matlab model (ode15s as IVP solver) and eSS with nl2sol as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a 10 min test only, increase final time or change solvers for refined solutions.');
pause(6)

TSP_IOC_nonoise % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)

%
%   Second case: Solve the problem with C model (CVODES as IVP solver); 
%
clear all; close all;

cprintf('*[1,0.5,0]','\n\n ---> 2nd case: C model (CVODES as IVP solver) and eSS with nl2sol as local solver.');
cprintf('*[1,0.5,0]','\n\n WARNING: C compiler is required to proceed. Follow instalation instructions.');
cprintf('*[1,0.5,0]','\n\n WARNING: This is for a 10 min test only, increase final time or change solvers for refined solutions.');
pause(10)


TSP_IOC_nonoise_C % calls the input file

AMIGO_Prep(inputs)
AMIGO_IOC(inputs)
