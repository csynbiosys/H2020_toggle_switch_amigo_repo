load('MatrixParameters_InputComparison.mat');   

resultBase='OED-M1';
epcc_exps=1;
stepd = 600;
global_theta_guess = ParFull(epcc_exps,:);
 
startTime = datenum(now);

% Result folder
results_folder = strcat('M1',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = strcat('M1_OED',int2str(epcc_exps));
inputs.pathd.runident = 'run1';

% Read the model into the model variable
model=ToggleSwitch_load_model_M1();

% We start with no experiments
exps.n_exp=1;

% Define boundaries for the parameters 
global_theta_min=[0.1386,5e-06,1e-3,40,1,2,2,0.0165,1e-05,0.001,0.0222,3.07e-4,2,2,1.32,1,0.001,0.001]; % verify Theta_T is correct 
global_theta_max=[0.1386,10,1000,40,100,4,4,0.0165,30,1000,0.0222,3.07e-2,4,4,1320,1000,0.1,0.1]; % Maximum allowed values for the parameters

global_theta_guess = global_theta_guess';

% vector specifying parameters being considered for calibration using the
% optimised input design
param_including_vector=[false,true,true,false,true,true,true,false,true,true,false,true,true,true,true,true,true,true];

% define model, and path to results folder
inputs.model = model;
inputs.pathd.results_folder = results_folder;
inputs.pathd.short_name     = short_name;

% Specifying experiment
totalDuration = 20*60;               % Duration in of the experiment (minutes)
duration = totalDuration;   % Duration of each loop (in our case the number is 1)
stepDuration = stepd;                % Duration of each step (minutes). Note that the value passed to the function exceeds the response time, quantified in 80 mins for MPLac,r

%Compute the steady state considering the initial theta guess and 0 IPTG
y0 =  M1_compute_steady_state(global_theta_guess,[52.1819037736273,1458.74850929152],[0 25]); %[ToggleSwitch_M1_Compute_SteadyState(model.par,[1000,400],1,0) 0];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimal experiment design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inputs.exps  = exps;
format long g

for iexp=1:inputs.exps.n_exp

        % Add informtion about the experiment that is to be designed
        inputs.exps.n_exp = inputs.exps.n_exp + 1;                      % Number of experiments
        inputs.exps.exp_type{iexp}='od';                                % Specify the type of experiment: 'od' optimally designed
        inputs.exps.n_obs{iexp}=2;                                      % Number of observables in the experiment
        inputs.exps.obs_names{iexp}=char('T_AU','L_AU');               % Name of the observables in the experiment
        inputs.exps.obs{iexp}=char('LacI_AU=L_AU','TetR_AU=T_AU');          % Observation function


        % Fixed parts of the experiment
        inputs.exps.exp_y0{iexp}=y0;                                % Initial conditions
        inputs.exps.t_f{iexp}=duration;                                 % Duration of the experiment (minutes)
        inputs.exps.n_s{iexp}=duration/5+1;                             % Number of sampling times - sample every 5 min

        % OED of the input
        inputs.exps.u_type{iexp}='od';
        inputs.exps.u_interp{iexp}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
        inputs.exps.n_steps{iexp}=round(duration/stepDuration);         % Number of steps in the input
        inputs.exps.t_con{iexp}=0:stepDuration:(duration);            % Switching times
        inputs.exps.u_min{iexp}(1,:)=1e-5*ones(1,inputs.exps.n_steps{iexp});    % Lower boundary for IPTG
        inputs.exps.u_max{iexp}(1,:)=1*ones(1,inputs.exps.n_steps{iexp});  % Upper boundary for IPTG
        inputs.exps.u_min{iexp}(2,:)=1e-5*ones(1,inputs.exps.n_steps{iexp});    % Lower boundary for LacI
        inputs.exps.u_max{iexp}(2,:)=100*ones(1,inputs.exps.n_steps{iexp});  % Upper boundary for LacI

        inputs.PEsol.id_global_theta=model.par_names(param_including_vector,:);
        inputs.PEsol.global_theta_guess=transpose(global_theta_guess(param_including_vector));
        inputs.PEsol.global_theta_max=global_theta_max(param_including_vector);  % Maximum allowed values for the parameters
        inputs.PEsol.global_theta_min=global_theta_min(param_including_vector);  % Minimum allowed values for the parameters


        inputs.exps.noise_type='hetero_proportional';           % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default)
        inputs.exps.std_dev{iexp}=[0.05 0.05];
        inputs.OEDsol.OEDcost_type='Dopt';

        % SIMULATION
        inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
        inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes'(default, C)| 'sensmat'(matlab)|'fdsens2'|'fdsens5'
        inputs.ivpsol.rtol=1.0D-10;                            % [] IVP solver integration tolerances
        inputs.ivpsol.atol=1.0D-12;

end

AMIGO_Prep(inputs);
