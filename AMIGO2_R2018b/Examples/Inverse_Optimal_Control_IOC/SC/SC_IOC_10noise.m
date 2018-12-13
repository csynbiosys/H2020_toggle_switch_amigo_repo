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


%% CASE WITH EXPERIMENTAL NOISE 


%======================
% PATHS RELATED DATA
%======================


inputs.pathd.results_folder='SC_IOCP';   % Folder to keep re(u1+u2)lts (in Re(u1+u2)lts) for a given problem          
inputs.pathd.short_name='SC_NN';         % To identify figures and reports for a given problem 
                                         % SC_NN indicates No Noise
inputs.pathd.runident=strcat('NoReg_Nlinearf_6'); % Run identifieer

%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelM';         % Model introduction: 'charmodelF'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|                        
                                                    %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=11;                               % Number of states      
inputs.model.n_par=2;                               % Number of model parameters 
inputs.model.n_stimulus=6;                          % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('x1','x2','x3','x4'...
    ,'NADH','ATP','NAD','ADP','OBJ','NADHc','ATPc');% Names of the states                                              
inputs.model.par_names=char('k7','k8');             % Names of the parameters                     
inputs.model.stimulus_names=char('e1','e2','e3','e4','e5','e6');  % Names of the stimuli, inputs or controls                      

inputs.model.eqns=...                               % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
char( 'dx1 = -ATP*e1*x1',...
'dx2 = 2*ATP*e1*x1 - ADP*NAD*e2*x2',...
'dx3 = NAD*e4*x4 - NAD*e5*x3 - NADH*e3*x3 + ADP*NAD*e2*x2',...
'dx4 = NADH*e3*x3 - NAD*e4*x4',...
'dNADH = NAD*e4*x4 - ADP*NADH*e6 - k8*NADH + 4*NAD*e5*x3 - NADH*e3*x3 + ADP*NAD*e2*x2',...
'dATP = 3*ADP*NADH*e6 - k7*ATP - 2*ATP*e1*x1 + 2*ADP*NAD*e2*x2',...
'dNAD = k8*NADH + ADP*NADH*e6 - NAD*e4*x4 - 4*NAD*e5*x3 + NADH*e3*x3 - ADP*NAD*e2*x2',...
'dADP = k7*ATP - 3*ADP*NADH*e6 + 2*ATP*e1*x1 - 2*ADP*NAD*e2*x2',...
'dOBJ = e1 + e2 + e3 + e4 + e5 + e6',...
'dNADHc = (max(0.5-NADH,0))^2',...                  % This state is added to handle path constraint on NADH
'dATPc = (max(0.7-ATP,0))^2');                      % This state is added to handle path constraint on ATP


inputs.model.par=[3 0.1];   % Nominal values for the parameters - changed during the optimization                                                                 
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
data=load('strreport_product_noisy5.mat');                          % Reads data from a .mat file

inputs.exps.n_exp=1;        % Number of experiments
 
for iexp=1:inputs.exps.n_exp
inputs.exps.n_obs{iexp}=9;  % Number of observables                                
inputs.exps.obs_names{iexp}=char('x1obs','x2obs','x3obs','x4obs','NADHobs','ATPobs','NADobs','ADPobs','OBJobs');% Names of observables
inputs.exps.obs{iexp}=char('x1obs=x1','x2obs=x2','x3obs=x3','x4obs=x4','NADHobs=NADH','ATPobs=ATP','NADobs=NAD','ADPobs=ADP','OBJobs=OBJ'); % Definition of the observables
inputs.exps.exp_y0{iexp}=[1 1 1 10 0.7 0.8 0.3 0.2 0 0 0];   % Initial conditions for each experiment       
end

%==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================
inputs.exps.data_type='real';                         % Type of data: 'pseudo'|'pseudo_pos'|'real'             
inputs.exps.noise_type='hetero_proportional';         % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default) 


for iexp=1:inputs.exps.n_exp
    inputs.exps.t_f{iexp}=data.inputs.exps.t_f{1,iexp};               % Final time
    inputs.exps.n_s{iexp}=data.inputs.exps.n_s{1,iexp};               % Number of sampling times
    inputs.exps.t_s{iexp}=data.inputs.exps.t_s{1,iexp};               % Sampling times
    inputs.exps.exp_data{iexp}=data.results.sim.exp_data{1,iexp};     % Experimental data
end

%==================================
% CONSTRAINTS
%==================================
inputs.IOCsol.n_const_ineq_tf=2;                         % Number of constraints at final time
inputs.IOCsol.const_ineq_tf=char('NADHc{1}','ATPc{1}');  % c<=0
inputs.IOCsol.ineq_const_max_viol=1.0e-5;                % Maximum allowed violation for the constraints

inputs.iocsol.n_control_const=1;                         % Number of constraints on the controls
inputs.iocsol.control_const=char('e1{1}+e2{1}+e3{1}+e4{1}+e5{1}+e6{1}-11.5');                                 % c(u)<=0
inputs.iocsol.control_const_max_viol=1.0e-5;             % Maximum allowed violation for the constraints

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.IOCsol.id_par=char('k7','k8');                    % 'all'|User selected 
inputs.IOCsol.par_max=50*ones(1,2);                      % Maximum allowed values for the paramters
inputs.IOCsol.par_min=1e-5*ones(1,2);                    % Minimum allowed values for the parameters

inputs.IOCsol.par_ref=zeros(1,2);                                  % Reference for regularization

%TIME VARYING STIMULI/CONTROL

% TIME VARYING STIMULI/CONTROL -CONTROL VECTOR PARAMETERIZATION

inputs.IOCsol.u_interp='linearf';               % [] Stimuli parameterization, 'step', 'stepf', 'linear', 'linearf'
 for iexp=1:inputs.exps.n_exp
  inputs.IOCsol.n_linear{iexp}=6+1;             % Number of elements
  inputs.IOCsol.t_con{iexp}= data.inputs.exps.t_con{1,1};

 for iu=1:inputs.model.n_stimulus
    inputs.IOCsol.u_min{iexp}(iu,:)=0*ones(1,inputs.IOCsol.n_linear{iexp});
    inputs.IOCsol.u_max{iexp}(iu,:)=11.5*ones(1,inputs.IOCsol.n_linear{iexp});         % Minimum and maximum value for the input
    inputs.IOCsol.u_guess{iexp}(iu,:)=5.75*ones(1,inputs.IOCsol.n_linear{iexp});       % Guess value for the input
 end

 
 end
    

%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.IOCsol.ioccost_type='llk';                    % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.IOCsol.llk_type='hetero';                   % [] To be defined for lsq function, 'Q_I' (weighting matrix the identity | 
                                                     %                                    'Q_expmax' (weighting matrix using max exp data) 

%==================================
% REGULARIZATION PARAMETERS
%==================================


inputs.model.alpha=0.00;                             % Weight on stimuli regularization(any real number)
                                                     % 0: means no regularization
% inputs.IOCsol.u_ref{iexp}=zeros(inputs.model.n_stimulus,inputs.IOCsol.n_linear{iexp});     
                                                     % Stimuli profile used for regularization                     
inputs.model.beta=0.00;                              % Weight on parameter regularization(any real number)
                                                     % 0: means no regularization    
% inputs.IOCsol.par_ref=zeros(1,2);                  % Parameters reference for regularization
%              
inputs.IOCsol.smoothing=0;                           % Smoothing of the control profile
inputs.IOCsol.uttReg=0;                              % Second order regularization 


%==================================
% NUMERICAL METHODS RELATED DATA
%==================================
%
 
% SIMULATION
inputs.ivpsol.ivpsolver='ode15s';         % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
inputs.ivpsol.rtol=1.0D-6;                % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0D-6; 
inputs.ivpsol.senssolver='sensmat'; 
 
% 
% OPTIMIZATION
%

inputs.nlpsol.nlpsolver='eSS';             % In this case the problem will be solved with eSS
inputs.nlpsol.eSS.iterprint=1;             % Print each iteration on screen: 0-Deactivated
                                           % 1-Activated (1, default)
inputs.nlpsol.eSS.local.solver='fmincon';  % Choose local solver
                                           % 0: Local search deactivated
                                           % 'fminsearch','nomad', 'dhc'
                                           % 'fmincon','solnp','ipopt'
                                           % for PE:'n2fb','dn2fb','lsqnonlin','nl2sol'
inputs.nlpsol.eSS.local.iterprint=1;       % Print each iteration on screen: 0-Deactivated
                                           % 1-Activated
inputs.nlpsol.eSS.local.finish=0;          % Add a local solver for final refinement
                                           % 'fminsearch','nomad', 'dhc'
                                           % 'fmincon','solnp','ipopt'

inputs.nlpsol.eSS.log_var =[1:2];          % Decision variables to be considered in log-scale. Suitable for this problem with parameters
                                           % ranging from 0 to 1.

inputs.nlpsol.eSS.maxeval = 1000000;       % Maximum number of function evaluations
inputs.nlpsol.eSS.maxtime = 600;           % Maximum CPU time --- Increase if you want refined solutions



%==================================
% DISPLAY OF RESULTS
%==================================
% 
 inputs.plotd.plotlevel='full';                       % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 
   
