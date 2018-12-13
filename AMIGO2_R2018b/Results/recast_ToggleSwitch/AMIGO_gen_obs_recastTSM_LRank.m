function ms=AMIGO_gen_obs_recastTSM_LRank(y,inputs,par,iexp)
	IPTG     =y(:,1);
	aTc      =y(:,2);
	mrna_LacI=y(:,3);
	mrna_TetR=y(:,4);
	LacI     =y(:,5);
	TetR     =y(:,6);
	k_m0L     =par(1);
	k_m0T     =par(2);
	k_mL      =par(3);
	k_mT      =par(4);
	k_pL      =par(5);
	k_pT      =par(6);
	g_mL      =par(7);
	g_mT      =par(8);
	g_pL      =par(9);
	g_pT      =par(10);
	theta_LacI=par(11);
	N_LacI    =par(12);
	theta_IPTG=par(13);
	N_IPTG    =par(14);
	theta_TetR=par(15);
	N_TetR    =par(16);
	theta_aTc =par(17);
	N_aTc     =par(18);
	K_in_IPTG =par(19);
	K_out_IPTG=par(20);
	K_in_aTc  =par(21);
	K_out_aTc =par(22);
 

switch iexp

case 1
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 2
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 3
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 4
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 5
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 6
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 7
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 8
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 9
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 10
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 11
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 12
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 13
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 14
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 15
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 16
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 17
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 18
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 19
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 20
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 21
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 22
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;

case 23
LacI_M2 = LacI;
TetR_M2 = TetR;
ms(:,1)=LacI_M2;ms(:,2)=TetR_M2;
end

return