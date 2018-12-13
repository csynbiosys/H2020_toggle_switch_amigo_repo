function [A,B,C,D] = get_ABCD()
% Derive a state space representation of the toggle switch model. 
% x(t) = A(t)x(t) + B(t)u(t)
% y(t) = C(t)x(t) + D(t)u

% t ? R denotes time
% x(t) ? Rn is the state (vector)
% u(t) ? Rm is the input or control
% y(t) ? Rp is the output

% A(t) ? Rn×n is the dynamics matrix
% B(t) ? Rn×m is the input matrix
% C(t) ? Rp×n is the output or sensor matrix
% D(t) ? Rp×m is the feedthrough matrix

% useful guide: https://ocw.mit.edu/courses/aeronautics-and-astronautics/16-30-feedback-control-systems-fall-2010/lecture-notes/MIT16_30F10_lec05.pdf

syms L_molec T_molec T_AU L_AU IPTGi aTci u_IPTG u_aTc

% Model parameters
syms g_m kL_p_m0 kL_p_m theta_T theta_aTc n_aTc n_T g_p ...
 kT_p_m0 kT_p_m theta_L theta_IPTG n_IPTG n_L ...
 sc_T_molec sc_L_molec k_iptg k_aTc

%ODE model
x1 = 1/g_m*(kL_p_m0 + (kL_p_m/(1+(T_molec/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T)))-g_p*L_molec;
x2 = 1/g_m*(kT_p_m0 + (kT_p_m/(1+(L_molec/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L)))-g_p*T_molec;
x3 = sc_T_molec*x2;
x4 = sc_L_molec*x1;
x5 = k_iptg*(u_IPTG-IPTGi)-g_p*IPTGi;
x6 = k_aTc*(u_aTc-aTci)-g_p*aTci;
    
%A matrix
A=jacobian([x1; x2; x3; x4; x5; x6],[L_molec T_molec T_AU L_AU IPTGi aTci]);

%B matrix
B=jacobian([x1; x2; x3; x4; x5; x6],[u_IPTG u_aTc]);

%C matrix
C=[0 0 1 0 0 0; 0 0 0 1 0 0];

%D matrix
D=zeros(2,2);


end

