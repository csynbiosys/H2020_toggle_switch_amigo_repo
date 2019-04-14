% This script allows you to examine the estimated parameter values from
% Different inputs applied

cd M:\Cwd_4Feb2019\AMIGO2R2016b\Examples\TSM\model_calibration\M1\CIC\ 

input_type=char('Step','Pulse','Random');

for i=1:3
    
    folder_name=strcat('CIC_',input_type(i,:));
    cd(folder_name)    
    
    best_theta=[];
    
    for j=1:100
        
        load(strcat('cic-',input_type(i,:),'-',num2str(j)));            
        best_theta=[best_theta; best_global_theta_log{1, 10}'];  %#ok<*AGROW>
                
    end
    
    best_parameters{1,i}.input_type=input_type(i,:); %#ok<*SAGROW>
    best_parameters{1,i}.all_trials=best_theta;
    best_parameters{1,i}.par_names=inputs.PEsol.id_global_theta;
    best_parameters{1,i}.true_theta=true_param_values;
    best_parameters{1,i}.par_rel_error=abs(log2(best_parameters{1,i}.all_trials./best_parameters{1,i}.true_theta));
    best_parameters{1,i}.total_rel_error_IP=sum(sum(best_parameters{1,i}.par_rel_error))/(length(best_parameters{1,i}.true_theta)*length(best_parameters{1,i}.all_trials));
    
    cd ..

end

cd M:\Cwd_4Feb2019\AMIGO2R2016b\Examples\TSM\PlotFigures\Visualizing_Input_comparison

save ('NonOptimal_InputComparison_Data_M1.mat')


%% Scatter plot showing the distribution of estimated parameter values

for i=1:14 
    set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
    subplot(3,5,i)
    scatter(1:100,best_parameters{1, 1}.all_trials(:,i)); hold on;
    xlabel('Number of Trials')
    ylabel('Estimated Parameter Values')
    title(best_parameters{1,1}.par_names(i,:))
end


%% BarPlot showing average relative error across different inputs.

for i=1:3
    figure(1)
    subplot(3,1,i)
    boxplot(best_parameters{1,i}.par_rel_error,'labels',cellstr(best_parameters{1,1}.par_names));
    hold on;
    title(input_type(i,:))
end

figure(2)
bar(1,best_parameters{1,1}.total_rel_error_IP);
hold on; bar(2,best_parameters{1,2}.total_rel_error_IP);
hold on; bar(3,best_parameters{1,3}.total_rel_error_IP);

ylabel('$\bar{\epsilon}$(-)','Interpreter','Latex')


    