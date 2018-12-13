load('MatrixParameters.mat');
epcc_exps=2;
numExperiments=1;
resultBase='pe';

global_theta_guess = ParFull(epcc_exps,:);
epccOutputResultFileNameBase = [resultBase,'-',num2str(epcc_exps)];

resultFileName = [strcat(epccOutputResultFileNameBase),'.dat'];


rng shuffle;
rngToGetSeed = rng;

% Write the header information of the .dat file in which the results of
% PE (estimates and the time required for computation) will be stored. 
fid = fopen(resultFileName,'w');
fprintf(fid,'HEADER DATE %s\n',datestr(datetime()));
fprintf(fid,'HEADER RANDSEED %d\n',rngToGetSeed.Seed);
fclose(fid);

startTime = datenum(now);

clear model;
clear exps;
clear best_global_theta;
clear pe_results;
clear pe_inputs;


% Specify folder name and short_name
results_folder = strcat('M4Fit',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = strcat('M4F',int2str(epcc_exps));

% Load experimental data. This data are derived, using the script
% ExtractionAllExperimentalData/ExtractionStructure_AllData_final.m, starting from data used in the paper
% Lugagne et al.
% The data derives from 26 experiments, 6 calibration and 20 control
% experiments.
load('AllDataLugagne_Final.mat');

% Read the model into the model variable. Note that this model encodes
% a path constraint to prevent negative solutions of ODEs. 
model=ToggleSwitch_load_model_M4(); 

% Initial guesses for theta 
global_theta_min=[1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 0.1386	0.1386	0.01650	0.01650 1e-6 2 2 1e-5 2 2 1e-2 1e-2 1e-3 1e-3];  % Minimum allowed values for the paramters
global_theta_max=[1 1 100 100 10 1e+2 0.1386 0.1386	0.01650	0.01650 1e+3 4 4 1e+2 4 4 1e+2 1e+2 1e+2 1e+2]; % Maximum allowed values for the parameters 
global_theta_guess = global_theta_guess';

% Randomized vector of experiments
exps_indexall = 1:1:length(Data.expName);

% Definition of the Training set. This has been obtained as
% randperm(length(Data.expName)) and extracting the first 17 elements.
% Note that here it is fixed to ensure that all global_theta_guess will
% be trained on the same experiments.
exps_indexTraining = [22,6,3,16,11,7,17,14,8,5,21,25,2,19,15,1,23];

% Definition of test set (remaining 9 experiments) 
exps_indexTest =  [2,4,18,24,13,9,20,10,12];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Run  PE on the training set
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compile the model
clear inputs;
inputs.model = model;
inputs.model.par = global_theta_guess;

inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup';

%AMIGO_Prep(inputs);

% Compute the steady state considering the initial theta guess, u_IPTG and
% u_aTc
Y0 = zeros(length(exps_indexTraining),model.n_st);
for iexp=1:length(exps_indexTraining)
    exp_indexData = exps_indexTraining(iexp);
    Y0(iexp,:) = M4_Compute_SteadyState_OverNight(epcc_exps,inputs,exp_indexData,global_theta_guess,Data.exp_data{1,exp_indexData}(:,1)',Data.Initial_IPTG{1,exp_indexData},Data.Initial_aTc{1,exp_indexData});
end

 clear exps;

% Define the exps structure, containing the experimental data to fit
exps.n_exp = length(exps_indexTraining);

for iexp=1:length(exps_indexTraining)
    exp_indexData = exps_indexTraining(iexp);
    exps.exp_type{iexp} = 'fixed'; 
    exps.n_obs{iexp} = 2; 
    exps.obs_names{iexp} = char('RFP','GFP');
    exps.obs{iexp} = char('RFP = LacI','GFP = TetR');
    exps.t_f{iexp} = Data.t_con{1,exp_indexData}(1,end); 
    exps.n_s{iexp} = Data.n_samples{1,exp_indexData}(1,1);
    exps.t_s{iexp} = Data.t_samples{1,exp_indexData}(1,:); 
    exps.u_interp{iexp} = 'step';
    exps.t_con{iexp} = Data.t_con{1,exp_indexData}(1,:);
    exps.n_steps{iexp} = length(exps.t_con{iexp})-1;
    exps.u{iexp} = Data.input{1,exp_indexData};
    exps.data_type = 'real';
    exps.noise_type = 'homo';

    exps.exp_data{iexp} = Data.exp_data{1,exp_indexData}';
    exps.error_data{iexp} = Data.standard_dev{1,exp_indexData}';
    exps.exp_y0{iexp} = Y0(iexp,:);
end


best_global_theta = global_theta_guess; 

% g_m, g_p, theta_T and theta_L excluded from identification
param_including_vector = [true,true,true,true,true,true,false,false,false,false,true,true,true,true,true,true,true,true,true,true];

% Compile the model
clear inputs;
inputs.model = model;
inputs.model.par = best_global_theta;
inputs.exps  = exps;

inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup';

AMIGO_Prep(inputs);

inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = strcat('pe-',int2str(epcc_exps));


% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERMENTS)
inputs.PEsol.id_global_theta=model.par_names(param_including_vector,:);
inputs.PEsol.global_theta_guess=transpose(best_global_theta(param_including_vector));
inputs.PEsol.global_theta_max=global_theta_max(param_including_vector);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=global_theta_min(param_including_vector);  % Minimum allowed values for the parameters

%COST FUNCTION RELATED DATA
inputs.PEsol.PEcost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'
inputs.PEsol.lsq_type='Q_expmax';
inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero'

%SIMULATION
inputs.ivpsol.ivpsolver='cvodes';
inputs.ivpsol.senssolver='cvodes';
inputs.ivpsol.rtol=1.0D-14;
inputs.ivpsol.atol=1.0D-14;

%OPTIMIZATION
inputs.nlpsol.nlpsolver='eSS';
inputs.nlpsol.eSS.maxeval = 200000;
inputs.nlpsol.eSS.maxtime = 5000;
inputs.nlpsol.eSS.log_var = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];
inputs.nlpsol.eSS.local.solver = 'nl2sol'; 
inputs.nlpsol.eSS.local.finish = 'nl2sol'; 
inputs.rid.conf_ntrials=500;

% FINAL-TIME CONSTRAINTS
%     for iexp=1:inputs.exps.n_exp
%         inputs.exps.n_const_ineq_tf{iexp} = 1;
%         inputs.exps.const_ineq_tf{iexp} = char('sviol');
%     end
%     inputs.exps.ineq_const_max_viol = 1e-6;
% 
%     

pe_start = now;
pe_inputs = inputs;
results = AMIGO_PE(inputs);
pe_results = results;
pe_end = now;

%Save the best theta
best_global_theta(param_including_vector) = results.fit.thetabest;

%Write results to the output file
fid = fopen(resultFileName,'a');
used_par_names = model.par_names(param_including_vector,:);

for j=1:size(used_par_names,1)
    fprintf(fid,'PARAM_FIT %s %f\n', used_par_names(j,:), results.fit.thetabest(j));
end

%Time in seconds
fprintf(fid,'PE_TIME %.1f\n', (pe_end-pe_start)*24*60*60);
fclose(fid);

save(strcat(epccOutputResultFileNameBase,'.mat'),'pe_results','exps','pe_inputs','best_global_theta');


%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run simulation on the test set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear inputs;
clear exps;
inputs.model = model;
inputs.model.par = best_global_theta;

inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup2';

AMIGO_Prep(inputs);

inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = strcat('simTest-',int2str(epcc_exps));


% Compute the steady state considering the initial theta guess, u_IPTG and
% u_aTc
Y0_test = zeros(length(exps_indexTest),model.n_st);
for iexp=1:length(exps_indexTest)
    exp_indexData = exps_indexTest(iexp);
    Y0_test(iexp,:) = [M4_Compute_SteadyState_OverNight(epcc_exps,inputs,exp_indexData,best_global_theta,Data.exp_data{1,exp_indexData}(:,1)',Data.Initial_IPTG{1,exp_indexData},Data.Initial_aTc{1,exp_indexData}) 0];
end

exps.n_exp = length(exps_indexTest);

for iexp=1:length(exps_indexTest)

    exp_indexData = exps_indexTest(iexp);
    exps.exp_type{iexp} = 'fixed'; 
    exps.n_obs{iexp} = 2; 
    exps.obs_names{iexp} = char('RFP','GFP');
    exps.obs{iexp} = char('RFP = LacI','GFP = TetR');
    exps.t_f{iexp} = Data.t_con{1,exp_indexData}(1,end); 
    exps.n_s{iexp} = Data.n_samples{1,exp_indexData}(1,1);
    exps.t_s{iexp} = Data.t_samples{1,exp_indexData}(1,:); 
    exps.u_interp{iexp} = 'step';
    exps.t_con{iexp} = Data.t_con{1,exp_indexData}(1,:);
    exps.n_steps{iexp} = length(exps.t_con{iexp})-1;
    exps.u{iexp} = Data.input{1,exp_indexData};
    exps.data_type = 'real';
    exps.noise_type = 'homo';

    exps.exp_data{iexp} = Data.exp_data{1,exp_indexData}';
    exps.error_data{iexp} = Data.standard_dev{1,exp_indexData}';
    exps.exp_y0{iexp} = Y0_test(iexp,:);

end


inputs.exps  = exps;

inputs.pathd.results_folder = results_folder;
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       ='-sim';
inputs.plotd.plotlevel='min';

sim_results = AMIGO_SObs(inputs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Compute SSE on the test set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SSE = zeros(length(exps_indexTest),2);
for iexp=1:length(exps_indexTest)
    exp_indexData = exps_indexTest(iexp);
    SSE_RFP(iexp) = sum((Data.exp_data{1,exp_indexData}(1,:)-sim_results.sim.sim_data{1,iexp}(:,1)').^2);
    SSE_GFP(iexp) = sum((Data.exp_data{1,exp_indexData}(2,:)-sim_results.sim.sim_data{1,iexp}(:,2)').^2);
    SSE(iexp,:) = [SSE_RFP(iexp),SSE_GFP(iexp)];
end


sim_inputs = inputs;
sim_exps = exps;
save(strcat(epccOutputResultFileNameBase,'-sim','.mat'),'sim_results','sim_inputs','sim_exps','best_global_theta','SSE');