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
syms L_molec T_molec IPTGi aTci

% known constant parameter values
syms g_m g_p theta_L

% unknown parameters
syms C1_L C2_L theta_aTc n_aTc n_T...
         C1_T C2_T theta_IPTG n_IPTG n_L...
         sc_T_molec sc_L_molec k_iptg k_aTc...
         theta_T
 
% two outputs:
syms T_AU L_AU
h    = [T_AU;L_AU];   

% two inputs:
syms  u_IPTG u_aTc
u    = [u_IPTG; u_aTc];

% states:
x    = [L_molec T_molec T_AU L_AU IPTGi aTci].';   

% parameters:
p    = [C1_L C2_L theta_aTc n_aTc n_T ...
         C1_T C2_T theta_IPTG n_IPTG n_L...
         sc_T_molec sc_L_molec k_iptg k_aTc...
         theta_T].';

% dynamic equations:
f    = [1/g_m*(C1_L + (C2_L/(1+(T_molec/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T)))-g_p*L_molec;
        1/g_m*(C1_T + (C2_T/(1+(L_molec/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L)))-g_p*T_molec;
        sc_T_molec*T_molec;
        sc_L_molec*L_molec;
        k_iptg*(u_IPTG-IPTGi)-g_p*IPTGi;
        k_aTc*(u_aTc-aTci)-g_p*aTci];  

% initial conditions: 
syms L_molec0 T_molec0 T_AU0 L_AU0 IPTGi0 aTci0
ics = [L_molec0 T_molec0 T_AU0 L_AU0 IPTGi0 aTci0];

% which initial conditions are known:
known_ics = [1 1 1 1 1 1]; 

save('TSM_recast_par_combine_unfix_theta_tetR','x','h','u','p','f','ics','known_ics');