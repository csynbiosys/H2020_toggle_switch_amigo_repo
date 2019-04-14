function[] = gen_SBL_input_file()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file generates output file, containing experimental data produced by
% from AMIGO toolbox . It will be used by SBL as the input time series data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% Load time series data from the results folder

    % Define the structure of the output file

    for iexp=1:inputs.exps.n_exp

        % Initial values of the observables
        Initial_values=inputs.exps.exp_y0{1,iexp}; %#ok<*NASGU>


        % Observable names
        obsnames=[];    obs=1;

        while obs<=length(inputs.exps.obs_names{1,iexp}(:,1))
           obsnames= [obsnames;inputs.exps.obs_names{1,iexp}(obs,:)]; %#ok<*AGROW>
           obs=obs+1;
        end

        % Column names
        Names=char('Sampling time (min)',obsnames);

        % Experimental data
        exp_data=table(inputs.exps.t_s{1,iexp}',inputs.exps.exp_data{1,iexp}, inputs.exps.error_data{1,iexp});

        % File Name
        file_name=strcat('sbl_input_file_Exp',num2str(iexp),'.csv');

        % write the csv file
        writetable(exp_data,file_name);

        clear exp_data
        clear Names
        
    end

end
