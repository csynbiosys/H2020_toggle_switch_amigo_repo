
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: The Hodgking-Huxley model
%        EXAMPLE: Parameter estimation using user provided cost function
%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='HH_user_cost_example';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='HH_uce';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='blackboxcost';            % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                         %                     'blackboxmodel'|'blackboxcost   
inputs.model.blackboxcost_file='HH_PEcost';          % USER provided PE cost 
inputs.model.n_st=4;                                 % Number of states                                  
inputs.model.n_par=7;                                % Number of model parameters                                  
inputs.model.n_stimulus=1;                           % Number of inputs, stimuli or control variables   
inputs.model.names_type='custom';                    % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...) 
                                                     %                                       'custom'(default)
inputs.model.st_names=char('yv','yn','ym','yh');     % Names of the states  % USED FOR LABELS                                     
inputs.model.par_names=char('gNa','gK','gL','VNa',...
                        'VK','VL','Cm');             % Names of the parameters  % USED FOR LABELS                 
inputs.model.stimulus_names=char('TotalI');          % Names of the stimuli, inputs or controls  % USED FOR LABELS                                 
             
inputs.model.par=[120 36 0.3 -115 12 -10.613 1];         % Nominal value for the parameters, this allows to fix known parameters
                                                      % These values may be updated during optimization  

%=============================================================================
% EXPERIMENTAL SCHEME RELATED DATA - DUMMIES REQUIRED BY AMIGO CHECKS - NOT
% USED FOR COMPUTATION
%===============================================================================                                

 inputs.exps.n_exp=1;  % >=1
 inputs.exps.n_obs{1}=1;                              % Number of observed quantities per experiment                         
 inputs.exps.obs_names{1}=char('dummy');              % Name of the observed quantities per experiment    
 inputs.exps.obs{1}=char('dummy=yv');                 % Observation function
 inputs.exps.exp_y0{1}=[0 0.3177 0.053 0.5959];       % Initial conditions for each experiment       
 inputs.exps.t_f{1}=40;                               % Experiments duration
 inputs.exps.n_s{1}=11;                               % Number of sampling times                      
 inputs.exps.u{1}=0;                                  % stimulation conditions  
 inputs.exps.t_con{1}=[0 inputs.exps.t_f{1}];         % stimulation times
 inputs.exps.data_type='real';                        % type of data 
 inputs.exps.exp_data{1}=zeros(11,1);                 % Dummy experimental data 
 
 
 

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)


inputs.PEsol.id_global_theta='all';                           %  'all'|User selected  inputs.PEsol.global_theta_max=10*ones(1,9);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_max=[200 200 200 0 200 0 200];    % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=[0 0 0 -200 0 -200 1e-5 ];       % Minimum allowed values for the parameters
inputs.PEsol.global_theta_guess=inputs.model.par;    


%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.PEsol.PEcost_type='user_PEcost';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.PEsol.PEcost_file=inputs.model.blackboxcost_file;      % Cost function file


       
%
% OPTIMIZATION
%
inputs.nlpsol.nlpsolver='eSS';                        % [] NLP solver: 
%                                                       % LOCAL: 'local_fmincon'|'local_n2fb'|'local_dn2fb'|'local_dhc'|
%                                                       %        'local_ipopt'|'local_solnp'|'local_nomad'||'local_nl2sol'
%                                                       %        'local_lsqnonlin'
%                                                       % MULTISTART:'multi_fmincon'|'multi_n2fb'|'multi_dn2fb'|'multi_dhc'|
%                                                       %            'multi_ipopt'|'multi_solnp'|'multi_nomad'|'multi_nl2sol'
%                                                       %            'multi_lsqnonlin'
%                                                       % GLOBAL: 'de'|'sres'
%                                                       % HYBRID: 'hyb_de_fmincon'|'hyb_de_n2fb'|'hyb_de_dn2fb'|'hyb_de_dhc'|'hyp_de_ipopt'|
%                                                       %         'hyb_de_solnp'|'hyb_de_nomad'|
%                                                       %         'hyb_sres_fmincon'|'hyb_sres_n2fb'|'hyb_sres_dn2fb'|'hyb_sres_dhc'|
%                                                       %         'hyp_sres_ipopt'|'hyb_sres_solnp'|'hyb_sres_nomad'
%                                                       % METAHEURISTICS:
%                                                       % 'ess' or 'eSS' (default)
%                                                       % Note that the corresponding defaults are in files: 
%                                                       % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
%                                                       % OPT_solvers\eSS_**\ess_options.m
%                                                       
                                                       
%inputs.nlpsol.eSS.log_var = 1:9;
inputs.nlpsol.eSS.maxeval = 100000;
inputs.nlpsol.eSS.maxtime = 120;

inputs.nlpsol.eSS.local.solver = 'lsqnonlin';
inputs.nlpsol.eSS.local.finish = 'lsqnonlin';

% inputs.nlpsol.multi_starts=500;                       % [] Number of different initial guesses to run local methods in the multistart approach
% inputs.nlpsol.multistart.maxeval = 100000;            % Maximum number of function evaluations for the multistart
% inputs.nlpsol.multistart.maxtime = 300;               % Maximum allowed time for the optimization
% 
% inputs.nlpsol.DE.NP = 9*10;                           % Initial population size (around 10*npar)
% inputs.nlpsol.DE.itermax = 2000;                      % Maximum number of iteratios in DE
% inputs.nlpsol.DE.F = 1; %0.75;  %1                    % F: DE-stepsize F ex [0, 2]
% inputs.nlpsol.DE.CR =0.85;                            %CR: crossover probabililty constant ex [0, 1]
% inputs.nlpsol.DE.strategy =2;                         % strategy       1 --> DE/best/1/exp                                            
%                                                       %                2 --> DE/rand/1/exp           
%                                                       %                3 --> DE/rand-to-best/1/exp   
%                                                       %                4 --> DE/best/2/exp          
%                                                       %                5 --> DE/rand/2/exp           
 


% SINCE AMIGO WILL NOT HAVE ACCESS TO OBSERVABLES, DATA, ETC. 
% PE PLOTS ARE NOT PROVIDED WITH USER_PECOST -- USER SHOULD TO THE PLOTTING
% CONTOURP IS ALLOWED, CHANGE plotlevel to 'medium'
inputs.plotd.plotlevel='noplot';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 

