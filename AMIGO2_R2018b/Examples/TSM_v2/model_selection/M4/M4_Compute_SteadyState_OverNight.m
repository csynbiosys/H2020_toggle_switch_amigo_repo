function [InitialConditions]= M4_Compute_SteadyState_OverNight(epcc_exps,inputs,iexp,params,InitialExpData,IPTGe,aTce)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the initial state of the MToggleSwitch model after the
% ON inclubation, where cells are exposed to . We assume that the system is at steady state
% concentration specified in Run_MPLacr_in_silico_experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
% Fixed parts of the experiment
duration = 48*60;     % Duration of the experiment in min

clear newExps;
newExps.n_exp = 1;
newExps.n_obs{1}=2;                                  % Number of observables per experiment                         
newExps.obs_names{1} = char('RFP','GFP');
newExps.obs{1} = char('RFP = LacI','GFP = TetR');% Name of the observables 
newExps.exp_y0{1}=[M4_Compute_SteadyState(params,InitialExpData,IPTGe,aTce)];     
newExps.t_f{1}=duration;               % Experiment duration
    
newExps.u_interp{1}='sustained';
newExps.u{1}=[IPTGe;aTce];
newExps.t_con{1}=[0,duration];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mock an experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
inputs.exps = newExps;
inputs.plotd.plotlevel='noplot';
inputs.pathd.runident= strcat('sim-',int2str(epcc_exps),int2str(iexp));

% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';
inputs.ivpsol.senssolver='cvodes';
inputs.ivpsol.rtol=1.0D-14;
inputs.ivpsol.atol=1.0D-14;
    
AMIGO_Prep(inputs);
sim = AMIGO_SModel(inputs);

InitialConditions = sim.sim.states{1,1}(end,:);

end