% Calculate the response time for the inputs used in the calibration
% experiments
load('LugagneData_init.mat');


% Model Parameters
parameters=[60.1091 30 11.65 2 2 1.65e-2 15.8675 31.94 9.06e-2 2 2 1.65e-2 2.75e-2 1.62e-1];

% Inputs applied for the response time calculation
% Inputs=[];

for i=1:5

    % Initial values for all states in the model
    y0_init_ss = EXP_data{1,i}.init([1 2 5 6]);
    y0 = log(y0_init_ss+(1e-7.*(y0_init_ss==0))); % Replaces 0 inputs and state values with a small 1e-5

    inputs=log([EXP_data{1,i}.IPTGext+(1e-7.*(EXP_data{1,i}.IPTGext==0));...
        EXP_data{1,i}.aTcext+(1e-7.*(EXP_data{1,i}.aTcext==0))]);
    
    [rise_times] = CalculateRiseTime(inputs,y0,parameters);
    
    RT_allexps{1,i}=rise_times; 

end


save('ResponsetimeCalibrationDataset_withFsolve.mat')