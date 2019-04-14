function [rise_times] = CalculateRiseTime(inputs,InitVals,theta)
% Calculate Rise time for a MIMO system with 2 inputs and 2 outputs



%% Step 1: Calculate A, B, C, D Matrices
[A,B,C,D] = get_ABCD();


% Plug in values of parameters and steady states
% Parameter values
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


%Inputs 
u_IPTG=inputs(1);
u_aTc=inputs(2);



%% Step 2: Calculate steady state at which the model is linearised

% Will evaluate the Jacobian at ss_values: the steady state value of the
% system extracted from the analytical solution for the system
ss_values = ToggleSwitch_M5_Compute_SteadyState(theta, InitVals, u_IPTG, u_aTc );

% Steady state values
L_molec=ss_values(1);
T_molec=ss_values(2);
T_AU=ss_values(3);
L_AU=ss_values(4);
IPTGi=ss_values(5);
aTci=ss_values(6);

%%  Step 3: Re-evaluating the Jacobian, with all parameters and steady state values plugged in. 
A=eval(A);
B=eval(B);


%% Step 4: Applying a step input on both the channels in the model
sys=ss(A,B,C,D,'TimeUnit','minutes');

% % Apply a step input
% [Y1,T1] = step(A,B,C,D,1); %#ok<*ASGLU>
% [Y2,T2] = step(A,B,C,D,2);

[y,t]=step(sys);

%% Step 5: calculating Rise time

% S1=stepinfo(Y1,T1,'RiseTimeThreshold',[0.10 0.9]);
% S2=stepinfo(Y2,T2,'RiseTimeThreshold',[0.10 0.9]);

S=stepinfo(y,t,'RiseTimeThreshold',[0.10 0.9]);
rt1=S(1,1).RiseTime;
rt2=S(1,2).RiseTime;
rt3=S(2,1).RiseTime;
rt4=S(2,2).RiseTime;

rise_times=[rt1 rt2 rt3 rt4];

end

