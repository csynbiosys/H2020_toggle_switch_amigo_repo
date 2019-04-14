% RIdent data

% Load Data
% load('strreport_M2_RIdent_run2.mat')

% Exclude fixed parameters

% Model M2
% param_including_vector=[true,true,true,true,true,true,false,false,false,false,true,true,true,true,true,true,true,true,true,true,true,true];

% Model M1
% param_including_vector=[false,true,true,false,true,true,true,false,true,true,false,true,true,true,true,true,true,true];

%Model M4
% param_including_vector=[true,true,true,true,true,true,false,false,false,false,true,true,true,true,true,true,true,true,true,true];

% Model M3
% param_including_vector=[false,false,false,false,false,false,false,false,false,false,true,true,true,true,true,true,true,true,true,true];
param_including_vector=[false,true,true,false,true,true,true,false,true,true,false,true,true,true,true,true,true,true];

% Model M5
%param_including_vector=[true,true,true,true,true,true,false,false,false,false,true,true,true,true,true,true,true,true];


% Plotting Correlation matrix from RIdent data
Labels=cellstr(inputs.model.par_names);
HeatMap(results.rid.mc_corrmat(1:length(Labels(param_including_vector)),1:length(Labels(param_including_vector))),'RowLabels',Labels(param_including_vector),'ColumnLabels',Labels(param_including_vector))

% Visualizing Confidence Interval for each parameter
x = 1:length(Labels(param_including_vector));                                       % Create Data
y = inputs.model.par(param_including_vector);                            % Create Data
ub = y + (results.rid.confidence_interval./(inputs.model.par(param_including_vector)))*100;                       % Create Data: Upper Bound
lb = y - (results.rid.confidence_interval./(inputs.model.par(param_including_vector)))*100;                       % Create Data: Lower Bound
figure(1)
errorbar(x, y, lb, ub, 'pg')
%axis([0  11    ylim])
xticklabels(Labels(param_including_vector))


% Visualizing Confidence Interval for each parameter
x = 1:length(Labels(param_including_vector));                                       % Create Data
y = inputs.model.par(param_including_vector);                            % Create Data
ub = y + results.rid.confidence_interval;                       % Create Data: Upper Bound
lb = y - results.rid.confidence_interval;                       % Create Data: Lower Bound
figure(2)
errorbar(x, y, lb, ub, 'pg')
%axis([0  11    ylim])