%% Load Experimental data
load('AllDataLugagne_Final_21exp.mat');


%% Initial state values
[model] = ToggleSwitch_load_model_M1();

% % Store model details 
% inputs.model=model;
% inputs.model.exe_type='standard';
% 
% % Preprocess input
% AMIGO_Prep(inputs);

% Compute the steady state considering the initial theta guess, u_IPTG and
% u_aTc
% epcc_exps=1;



%% Calculate Rise time

RT_from_IP1=[]; Inputs1=[];
RT_from_IP2=[];

        
% for exp=1:21
%     
%     Data.init_u{exp}=[Data.Initial_IPTG{1,exp}; Data.Initial_aTc{1,exp}]; 
%     InitVals = Data.exp_data{1,exp}(:,1);  %M1_compute_steady_state(model.par,Data.exp_data{1,1}(:,1)',Data.init_u{1});
% 
%         for u_IPTG= [1e-5 0.2 0.4 0.6 0.8 0.99]
% 
%             for u_aTc=100.*[1e-5 0.2 0.4 0.6 0.8 0.99]
% 
%             [rise_times] = CalculateRespTime_M1([u_aTc; u_IPTG],InitVals,model.par);
% 
%             RT_from_IP1=[RT_from_IP1;rise_times(1:2)]; %#ok<*AGROW>
%             RT_from_IP2=[RT_from_IP2;rise_times(3:4)]; %#ok<*AGROW>
% 
%             Inputs1=[Inputs1; [u_aTc; u_IPTG]'];
% 
%             end
%         end
% end


for exp=1:21
    
    Data.init_u{exp}=[Data.Initial_IPTG{1,exp}; Data.Initial_aTc{1,exp}]; 
    InitVals = Data.exp_data{1,exp}(:,1);  %M1_compute_steady_state(model.par,Data.exp_data{1,1}(:,1)',Data.init_u{1});

        for u_IPTG=[1e-5 0.2 0.4 0.6 0.8 0.99]

            for u_aTc=100.*[0.99 0.8 0.6 0.4 0.2 1e-5]

            [rise_times] = CalculateRespTime_M1([u_aTc; u_IPTG],InitVals,model.par);

            RT_from_IP1=[RT_from_IP1;rise_times(1:2)]; %#ok<*AGROW>
            RT_from_IP2=[RT_from_IP2;rise_times(3:4)]; %#ok<*AGROW>

            Inputs1=[Inputs1; [u_aTc; u_IPTG]'];

            end
        end
end

    