% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);

x = 1:14;
scatter(x,0.*e01);
hold on;
err = e04;
errorbar(x, 0.*e01, err, 'LineStyle','none');


set(axes1,'XGrid','on','XTick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14],...
    'XTickLabel',...
    {'\theta_{IPTG}','k_{IPTG}','k_{aTc}','\eta_{IPTG}','k^{P_{m0}}_L','\eta_{aTc}','\eta_{L}','k^{P_{m0}}_T ','\theta_{aTc} ','\eta_T','k^{p_m}_T ','sc_{Tmolec} ','sc_{Lmolec} ','k^{P_m}_L '});
