%--------------------------------------------------------------------------
% File that creates the Toggle Switch model. 
% It stores it in a mat-file named TSM.mat.
% 
%--------------------------------------------------------------------------
% Re-formulation of the toggle switch model described in  
% J.-B. Lugagne, S. S. Carrillo, M. Kirch, A. Köhler, G. Batt, and P. Hersen,
% “Balancing a genetic toggle switch by real-time feedback control and periodic
% forcing,” Nature Communications, vol. 8, no. 1, p. 1671, Nov. 2017.
%--------------------------------------------------------------------------
clear all;

% states
syms IPTG aTc mrna_LacI mrna_TetR LacI TetR

% known constant parameter values
syms g_mL g_mT g_pL g_pT

% unknown parameters
syms k_m0L k_m0T k_mL k_mT k_pL k_pT...
        K_IPTG_theta_LacI N_LacI N_IPTG...
        K_aTc_theta_TetR N_TetR...
        N_aTc K_in_IPTG K_out_IPTG K_in_aTc K_out_aTc

% two outputs:
syms TetR LacI
h    = [TetR;LacI];   

% two inputs:
syms  IPTGext aTcext
u    = [IPTGext; aTcext];

% states:
x    = [IPTG aTc mrna_LacI mrna_TetR LacI TetR].';   

% parameters:
p    = [k_m0L k_m0T k_mL k_mT k_pL k_pT...
        K_IPTG_theta_LacI N_LacI N_IPTG...
        K_aTc_theta_TetR N_TetR...
        N_aTc K_in_IPTG K_out_IPTG K_in_aTc K_out_aTc].';

% dynamic equations:
f    = [(((K_in_IPTG*(IPTGext-IPTG))^2)^0.5)/2-(K_out_IPTG*(IPTG-IPTGext)+((K_out_IPTG*(IPTG-IPTGext))^2)^0.5)/2
        (K_in_aTc*(aTcext-aTc)+((K_in_aTc*(aTcext-aTc))^2)^0.5)/2-(K_out_aTc*(aTc-aTcext)+((K_out_aTc*(aTc-aTcext))^2)^0.5)/2 
        k_m0L+k_mL/(1+(TetR/(K_aTc_theta_TetR*(aTc)^N_aTc))^N_TetR)-g_mL*mrna_LacI
        k_m0T+k_mT/(1+(LacI/(K_IPTG_theta_LacI*(IPTG)^N_IPTG))^N_LacI)-g_mT*mrna_TetR
        k_pL*mrna_LacI-g_pL*LacI
        k_pT*mrna_TetR-g_pT*TetR];

% initial conditions: 
syms IPTG_0 aTc_0 mRNA_L0 mRNA_T0 LacI0 TetR0
ics = [IPTG_0 aTc_0 mRNA_L0 mRNA_T0 LacI0 TetR0];

% which initial conditions are known:
known_ics = [1 1 1 1 1 1]; 

save('TSM_M4','x','h','u','p','f','ics','known_ics');