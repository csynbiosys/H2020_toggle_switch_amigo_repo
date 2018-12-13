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


%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='LPN3B';        % Folder to keep re(u1+u2)lts (in Re(u1+u2)lts) for a given problem          
inputs.pathd.short_name='lpn3b';            % To identify figures and reports for a given problem   
inputs.pathd.runident='test1';              % Run identifieer


%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelM';                   % Model introduction: 'charmodelF'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|                        
                                                              %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=6;                                          % Number of states      
inputs.model.n_par=4;                                         % Number of model parameters 
inputs.model.n_stimulus=3;                                    % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('S1','S2','S3','S4','OBJ','Etot'); % Names of the states                                              
inputs.model.par_names=char('k1','k2','k3','cost_constrain'); % Names of the parameters                     
inputs.model.stimulus_names=char('e1','e2','e3');             % Names of the stimuli, inputs or controls                      
inputs.model.eqns=...                                         % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
                char( 'dS1 = 0',...
                'dS2 = k1*S1*e1-k2*S2*e2',...
                'dS3 = k2*S2*e2-k3*S3*e3',...
                'dS4 = k3*S3*e3',...
                'dOBJ = S2+S3',...
                'dEtot = (max(e1+e2+e3-cost_constrain,0))^2'); %This is to compute Etot; this can be implemented as a control constraint as well, see bellow


inputs.model.par=[1 1 1 1]; %solution as nominal

                                                                      
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
%Loading the experimental data (change between the ones with and without noise)
data=load('SData_single_exp_par1_tf4.3_3pwc_SData4_nonoise\strreport_single_exp_par1_tf4.3_3pwc_SData4_nonoise.mat');                          % Reads data from a .mat file


inputs.exps.n_exp=1;                                % Number of experiments
 
for iexp=1:inputs.exps.n_exp
inputs.exps.n_obs{iexp}=5;                                             % Number of observables
inputs.exps.obs_names{iexp}=char('s1','s2','s3','s4','obj');           % Names of observables
inputs.exps.obs{iexp}=char('s1=S1','s2=S2','s3=S3','s4=S4','obj=OBJ'); % Definition of observables
inputs.exps.exp_y0{iexp}=[1 0 0 0 0 0];                                % Initial conditions for each experiment       
inputs.exps.t_f{iexp}=4.3;                                             % Experiments duration
inputs.exps.n_s{iexp}=data.inputs.exps.n_s{1,iexp};                    % number of sampling times
inputs.exps.t_s{iexp}=data.inputs.exps.t_s{1,iexp};                    % Sampling times
end

%==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================
inputs.exps.data_type='real';                       % Type of data: 'pseudo'|'pseudo_pos'|'real'             
inputs.exps.noise_type='hetero';                    % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default) 


for iexp=1:inputs.exps.n_exp 
inputs.exps.exp_data{iexp}=data.results.sim.exp_data{1,iexp};         % Experimental data
inputs.exps.error_data{iexp}=data.results.sim.error_data{1,iexp};     % Experimental error
end

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.iocsol.id_par=char('k1','k2','k3');                          % Parameters to be considered; 'all'|User selected 
inputs.iocsol.par_max=[50 50 50];                                   % Maximum allowed values for the paramters
inputs.iocsol.par_min=1e-5*ones(1,3);                               % Minimum allowed values for the parameters


%TIME VARYING STIMULI/CONTROL
 
 inputs.iocsol.u_interp='step';               % [] Stimuli definition

for iexp=1:inputs.exps.n_exp
inputs.iocsol.n_steps{iexp}=3;               % [] Stimuli definition
inputs.iocsol.t_con{iexp}= 0:inputs.exps.t_f{iexp}/inputs.iocsol.n_steps{iexp}:inputs.exps.t_f{iexp};
for iu=1:inputs.model.n_stimulus
 inputs.iocsol.u_min{iexp}(iu,:)=0*ones(1,inputs.iocsol.n_steps{iexp});
 inputs.iocsol.u_max{iexp}(iu,:)=1*ones(1,inputs.iocsol.n_steps{iexp});           % Minimum and maximum value for the input
 inputs.iocsol.u_guess{iexp}(iu,:)=0.5*ones(1,inputs.iocsol.n_steps{iexp});       % Guess value for the input
 end
end

% CONSTRAINTS IN THE CONTROLS (APPART FROM BOUNDS)<
 inputs.iocsol.n_control_const=1;
 inputs.iocsol.control_const=char('e1{1}+e2{1}+e3{1}-1');                                 % c(u)<=0
 inputs.iocsol.control_const_max_viol=1.0e-5;
 
         
%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.iocsol.ioccost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.iocsol.lsq_type='Q_expmax';                     % [] To be defined for lsq function, 'Q_I' (weighting matrix the identity | 
                                                      %                                    'Q_expmax' (weighting matrix using max exp data) 

%==================================
% REGULARIZATION PARAMETERS
%==================================

inputs.model.alpha=1.0;   % Parameter value to handle control regularization (any real number)
                          % 0: means no regularization
inputs.iocsol.u_ref{1}=zeros(inputs.model.n_stimulus,inputs.iocsol.n_steps{1}); % Reference for regularization 
         
inputs.model.beta=1.0;    % Paremeter value to handle regularization in PE (any real number)
                          % 0: means no regularization   
inputs.IOCsol.par_ref=zeros(1,3);                  % Parameters reference for regularization
inputs.IOCsol.smoothing=0;                           % Smoothing of the control profile
inputs.IOCsol.uttReg=0;                              % Second order regularization 


%==================================
% NUMERICAL METHODS RELATED DATA
%==================================
%
 
% % SIMULATION
inputs.ivpsol.ivpsolver='ode15s';                      % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
inputs.ivpsol.rtol=1.0D-7;                             % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0D-7; 
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
inputs.nlpsol.eSS.local.iterprint=0;       % Print each iteration on screen: 0-Deactivated
                                           % 1-Activated
inputs.nlpsol.eSS.local.finish='fmincon';                                           

inputs.nlpsol.eSS.log_var = 1:3;           % Decision variables to be considered in log-scale. Suitable for this problem with parameters
                                           % ranging from 0 to 1.
inputs.nlpsol.eSS.maxeval = 2500000;
inputs.nlpsol.eSS.maxtime = 600;           % Extend duration for refined solutions

inputs.plotd.figsave=1;
