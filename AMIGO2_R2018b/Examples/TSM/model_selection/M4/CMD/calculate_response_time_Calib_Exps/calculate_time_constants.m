% calculate rise times for both LacI and TetR using StepInfo, where the function 
% takes step response data (T,Y) and a
% steady-state value YFINAL and returns a structure S containing 
% the following performance indicators:


% load('calibration_exps_lugagne.mat')

%% Rise Time

rise_time_LacI=[];
rise_time_TetR=[];

figure(1)

for i=[1:5 11:15]
    
    T1=stepinfo((results.sim.states{1,i}(:,3)),results.sim.tsim{1,i},'RiseTimeLimits',[0.1 0.9]);
    rise_time_LacI=[rise_time_LacI;T1.RiseTime];
    
     
    subplot(2,2,1)
    scatter(i,T1.RiseTime,'red'); hold on;
    xlabel('experiment ID')
    ylabel('Time(minutes)')
   
    T2=stepinfo((results.sim.states{1,i}(:,4)),results.sim.tsim{1,i},'RiseTimeLimits',[0.1 0.9]);
    rise_time_TetR=[rise_time_TetR;T2.RiseTime];
 
    subplot(2,2,2)
    scatter(i,T2.RiseTime,'green'); hold on;
    xlabel('experiment ID')
    ylabel('Time(minutes)')
    
        
end

%% Settling Times


settling_time_LacI=[];
settling_time_TetR=[];

for i=[6:10 16:20]
    
    T1=stepinfo((results.sim.states{1,i}(:,3)),results.sim.tsim{1,i},'SettlingTimeThreshold',0.1);
    settling_time_LacI=[settling_time_LacI;T1.SettlingTime];
    
     
    subplot(2,2,3)
    scatter(i,T1.SettlingTime,'red'); hold on;
    xlabel('experiment ID')
    ylabel('Time(minutes)')
   
    T2=stepinfo((results.sim.states{1,i}(:,4)),results.sim.tsim{1,i},'SettlingTimeThreshold',0.1);
    settling_time_TetR=[settling_time_TetR;T2.SettlingTime]; %#ok<*AGROW>
 
    subplot(2,2,4)
    scatter(i,T2.SettlingTime,'green'); hold on;
    xlabel('experiment ID')
    ylabel('Time(minutes)')
    
        
end


%% 
TimeConstantData=[rise_time_LacI rise_time_TetR settling_time_LacI settling_time_TetR]; 