%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE:JAK_STAT
% The model explains Jak-Stat signaling pathway
% model taken from D2Dexamples and published in Schelker et al, 2012
% data taken from D2Dexamples                            
% EpoR is approximated by linear interpolation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='JAK_STAT';      % Folder to keep re(u1+u2)lts (in Re(u1+u2)lts) for a given problem          
inputs.pathd.short_name='JS';                % To identify figures and reports for a given problem   
inputs.pathd.runident='test1';               % Run identifieer

%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelM';                % Model introduction: 'charmodelF'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=9;                                       % Number of states      
inputs.model.n_par=8;                                      % Number of model parameters 
inputs.model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('STAT','pSTAT','pSTAT_pSTAT','npSTAT_npSTAT'...
    ,'nSTAT1','nSTAT2','nSTAT3','nSTAT4','nSTAT5');        % Names of the states                                       
inputs.model.par_names=char('p1','p2','p3','p4','offset_tSTAT','offset_pSTAT','scale_tSTAT','scale_pSTAT'); % Names of the parameters                     
inputs.model.stimulus_names=char('pEpoR');                    % Names of the stimuli, inputs or controls                      

inputs.model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
char('dSTAT =   p4 * nSTAT5 * (0.45/1.4)    - p1 * pEpoR * STAT',...
'dpSTAT =    p1 * pEpoR * STAT            - 2.0 * p2 * pSTAT^2',...
'dpSTAT_pSTAT =  p2 * pSTAT^2         - p3 * pSTAT_pSTAT',...
'dnpSTAT_npSTAT =   p3 * pSTAT_pSTAT * (1.4/0.45)    - p4 * npSTAT_npSTAT',...
'dnSTAT1 =   2.0 * p4 * npSTAT_npSTAT               - p4 * nSTAT1',...
'dnSTAT2 =   p4 * nSTAT1               - p4 * nSTAT2',...
'dnSTAT3 =   p4 * nSTAT2               - p4 * nSTAT3',...
'dnSTAT4 =   p4 * nSTAT3               - p4 * nSTAT4',...
'dnSTAT5 =   p4 * nSTAT4               - p4 * nSTAT5');


inputs.model.par=[3.93643191272349	999.999999999938	0.112478448784326	1.008467732083157 ...
    0.183938281345576 0.228317702148221 0.780014137794933 1.06479198663950]; %Nominal parameters 


                                                                        
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================


 inputs.exps.n_exp=1;                                % Number of experiments
 
for iexp=1:inputs.exps.n_exp
inputs.exps.n_obs{iexp}=2;                           % Nubmer of observables
inputs.exps.obs_names{iexp}=char('y1','y2');         % Names of observables
inputs.exps.obs{iexp}=char('y1 = offset_tSTAT + scale_tSTAT * (STAT + pSTAT + 2*pSTAT_pSTAT)',...
    'y2 = offset_pSTAT + scale_pSTAT * (pSTAT + 2*pSTAT_pSTAT)');   %,'y3 = u1'
 inputs.exps.exp_y0{iexp}=zeros(1,inputs.model.n_st); inputs.exps.exp_y0{iexp}(1,1)=1;   % Initial conditions for each experiment       
 inputs.exps.t_f{iexp}=60;                               % Experiments duration
 end

%==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================
inputs.exps.data_type='real';                         % Type of data: 'pseudo'|'pseudo_pos'|'real'             
inputs.exps.noise_type='hetero';                        % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default) 


iexp=1;
file1='pnas_data_original.xls'; % same data as in the pnas paper (D2D example)


data1 = importdata(file1, 1);
inputs.exps.n_s{iexp}=size(data1.data,1);
inputs.exps.t_s{iexp}=data1.data(:,1).';
inputs.exps.exp_data{iexp}=[data1.data(:,4) data1.data(:,2)];
inputs.exps.error_data{iexp}=[data1.data(:,5) data1.data(:,3)];

clear data1
%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.iocsol.id_par=char('p2','p3','offset_tSTAT','offset_pSTAT');      % Parameters to be considered % 'all'|User selected 
inputs.iocsol.par_max=1000*ones(1,4);             % Maximum allowed values for the paramters 
inputs.iocsol.par_min=[ 500 1e-5 1e-5 1e-5];      % Minimum allowed values for the parameters

%TIME VARYING STIMULI/CONTROL

inputs.iocsol.u_interp='linearf';               % [] Stimuli definition

for iexp=1:inputs.exps.n_exp
inputs.iocsol.t_con{iexp}=[0     3     7    11    15    24    36    48    60];
 inputs.iocsol.n_linear{iexp}=length(inputs.iocsol.t_con{iexp});

 for iu=1:inputs.model.n_stimulus
 inputs.iocsol.u_min{iexp}(iu,:)=1e-6*ones(1,inputs.iocsol.n_linear{iexp});
 inputs.iocsol.u_max{iexp}(iu,:)=1.0*ones(1,inputs.iocsol.n_linear{iexp});           % Minimum and maximum value for the input
 inputs.iocsol.u_guess{iexp}(iu,:)=[0 0 1 1 0 0 0 0 0];
 end
    
end



%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.iocsol.ioccost_type='llk';           % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.iocsol.llk_type='hetero';            % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero' 


%==================================
% REGULARIZATION PARAMETERS
%==================================

inputs.model.alpha=100.0; % Parameter value to handle control regularization (any real number)
%                         0: means no regularization
inputs.iocsol.u_ref{iexp}=inputs.iocsol.u_guess{iexp}; 
inputs.model.beta=0.0;    % Paremeter value to handle regularization in PE (any real number)
%                         0: means no regularization 
inputs.iocsol.par_ref=zeros(1,4);                    % Reference for regularization 4);%
inputs.iocsol.uttReg=0;                              % Second order regularization 

%==================================
% NUMERICAL METHODS RELATED DATA
%==================================
%
 
% SIMULATION
inputs.ivpsol.ivpsolver='ode15s';                      % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
inputs.ivpsol.senssolver='sensmat'; 
 
% 
% OPTIMIZATION
%

inputs.nlpsol.nlpsolver='eSS';             % In this case the problem will be solved with eSS
inputs.nlpsol.eSS.iterprint=1;             % Print each iteration on screen: 0-Deactivated
                                           % 1-Activated (1, default)
inputs.nlpsol.eSS.local.solver='nl2sol';      % Choose local solver
                                           % 0: Local search deactivated
                                           % 'fminsearch','nomad', 'dhc'
                                           % 'fmincon','solnp','ipopt'
                                           % for PE:'n2fb','dn2fb','lsqnonlin','nl2sol'
inputs.nlpsol.eSS.local.iterprint=0;       % Print each iteration on screen: 0-Deactivated
                                           % 1-Activated
inputs.nlpsol.eSS.local.finish='nl2sol';                                           

inputs.nlpsol.eSS.log_var = [1:4+inputs.iocsol.n_linear{iexp}]; % Decision variables to be considered in log-scale. Suitable for this problem with parameters
                                                     % ranging from 0 to 1.
inputs.nlpsol.eSS.maxeval = 1500000;
inputs.nlpsol.eSS.maxtime = 300; % iteratively increased in the run m.file %%% CHECKING conv curves to make sure is enough in every iteration
inputs.nlpsol.eSS.local.nl2sol.display = 1;


inputs.plotd.figsave=1;
