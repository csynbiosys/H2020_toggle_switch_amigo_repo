function [model] = ToggleSwitch_load_model_M5()

% This is the script for the Inducer Exchange Model discussed in Lugagne's
% paper: https://www-nature-com.ezproxy.is.ed.ac.uk/articles/s41467-017-01498-0
% Amongst the models being considered for model selection, this is Model
% M5


%======================
% MODEL RELATED DATA
%======================

model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                              
model.n_st=5;                                       % Number of states      
model.n_par=18;                                     % Number of model parameters 
model.n_stimulus=2;                                 % Number of inputs, stimuli or control variables   
model.names_type='custom';                          % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...) 
model.st_names=char('IPTG','mrna_LacI','mrna_TetR','LacI','TetR');     % Names of the states                                              
model.par_names=char('k_m0L','k_m0T','k_mL','k_mT','k_pL','k_pT','g_mL','g_mT','g_pL','g_pT','K_IPTG_theta_LacI','N_LacI','N_IPTG','K_aTc_theta_TetR','N_TetR',...
    'N_aTc','K_in_IPTG','K_out_IPTG');                   % Names of the parameters     
model.stimulus_names=char('IPTGext','aTcext');                                        % Names of the stimuli, inputs or controls                      

model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
 char('dIPTG=((((K_in_IPTG*(IPTGext-IPTG))^2)^0.5)/2-(K_out_IPTG*(IPTG-IPTGext)+((K_out_IPTG*(IPTG-IPTGext))^2)^0.5)/2)',...%dIPTG=max(K_in_IPTG*(IPTGext-IPTG),0)-max(K_out_IPTG*(IPTG-IPTGext),0)',... 
                    'dmrna_LacI=(k_m0L+k_mL/(1+(TetR/(K_aTc_theta_TetR*(aTcext)^N_aTc))^N_TetR)-g_mL*mrna_LacI)',...
                    'dmrna_TetR=(k_m0T+k_mT/(1+(LacI/(K_IPTG_theta_LacI*(IPTG)^N_IPTG))^N_LacI)-g_mT*mrna_TetR)',...
                    'dLacI=(k_pL*mrna_LacI-g_pL*LacI)',...
                    'dTetR=(k_pT*mrna_TetR-g_pT*TetR)');              

%==================
% PARAMETER VALUES
% =================

model.par =[0.3045,0.3313,13.01,5.055,0.6606,0.5098,0.1386,0.1386,0.01650,0.01650,426.8626,2,2,2.1234,2.152,2,0.04,0.04]; 
end                                 