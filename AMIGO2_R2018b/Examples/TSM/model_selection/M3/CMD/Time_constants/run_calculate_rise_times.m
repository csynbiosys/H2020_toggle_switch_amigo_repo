%% Initial state values
 
L_molec = 10 ;
T_molec = 8;
T_AU = 700;
L_AU = 600;
IPTGi = 0.1;
aTci = 20;

InitVals=[L_molec,T_molec,T_AU,L_AU,IPTGi,aTci];


%Parameter values for the model
parameters=[0.1386,5.0000025,500.0005,40,0.213428215,3,3,0.01650,15.000005,500.0005,0.0222,0.00505,3,3,505,505,0.0505,0.0505];




%% Calculate Rise time

RT_both_increasing=[]; Inputs1=[];

for u_IPTG= [1e-5 0.2 0.4 0.6 0.8 0.99]
    
    for u_aTc=100.*[1e-5 0.2 0.4 0.6 0.8 0.99]
    
    [rise_times] = CalculateRiseTime(log([u_aTc; u_IPTG]),InitVals,parameters);
    
    RT_both_increasing=[RT_both_increasing;rise_times]; %#ok<*AGROW>
    Inputs1=[Inputs1;log([u_aTc; u_IPTG])'];
    end
end


RT_one_increasing=[]; Inputs2=[];

for u_IPTG=[1e-5 0.2 0.4 0.6 0.8 0.99]
    
    for u_aTc=100.*[0.99 0.8 0.6 0.4 0.2 1e-5]
    
    [rise_times] = CalculateRiseTime(log([u_aTc; u_IPTG]),InitVals,parameters);
    
    RT_one_increasing=[RT_one_increasing;rise_times];
    Inputs2=[Inputs2;log([u_aTc; u_IPTG])'];

    end
end
