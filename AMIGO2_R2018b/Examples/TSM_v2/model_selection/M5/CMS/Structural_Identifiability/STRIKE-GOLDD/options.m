%==========================================================================
% THE USER CAN DEFINE THE PROBLEM AND SET OPTIONS IN THE FOLLOWING LINES:                                                       
%==========================================================================

function [modelname,paths,opts,submodels,prev_ident_pars] = options()
%%% (1) MODEL: 
modelname = 'TSM_M5'; 

%%% (2) PATHS:
paths.meigo     = 'C:\Users\vkothama\Desktop\CurrentlyWorkingFolder\H2020_AMIGO_code\AMIGO2R2016d\Examples\ToggleSwitch_FM_LB_VBK\model_selection\M5\CMS\Structural_Identifiability\MEIGO';      
paths.models    = strcat(pwd,filesep,'models');
paths.results   = strcat(pwd,filesep,'results');
paths.functions = strcat(pwd,filesep,'functions');
                            
%%% (3) IDENTIFIABILITY OPTIONS:
opts.numeric    = 1;       % calculate rank numerically (= 1) or symbolically (= 0)
opts.replaceICs = 0;       % replace states with known initial conditions (= 1) or use generic values (= 0) when calculating rank
opts.checkObser = 0;       % check observability of states / identifiability of initial conditions (1 = yes; 0 = no).
opts.findcombos = 1;       % try to find identifiable combinations? (1 = yes; 0 = no).
opts.unidentif  = 0;       % use method to try to establish unidentifiability instead of identifiability, when using decomposition. 
opts.forcedecomp= 0;       % always decompose model (1 = yes; 0 = no).
opts.decomp     = 0;       % decompose model if the whole model is too large (1 = yes; 0 = no: instead, calculate rank with few Lie derivatives).
opts.decomp_user= 0;       % when decomposing model, use submodels specified by the user (= 1) or found by optimization (= 0). 
opts.maxLietime = 200;      % max. time allowed for calculating 1 Lie derivative.
opts.maxOpttime = 500;     % max. time allowed for every optimization (if optimization-based decomposition is used).
opts.maxstates  = 5;       % max. number of states in the submodels (if optimization-based decomposition is used).
opts.nnzDerIn   = [1,1];    % number of nonzero derivatives of the inputs (specify them in one column per input).

%%% (4) User-defined submodels for decomposition (may be left = []):    
submodels = []; 

syms N_LacI N_TetR K_IPTG_theta_LacI K_aTc_theta_TetR K_in_IPTG N_IPTG N_aTc
prev_ident_pars = [N_LacI N_TetR K_IPTG_theta_LacI K_aTc_theta_TetR K_in_IPTG N_IPTG N_aTc];  % Iteration 1

end