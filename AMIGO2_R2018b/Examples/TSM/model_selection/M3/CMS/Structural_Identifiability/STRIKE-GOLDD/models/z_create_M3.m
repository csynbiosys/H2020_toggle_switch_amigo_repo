%--------------------------------------------------------------------------
% File that creates the Toggle Switch model. 
% It stores it in a mat-file named TSM.mat.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the script for the Inducer Exchange Model discussed in Lugagne's
% paper: https://www-nature-com.ezproxy.is.ed.ac.uk/articles/s41467-017-01498-0
% Amongst the models being considered for model selection, this is Model
% M3
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% states
syms IPTG mrna_LacI mrna_TetR LacI TetR

% known constant parameter values
syms g_mL g_mT g_pL g_pT

% unknown parameters
syms k_m0L k_m0T k_mL k_mT k_pL k_pT theta_LacI N_LacI...
    theta_IPTG N_IPTG theta_TetR N_TetR...
    theta_aTc N_aTc K_in_IPTG K_out_IPTG

% two outputs:
syms TetR LacI
h    = [TetR;LacI];   

% two inputs:
syms  IPTGext aTcext
u    = [IPTGext; aTcext];

% states:
x    = [IPTG mrna_LacI mrna_TetR LacI TetR].';   

% parameters:
p    = [k_m0L k_m0T k_mL k_mT k_pL k_pT theta_LacI N_LacI...
        theta_IPTG N_IPTG theta_TetR N_TetR...
        theta_aTc N_aTc K_in_IPTG K_out_IPTG].';

% dynamic equations:
f    = [(((K_in_IPTG*(IPTGext-IPTG))^2)^0.5)/2-(K_out_IPTG*(IPTG-IPTGext)+((K_out_IPTG*(IPTG-IPTGext))^2)^0.5)/2
       k_m0L+k_mL/(1+(TetR/theta_TetR * 1/(1+(aTcext/theta_aTc)^N_aTc))^N_TetR)-g_mL*mrna_LacI
       k_m0T+k_mT/(1+(LacI/theta_LacI * 1/(1+(IPTG/theta_IPTG)^N_IPTG))^N_LacI)-g_mT*mrna_TetR
       k_pL*mrna_LacI-g_pL*LacI
       k_pT*mrna_TetR-g_pT*TetR];

% initial conditions: 
syms IPTG_0 mRNA_L0 mRNA_T0 LacI0 TetR0
ics = [IPTG_0 mRNA_L0 mRNA_T0 LacI0 TetR0];

% which initial conditions are known:
known_ics = [1 1 1 1 1]; 

save('TSM_M3','x','h','u','p','f','ics','known_ics');