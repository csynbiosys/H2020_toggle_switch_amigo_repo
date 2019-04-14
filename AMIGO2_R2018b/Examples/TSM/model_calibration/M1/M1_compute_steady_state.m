function [ res ] = M1_compute_steady_state(theta, InitialStates_AU, initial_u)
% ToggleSwitch_M1_Compute_SteadyState computes the steady state of the MToggleSwitch model for the given values of
% theta and the inputs u_IPTG and u_aTc.

g_m = theta(1);
kL_p_m0 = theta(2);
kL_p_m = theta(3);
theta_T = theta(4);
theta_aTc = theta(5);
n_aTc = theta(6);
n_T = theta(7);
g_p = theta(8);
kT_p_m0 = theta(9);
kT_p_m = theta(10);
theta_L = theta(11);
theta_IPTG = theta(12);
n_IPTG = theta(13);
n_L = theta(14);
sc_T_molec = theta(15);
sc_L_molec = theta(16);
k_iptg = theta(17);
k_aTc = theta(18);

L_AU = InitialStates_AU(1);
T_AU = InitialStates_AU(2);

u_IPTG = initial_u(1);
u_aTc = initial_u(2);

%% Steady state equation

L_molec = L_AU/sc_L_molec;
T_molec = T_AU/sc_T_molec;

aTci = k_aTc*u_aTc/(g_p+k_aTc);
IPTGi = k_iptg*u_IPTG/(g_p+k_iptg);

L_molec = (1/(g_p*g_m))*(kL_p_m0 + (kL_p_m/(1+(T_molec/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T)));

T_molec = (1/(g_p*g_m))*(kT_p_m0 + (kT_p_m/(1+(L_molec/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L)));

L_AU = sc_L_molec*L_molec;
T_AU = sc_T_molec*T_molec;

dsviol = (max(-L_molec,0))^2+ (max(-T_molec,0))^2+(max(-IPTGi,0))^2+ (max(-aTci,0))^2;

res = [L_molec T_molec T_AU L_AU IPTGi aTci dsviol];

end

