function [] = run_M1_OED( resultBase, numLoops, numExperiments )

% cd ('../../');
% AMIGO_Startup();
% 
% cd ('\Examples\TSM\model_calibration\M1\OED');

% Selected boundaries for the parameters
theta_min=[0.1386,5e-06,1e-3,40,1,2,2,0.0165,1e-05,0.001,0.0222,3.07e-4,2,2,1.32,1,0.001,0.001]; % verify Theta_T is correct 
theta_max=[0.1386,10,1000,40,100,4,4,0.0165,30,1000,0.0222,3.07e-2,4,4,1320,1000,0.1,0.1]; % Maximum allowed values for the parameters



% Create a matrix of initial guesses for the parameters, having as many
% rows as the number of PE iterations (numExperiments) 
% Each vector is passed as input to the computing function
% M_norm = lhsdesign(numExperiments,length(theta_min));
% M = zeros(size(M_norm));
% for c=1:size(M_norm,2)
%     for r=1:size(M_norm,1)
%         M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
%     end
% end 
% 
% ParFull = M; % in this case I am fitting all the values
% save('MatrixParameters_InputComparison_M1.mat','ParFull');

load('MatrixParameters_InputComparison_M1.mat');   

parfor epcc_exps=1:numExperiments
        stepd = 300;
        epccNumLoops = numLoops;
        try
            global_theta_guess = ParFull(epcc_exps,:);
            epccOutputResultFileNameBase = [resultBase,'-','OptstepseSS-',num2str(numLoops),'_loops-',num2str(epcc_exps)];
            [out]=fit_to_M1_optimisedIP(epccOutputResultFileNameBase,epccNumLoops,stepd,epcc_exps,global_theta_guess);

        catch err
            %open file
            errorFile = [resultBase,'-','OptstepseSS-',num2str(numLoops),'_loops-',num2str(epcc_exps),'.errorLog'];
            fid = fopen(errorFile,'a+');
            fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
            % close file
            fclose(fid);
        end
end

