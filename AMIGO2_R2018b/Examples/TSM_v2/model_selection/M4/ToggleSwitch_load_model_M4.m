function [model] = ToggleSwitch_load_model_M4()

% This is the script for the modified Non Identical Inducer Exchange Model
% from Lugagne's paper: https://www-nature-com.ezproxy.is.ed.ac.uk/articles/s41467-017-01498-0
% Amongst the models being considered for model selection, this is Model M4


%======================
% MODEL RELATED DATA
%======================

model.AMIGOJac=1;
model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|
                                                           %                     'blackboxmodel'|'blackboxcost
model.n_st=6;                                       % Number of states
model.n_par=20;                                     % Number of model parameters
model.n_stimulus=2;                                 % Number of inputs, stimuli or control variables
model.names_type='custom';                          % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...)
model.st_names=char('IPTG','aTc','mrna_LacI','mrna_TetR','LacI','TetR');     % Names of the states
model.par_names=char('k_m0L','k_m0T','k_mL','k_mT','k_pL','k_pT','g_mL','g_mT','g_pL','g_pT','K_IPTG_theta_LacI','N_LacI','N_IPTG','K_aTc_theta_TetR','N_TetR',...
    'N_aTc','K_in_IPTG','K_out_IPTG','K_in_aTc','K_out_aTc');                  % Names of the parameters
model.stimulus_names=char('IPTGext','aTcext');                                        % Names of the stimuli, inputs or controls

%% The equations for the inducers aTc and IPTG in the ODEs below have been modified to avoid the use of max() within the ODEs. 

model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
 char('dIPTG=((((K_in_IPTG*(IPTGext-IPTG))^2)^0.5)/2-(K_out_IPTG*(IPTG-IPTGext)+((K_out_IPTG*(IPTG-IPTGext))^2)^0.5)/2)',...%dIPTG=max(K_in_IPTG*(IPTGext-IPTG),0)-max(K_out_IPTG*(IPTG-IPTGext),0)',...
                    'daTc=(K_in_aTc*(aTcext-aTc)+((K_in_aTc*(aTcext-aTc))^2)^0.5)/2-(K_out_aTc*(aTc-aTcext)+((K_out_aTc*(aTc-aTcext))^2)^0.5)/2',... % fmax(K_in_aTc*(aTcext-aTc),0)- fmax(K_out_aTc*(aTc-aTcext),0)',... 
                    'dmrna_LacI=(k_m0L+k_mL/(1+(TetR/(K_aTc_theta_TetR*(aTc)^N_aTc))^N_TetR)-g_mL*mrna_LacI)',...
                    'dmrna_TetR=(k_m0T+k_mT/(1+(LacI/(K_IPTG_theta_LacI*(IPTG)^N_IPTG))^N_LacI)-g_mT*mrna_TetR)',...
                    'dLacI=(k_pL*mrna_LacI-g_pL*LacI)',...
                    'dTetR=(k_pT*mrna_TetR-g_pT*TetR)');

%==================
% PARAMETER VALUES
% =================

model.par =[0.03200	0.1190	8.300	2.060	0.9726	1.170	0.1386	0.1386	0.01650	0.01650	2.575	2	2	352.5386	2	11.65	0.02750	0.1110	0.1620	0.02000];

end                                 