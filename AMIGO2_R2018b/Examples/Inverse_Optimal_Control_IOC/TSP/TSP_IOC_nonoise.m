%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: The three step pathway by Mendes (2001)
%        Mendes P, 2001. Modeling large biological systems from functional
%        genomic data: Parameter estimation. In Foundations of systems 
%        biology (ed. H. Kitano), pp. 163–186. MIT Press, Cambridge, MA.
%
% MODEL:      
%       dG1dt = V1/(1+(P/Ki1)^ni1+(Ka1/S)^na1)- k_1*G1;
%       dG2dt = V2/(1+(P/Ki2)^ni2+(Ka2/M1)^na2) - k_2*G2;
%       dG3dt = V3/(1+(P/Ki3)^ni3+(Ka3/M2)^na3) - k_3*G3;
%       dE1dt = V4*G1/(K4+G1) - k_4*E1;
%       dE2dt = V5*G2/(K5+G2) - k_5*E2;
%       dE3dt = V6*G3/(K6+G3) - k_6*E3;
%       dM1dt = kcat1*E1*(1/Km1)*(S-M1)/(1+S/Km1+M1/Km2)-kcat2*E2*(1/Km3)*(M1-M2)/(1+M1/Km3+M2/Km4);
%       dM2dt = kcat2*E2*(1/Km3)*(M1-M2)/(1+M1/Km3+M2/Km4)-kcat3*E3*(1/Km5)*(M2-P)/(1+M2/Km5+P/Km6);
%
%        where M1, M2, E1, E2, E3, G1, G2, and G3 represent the concentrations
%        of the species involved in the different biochemical reactions
%        and S and P keep fixed initial values for each experiment
%        (i.e., parameters under our control).
%
% PARAMETER ESTIMATION: To find the 36 unknown parameters from a set of 16
%        experiments performed under different S and P (inputs) conditions
%        and where all states are measured at 21 equidistant sampling 
%        times
%        Parameters are classified in:
%             Hill coefficients: allowed to vary within the range (0.1, 10)
%             and all other parameters allowed to vary within the
%             range (1e-6, 1e3).
%
%OTHER REFERENCES:
%      >Moles, C. G., Pedro Mendes and Julio R. Banga (2003) Parameter
%       estimation in biochemical pathways: a comparison of global
%       optimization methods. Genome Research, 13(11):2467-2474 
%      >Rodriguez-Fernandez, M., J. A. Egea and J. R. Banga (2006) Novel
%       Metaheuristic for Parameter Estimation in Nonlinear Dynamic Biological 
%       Systems. BMC Bioinformatics 7:483.
%
% NOTE!!!: [] indicates that the corresponding input may be omitted,
%              default value will be assigned
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================
% RESULTS PATHS RELATED DATA
%============================
inputs.pathd.results_folder='Mendes_3steppath_reproducibility'; % Folder to keep results (in Results) for a given problem                       
inputs.pathd.short_name='16exp_5noise_extraCPU';                       % To identify figures and reports for a given problem 
                                                     % ADVISE: the user may introduce any names related to the problem at hand 
inputs.pathd.runident=strcat('trial_nonoise_noreg_hetpro');                       % [] Identifier required in order not to overwrite previous results

%============================
% MODEL RELATED DATA
%============================
inputs.model.input_model_type='charmodelM';          % Model introduction: 'charmodelF'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|                        
                                                     %                     'blackboxmodel'|'blackboxcost                   
inputs.model.n_st=8;                                 % Number of states                                  
inputs.model.n_par=36;                                % Number of model parameters                                  
inputs.model.n_stimulus=2;                           % Number of inputs, stimuli or control variables   
inputs.model.names_type='custom';                    % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...) 
                                                     %                                       'custom'(default)
inputs.model.st_names=char('G1','G2','G3','E1','E2','E3','M1','M2');  % Names of the states                                         
inputs.model.par_names=char('V1','Ki1','ni1','Ka1','na1','k_1','V2','Ki2',...
          'ni2','Ka2','na2','k_2','V3','Ki3','ni3','Ka3','na3','k_3',...
          'V4', 'K4','k_4','V5','K5','k_5','V6','K6','k_6',...
          'kcat1','Km1','Km2','kcat2','Km3','Km4','kcat3','Km5','Km6');             % Names of the parameters  
inputs.model.stimulus_names=char('S','P');          % Names of the stimuli, inputs or controls                                  
inputs.model.eqns=...                                % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
            char('dG1=V1/(1+(P/Ki1)^ni1+(Ka1/S)^na1)- k_1*G1',...
                 'dG2= V2/(1+(P/Ki2)^ni2+(Ka2/M1)^na2) - k_2*G2',...
                 'dG3= V3/(1+(P/Ki3)^ni3+(Ka3/M2)^na3) - k_3*G3',...
                 'dE1= V4*G1/(K4+G1) - k_4*E1',...
                 'dE2= V5*G2/(K5+G2) - k_5*E2',...
                 'dE3= V6*G3/(K6+G3) - k_6*E3',...
                 'dM1=kcat1*E1*(1/Km1)*(S-M1)/(1+S/Km1+M1/Km2)-kcat2*E2*(1/Km3)*(M1-M2)/(1+M1/Km3+M2/Km4)',...  
                 'dM2=kcat2*E2*(1/Km3)*(M1-M2)/(1+M1/Km3+M2/Km4)-kcat3*E3*(1/Km5)*(M2-P)/(1+M2/Km5+P/Km6)');
             
inputs.model.par=[  1  1  2  1  2  1  1  1  2  1  2  1  1  1  2  1  2 ...
    1 0.1 1  0.1 0.1  1  0.1 0.1 1 0.1  1  1  1  1  1  1  1  1  1];      % Nominal value for the parameters, this allows to fix known parameters
                                                                          % These values may be updated during optimization  

                                                                      
                                                                          

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
data=load('SData_16exp_SData2_nonoise\strreport_16exp_SData2_nonoise.mat');%nonoise
inputs.exps.n_exp=16;                                % Number of experiments
 
 % Most inputs are common to all experiments therefore a loop over
 % experiments is defined
 for iexp=1:inputs.exps.n_exp
inputs.exps.obs{iexp}='states';                      % All states in model are measured    
inputs.exps.exp_y0{iexp}=data.inputs.exps.exp_y0{1,iexp};
inputs.exps.t_f{iexp}=data.inputs.exps.t_f{1,iexp};
inputs.exps.n_s{iexp}=data.inputs.exps.n_s{1,iexp};
inputs.exps.t_s{iexp}=data.inputs.exps.t_s{1,iexp};
inputs.exps.exp_data{iexp}=data.results.sim.exp_data{1,iexp};
inputs.exps.error_data{iexp}=data.results.sim.error_data{1,iexp};
 end

%==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================
inputs.exps.data_type='real';                         % Type of data: 'pseudo'|'pseudo_pos'|'real'             
inputs.exps.noise_type='hetero';                       % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default) 

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.iocsol.id_par=char('V1','Ki1','ni1','Ka1','na1','k_1','V2','Ki2',...
          'ni2','Ka2','na2','k_2','V3','Ki3','ni3','Ka3','na3','k_3',...
          'V4', 'K4','k_4','V5','K5','k_5','V6','K6','k_6',...
          'kcat1','Km1','Km2','kcat2','Km3','Km4','kcat3','Km5','Km6');                          % 'all'|User selected 
inputs.iocsol.par_max=[  5e2  5e2 10  5e2 10  5e2  5e2  5e2  10  5e2  10  5e2  5e2 5e2...
  10 5e2 10  5e2  5e2 5e2 5e2 5e2 5e2 5e2 5e2 5e2  5e2  5e2  5e2 5e2  5e2 5e2  5e2 5e2 5e2 5e2];   % Maximum allowed values for the paramters
inputs.iocsol.par_min=[  1e-6   1e-6  1e-1  1e-6  1e-1  1e-6  1e-6  1e-6  1e-1  1e-6  1e-1...
  1e-6  1e-6  1e-6  1e-1  1e-6  1e-1  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6...
  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6  1e-6];       % Minimum allowed values for the parameters

inputs.iocsol.par_ref=zeros(1,inputs.model.n_par);                                  % Reference for regularization


inputs.iocsol.u_interp='stepf';               % [] Stimuli definition
for iexp=1:inputs.exps.n_exp
inputs.iocsol.n_steps{iexp}=data.inputs.exps.n_steps{1,iexp};
 for iu=1:inputs.model.n_stimulus
 inputs.iocsol.u_min{iexp}(iu,:)=0;
 inputs.iocsol.u_max{iexp}(iu,:)=2.5*data.inputs.exps.u{1,iexp}(iu,:);           % Minimum and maximum value for the input
 inputs.iocsol.u_guess{iexp}(iu,:)=1.25*data.inputs.exps.u{1,iexp}(iu,:);       % Guess value for the input
 end
  inputs.iocsol.u_ref{iexp}=inputs.iocsol.u_guess{iexp};
  inputs.iocsol.t_con{iexp}= data.inputs.exps.t_con{1,iexp};
end

 

%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.iocsol.ioccost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.iocsol.lsq_type='Q_expmax';                     % [] To be defined for lsq function, 'Q_I' (weighting matrix the identity | 
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


% OPTIMIZATION
inputs.nlpsol.nlpsolver='eSS';             % In this case the problem will be solved with eSS
inputs.nlpsol.eSS.iterprint=1;             % Print each iteration on screen: 0-Deactivated
                                           % 1-Activated (1, default)
inputs.nlpsol.eSS.local.solver='nl2sol';  % Choose local solver
                                           % 0: Local search deactivated
                                           % 'fminsearch','nomad', 'dhc'
                                           % 'fmincon','solnp','ipopt'
                                           % for PE:'n2fb','dn2fb','lsqnonlin','nl2sol'
inputs.nlpsol.eSS.local.iterprint=0;       % Print each iteration on screen: 0-Deactivated
                                           % 1-Activated
inputs.nlpsol.eSS.local.finish='nl2sol';                                           

inputs.nlpsol.eSS.log_var = 1:36;                     % Decision variables to be considered in log-scale. Suitable for this problem with parameters
                                                     % ranging from 0 to 1.

inputs.nlpsol.eSS.maxeval = 4*2500000;
inputs.nlpsol.eSS.maxtime = 600;% 
inputs.nlpsol.eSS.local.nl2sol.display = 1;
inputs.nlpsol.eSS.local.nl2sol.maxiter             =     300;        % max number of iteration
inputs.nlpsol.eSS.local.nl2sol.maxfeval            =     1400;         % max number of function evaluation
inputs.plotd.figsave=1;

%%% ORIGINAL CONTROLS 
%  inputs.exps.u{1}=[0.1; 0.05];
%  inputs.exps.u{2}=[0.1; 0.13572];
%  inputs.exps.u{3}=[0.1; 0.3684];
%  inputs.exps.u{4}=[0.1; 1];
%  inputs.exps.u{5}=[0.46416; 0.05];
%  inputs.exps.u{6}=[0.46416; 0.13572];
%  inputs.exps.u{7}=[0.46416; 0.3684];
%  inputs.exps.u{8}=[0.46416; 1];
%  inputs.exps.u{9}=[2.1544; 0.05];
%  inputs.exps.u{10}=[2.1544; 0.13572];
%  inputs.exps.u{11}=[2.1544; 0.3684];
%  inputs.exps.u{12}=[2.1544; 1];
%  inputs.exps.u{13}=[10; 0.05];
%  inputs.exps.u{14}=[10; 0.13572];
%  inputs.exps.u{15}=[10; 0.3684];
%  inputs.exps.u{16}=[10; 1];


