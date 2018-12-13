function [model] = ToggleSwitch_load_model_M2()

% This is the script for the Non Identical Inducer Exchange Model discussed
% in Lugagne's paper: https://www-nature-com.ezproxy.is.ed.ac.uk/articles/s41467-017-01498-0
% Amongst the models being considered for model selection, this is Model
% M2


%======================
% MODEL RELATED DATA
%======================

model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|
                                                           %                     'blackboxmodel'|'blackboxcost
model.n_st=6;                                       % Number of states
model.n_par=22;                                     % Number of model parameters
model.n_stimulus=2;                                 % Number of inputs, stimuli or control variables
model.names_type='custom';                          % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...)
model.st_names=char('IPTG','aTc','mrna_LacI','mrna_TetR','LacI','TetR');     % Names of the states
model.par_names=char('k_m0L','k_m0T','k_mL','k_mT','k_pL','k_pT','g_mL','g_mT','g_pL','g_pT','theta_LacI','N_LacI','theta_IPTG','N_IPTG','theta_TetR','N_TetR',...
    'theta_aTc','N_aTc','K_in_IPTG','K_out_IPTG','K_in_aTc','K_out_aTc');                  % Names of the parameters
model.stimulus_names=char('IPTGext','aTcext');                                        % Names of the stimuli, inputs or controls

%% The equations for the inducers aTc and IPTG in the ODEs below have been modified to avoid the use of max() within the ODEs. 

model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
 char('dIPTG= (K_in_IPTG*(IPTGext-IPTG)+((K_in_IPTG*(IPTGext-IPTG))^2)^0.5)/2-(K_out_IPTG*(IPTG-IPTGext)+((K_out_IPTG*(IPTG-IPTGext))^2)^0.5)/2',... % fmax(K_in_IPTG*(IPTGext-IPTG),0)-fmax(K_out_IPTG*(IPTG-IPTGext),0)',...
                    'daTc= (K_in_aTc*(aTcext-aTc)+((K_in_aTc*(aTcext-aTc))^2)^0.5)/2-(K_out_aTc*(aTc-aTcext)+((K_out_aTc*(aTc-aTcext))^2)^0.5)/2',... % fmax(K_in_aTc*(aTcext-aTc),0)- fmax(K_out_aTc*(aTc-aTcext),0)',... 
                    'dmrna_LacI=(k_m0L+k_mL/(1+(TetR/theta_TetR * 1/(1+(aTc/theta_aTc)^N_aTc))^N_TetR)-g_mL*mrna_LacI)',...
                    'dmrna_TetR=(k_m0T+k_mT/(1+(LacI/theta_LacI * 1/(1+(IPTG/theta_IPTG)^N_IPTG))^N_LacI)-g_mT*mrna_TetR)',...
                    'dLacI=(k_pL*mrna_LacI-g_pL*LacI)',...
                    'dTetR=(k_pT*mrna_TetR-g_pT*TetR)');

%==================
% PARAMETER VALUES
% =================

model.par =[3.2e-2 1.19e-1 8.3 2.06 9.726e-1 1.17 1.386e-1 1.386e-1 1.65e-2 1.65e-2 31.94 2 9.06e-2 2 30 2 11.65 2 2.75e-2 1.11e-1 1.62e-1 2e-2];


end                     	