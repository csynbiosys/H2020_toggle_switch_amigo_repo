%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: Bacterial growth in batch culture
% Author: E. Balsa-Canto
% Read batch_bac_growht.pdf for details on the implementation and use of
% this script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables
clc

%============================
% RESULTS PATHS RELATED DATA
%============================
inputs.pathd.results_folder='Bacterial_batch_growth'; % Folder to keep results (in Results) for a given problem
inputs.pathd.short_name='bbg';                        % To identify figures and reports for a given problem
% ADVISE: the user may introduce any names related to the problem at hand
inputs.pathd.runident='ts_oed';                           % [] Identifier required in order not to overwrite previous results
%    This may be modified from command line. 'run1'(default)


%============================
% MODEL RELATED DATA
%============================
inputs.model.input_model_type='charmodelM';          % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|
%                     'blackboxmodel'|'blackboxcost
inputs.model.n_st=2;                                 % Number of states
inputs.model.n_par=4;                                % Number of model parameters
inputs.model.n_stimulus=0;                           % Number of inputs, stimuli or control variables
inputs.model.names_type='custom';                    % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...)
%                                       'custom'(default)
inputs.model.st_names=char('cb','cs');               % Names of the states
inputs.model.par_names=char('mumax','ks','kd','yield');             % Names of the parameters
inputs.model.stimulus_names=[];                      % Names of the stimuli, inputs or controls
inputs.model.eqns=...                                % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
    char('dcb=((mumax*cs*cb)/(ks+cs))-kd*cb',...
    'dcs= -((mumax*cs*cb)/(ks+cs))/yield');

mumax=5;  ks=5;  kd=3;  yield=2;
inputs.model.par=[mumax ks kd yield];               % Nominal value for the parameters, this allows to fix known parameters
% These values may be updated during optimization

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
inputs.exps.n_exp=1;                                 % Number of experiments
inputs.exps.n_obs{1}=2;                              % Number of observed quantities per experiment
inputs.exps.obs_names{1}=char('obsB','obsS');               % Name of the observed quantities per experiment
inputs.exps.obs{1}=char('obsB=cb','obsS=cs');                  % Observation function
inputs.exps.exp_y0{1}=[1 300];       % Initial conditions for each experiment
inputs.exps.t_f{1}=10;                               % Experiments duration
inputs.exps.n_s{1}=11;                               % Number of sampling times
inputs.exps.t_s{1}=[0:1:10];                         % [] Sampling times, by default equidistant
assert(inputs.exps.t_f{1} == inputs.exps.t_s{1}(end))
%==================================
%==================================
%==================================
inputs.exps.exp_type{1}='od';                        % Indicates if the the experiment should
inputs.exps.exp_y0_type{1}='od';               % Indicates if the initial conditions should or
% not be optimally designed: 'od' and 'fixed'
inputs.exps.id_y0{1} = char('cb','cs'); % all doesn't work, inital_guess is miss calculated then
inputs.exps.y0_guess{1} = [1.9 24];
inputs.exps.y0_min{1} = [0 0];       % Minimum allowed value for the initial conditions
inputs.exps.y0_max{1} = [50 3000];   % Maximum allowed value for the initial conditions

inputs.exps.tf_type{1}='fixed';                       % [] Type of experiment duration: 'fixed'(default) | 'od' (to be designed)
% inputs.exps.tf_min{1} = 5;   % Minimum allowed value for the experiment duration
% inputs.exps.tf_max{1}  = 50;  % Maximum allowed value for the experiment duration
% inputs.exps.tf_guess{1} = 10; %  Initial guess for the experiment duration
% 
% 
% inputs.exps.ts_type{1}='fixed';                          % [] Type of sampling times: 'fixed'(default) | 'od' (to be designed)
% inputs.exps.ts_0{1}=0;                                % First sampling time. By default=0
% inputs.exps.ts_min_dist{1}=1;            % Minimum distance between sampling times
% inputs.exps.max_ns{1} = 15;                           % Maximum number of sampling times

inputs.exps.std_dev{1}=0.15;                          % Standard deviation of the noise for each experiment: Ex: 0.05 <=> 5%


%----------------------------------------------------------------------------------------------------------------

%==================================
% COST FUNCTION RELATED DATA
%==================================

inputs.exps.noise_type='homo';                    % Type of experimental noise: 'homo' |'homo_var'| 'hetero'
inputs.OEDsol.OEDcost_type='Eopt';                % FIM based criterium: 'Dopt'|'Eopt'|'Aopt'|'Emod'|'DoverE'

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)
inputs.PEsol.id_global_theta='all';             % 'all'|User selected
inputs.PEsol.global_theta_max=[10 10 10 10];    % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min= [0 0 0 0];       % Minimum allowed values for the parameters
inputs.PEsol.global_theta_guess=[7.0 2.5 10 0.1];      % [] Initial guess values for the parameters
%    Default corresponds to the mean between
%    max and min


%==================================
% COST FUNCTION RELATED DATA
%==================================
inputs.PEsol.PEcost_type='llk';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'

inputs.PEsol.lsq_type='Q_I';
inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero'

%==================================
% NUMERICAL METHODS RELATED DATA
%==================================

% SIMULATION
inputs.ivpsol.ivpsolver='ode15s';                     % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
%                'lsodesst'|'lsoda'|
%                'ode15s' (default, MATLAB, sbml)|'ode113'
inputs.ivpsol.senssolver='sensmat';                    % [] Sensitivities solver: 'cvodes'(default, C)| 'sensmat'(matlab)|'fdsens2'|'fdsens5'
%                          'sensmat' (matlab) |
%                          'fdsens2','fdsens5' (finite differences)
inputs.ivpsol.rtol=1.0D-8;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0D-8;


% OPTIMIZATION

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
%inputs.nlpsol.eSS.log_var = 1:4;
inputs.nlpsol.eSS.maxeval = 10000;
inputs.nlpsol.eSS.maxtime = 10;
inputs.nlpsol.eSS.local.solver = 'fminsearch';
inputs.nlpsol.eSS.local.finish = 'fminsearch';


inputs.nlpsol.multi_starts=500;                        % [] Number of different initial guesses to run local methods in the multistart approach
inputs.nlpsol.multistart.maxeval = 20000;            % Maximum number of function evaluations for the multistart
inputs.nlpsol.multistart.maxtime = 120;                % Maximum allowed time for the optimization
inputs.nlpsol.eSS.local.nl2sol.maxiter             =     300;        % max number of iteration
inputs.nlpsol.eSS.local.nl2sol.maxfeval            =     400;         % max number of function evaluation


%==================================
% RIdent or GRank DATA
%==================================
inputs.rid.conf_ntrials=500;                          % [] Number of trials for the robust confidence computation (default: 500)
% inputs.rank.gr_samples=10000;                         % [] Number of samples for global sensitivities and global rank within LHS (default: 10000)
%
%
%==================================
% DISPLAY OF RESULTS
%==================================
%
inputs.plotd.plotlevel='full';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot'
inputs.plotd.figsave=1;
% inputs.plotd.epssave=0;                              % [] Figures may be saved in .eps (1) or only in .fig format (0) (default)
% inputs.plotd.number_max_states=8;                    % [] Maximum number of states per figure
% inputs.plotd.number_max_obs=8;                       % [] Maximum number of observables per figure
% inputs.plotd.n_t_plot=100;                           % [] Number of times to be used for observables and states plots
% inputs.plotd.number_max_hist=8;                      % [] Maximum number of unknowns histograms per figure (multistart)
inputs.plotd.nx_contour=100;                          % Number of points for plotting the contours x and y direction
inputs.plotd.ny_contour=100;                          % ADVISE: >50
