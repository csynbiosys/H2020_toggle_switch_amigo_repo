function [ res ] = M5_Compute_SteadyState(theta, InitialStates,initial_u)
% ToggleSwitch_Compute_SteadyState Calculates the steady state for theta,
% u_IPTG and u_aTc.
% Computes the steady state of the M4 ToggleSwitch model for the given values of
% theta and the inputs u_IPTG and u_aTc.

k_m0L=theta(1);
k_m0T=theta(2);
k_mL=theta(3);
k_mT=theta(4);
k_pL=theta(5);
k_pT=theta(6);
g_mL=theta(7);
g_mT=theta(8);
g_pL=theta(9);
g_pT=theta(10);
K_IPTG_theta_LacI=theta(11);
N_LacI=theta(12);
N_IPTG=theta(13);
K_aTc_theta_TetR=theta(14);
N_TetR=theta(15);
N_aTc=theta(16);

% These parameters are not required as the steady state solution for aTc
% and IPTG is equal to the applied aTcext and IPTGext.
K_in_IPTG=theta(17); %#ok<*NASGU>
K_out_IPTG=theta(18);


%Initial values
LacI = InitialStates(1);
TetR = InitialStates(2);

% Stimulus
IPTGext = initial_u(1);
aTcext = initial_u(2);

%% Steady state equation


aTc = aTcext;
IPTG = IPTGext;

mrna_LacI=1/g_mL*(k_m0L+(k_mL/(1+(TetR/(K_aTc_theta_TetR*(aTc)^N_aTc))^N_TetR)));
mrna_TetR=1/g_mT*(k_m0T+(k_mT/(1+(LacI/(K_IPTG_theta_LacI*(IPTG)^N_IPTG))^N_LacI)));

LacI=k_pL/g_pL*mrna_LacI;
TetR=k_pT/g_pT*mrna_TetR;

res = [IPTG,mrna_LacI,mrna_TetR,LacI,TetR];

end

