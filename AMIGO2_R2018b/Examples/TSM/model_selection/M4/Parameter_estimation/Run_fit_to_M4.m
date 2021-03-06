function [] = Run_fit_to_M4( resultBase, numExperiments )
% This function runs the script for the identification of the model structure
% we propose to describe the Toggle switch to the experimental data published in Lugagne et al., 2017.
% The dataset includes 26 experiments (6 calibration+20 control). Inconsistencies noted in the original repository of
% the paper have been addressed through private communication with the
% authors and corrected accordingly. Parameter estimation is performed
% using crossvalidation. To this end we split the data between training set
% (17 randomised experiments)and test (9 experiments) set. SSE is computed
% over the test set to select the best parameter estimates. 
% It takes two inputs:
% - a string with the identifier of the output files
% - the number of iterations of parameter estimation. 
% In the paper we used numExperiments = 100.

cd ('../../../../../');
AMIGO_Startup();
cd('Examples\ToggleSwitch_FM_LB_VBK\model_selection\M4\Parameter_estimation');

% Create a matrix of initial guesses for the parameters, having as many
% rows as the number of PE iterations (numExperiments)
% Each vector is passed as input to the computing function

% theta_min=[1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 0.1386	0.1386	0.01650	0.01650 1e-6 2 2 1e-5 2 2 1e-2 1e-2 1e-3 1e-3];  % Minimum allowed values for the paramters
% theta_max=[1 1 100 100 10 1e+2 0.1386	0.1386	0.01650	0.01650 1e+3 4 4 1e+2 4 4 1e+2 1e+2 1e+2 1e+2]; % Maximum allowed values for the parameters
% 
% M_norm = lhsdesign(numExperiments,length(theta_min));
% M = zeros(size(M_norm));
% for c=1:size(M_norm,2)
%     for r=1:size(M_norm,1)
%         M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
%     end
% end 
% 
% % %check the location of the parameters that are fixed
% % ParFull = [0.1386*ones(size(M,1),1) M(:,1:2) 40*ones(size(M,1),1) M(:,3:5) 0.0165*ones(size(M,1),1) M(:,6:7) 0.0215*ones(size(M,1),1) M(:,8:end)];
% % new 
% ParFull = [0.1386*ones(size(M,1),1) M(:,1:2) 7000*ones(size(M,1),1) M(:,3:5) 0.0165*ones(size(M,1),1) M(:,6:7) 700*ones(size(M,1),1) M(:,8:end)];
% 
% save('MatrixParameters.mat','ParFull');


load('MatrixParameters.mat');

parfor epcc_exps=1:numExperiments
        try
            global_theta_guess = ParFull(epcc_exps,:);
            epccOutputResultFileNameBase = [resultBase,'-',num2str(epcc_exps)];
            [out] = fit_to_M4(epccOutputResultFileNameBase,epcc_exps,global_theta_guess);
        catch err
            %open file
            errorFile = [resultBase,'-',num2str(epcc_exps),'.errorLog'];
            fid = fopen(errorFile,'a+');
            fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
            % close file
            fclose(fid);
        end
end

