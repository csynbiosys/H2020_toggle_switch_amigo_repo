#include <amigoRHS.h>

#include <math.h>

#include <amigoJAC.h>

#include <amigoSensRHS.h>

#include <amigo_terminate.h>


	/* *** Definition of the states *** */

#define	IPTG      Ith(y,0)
#define	aTc       Ith(y,1)
#define	mrna_LacI Ith(y,2)
#define	mrna_TetR Ith(y,3)
#define	LacI      Ith(y,4)
#define	TetR      Ith(y,5)
#define iexp amigo_model->exp_num

	/* *** Definition of the sates derivative *** */

#define	dIPTG      Ith(ydot,0)
#define	daTc       Ith(ydot,1)
#define	dmrna_LacI Ith(ydot,2)
#define	dmrna_TetR Ith(ydot,3)
#define	dLacI      Ith(ydot,4)
#define	dTetR      Ith(ydot,5)

	/* *** Definition of the parameters *** */

#define	k_m0L      (*amigo_model).pars[0]
#define	k_m0T      (*amigo_model).pars[1]
#define	k_mL       (*amigo_model).pars[2]
#define	k_mT       (*amigo_model).pars[3]
#define	k_pL       (*amigo_model).pars[4]
#define	k_pT       (*amigo_model).pars[5]
#define	g_mL       (*amigo_model).pars[6]
#define	g_mT       (*amigo_model).pars[7]
#define	g_pL       (*amigo_model).pars[8]
#define	g_pT       (*amigo_model).pars[9]
#define	theta_LacI (*amigo_model).pars[10]
#define	N_LacI     (*amigo_model).pars[11]
#define	theta_IPTG (*amigo_model).pars[12]
#define	N_IPTG     (*amigo_model).pars[13]
#define	theta_TetR (*amigo_model).pars[14]
#define	N_TetR     (*amigo_model).pars[15]
#define	theta_aTc  (*amigo_model).pars[16]
#define	N_aTc      (*amigo_model).pars[17]
#define	K_in_IPTG  (*amigo_model).pars[18]
#define	K_out_IPTG (*amigo_model).pars[19]
#define	K_in_aTc   (*amigo_model).pars[20]
#define	K_out_aTc  (*amigo_model).pars[21]
#define IPTGext	((*amigo_model).controls_v[0][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[0][(*amigo_model).index_t_stim])
#define aTcext 	((*amigo_model).controls_v[1][(*amigo_model).index_t_stim]+(t-(*amigo_model).tlast)*(*amigo_model).slope[1][(*amigo_model).index_t_stim])

	/* *** Definition of the algebraic variables *** */

/* Right hand side of the system (f(t,x,p))*/
int amigoRHS(realtype t, N_Vector y, N_Vector ydot, void *data){
	AMIGO_model* amigo_model=(AMIGO_model*)data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	/* *** Equations *** */

	dIPTG=(K_in_IPTG*(IPTGext-IPTG)+pow(pow(K_in_IPTG*(IPTGext-IPTG),2),0.5))/2-(K_out_IPTG*(IPTG-IPTGext)+pow(pow(K_out_IPTG*(IPTG-IPTGext),2),0.5))/2;
	daTc=(K_in_aTc*(aTcext-aTc)+pow(pow(K_in_aTc*(aTcext-aTc),2),0.5))/2-(K_out_aTc*(aTc-aTcext)+pow(pow(K_out_aTc*(aTc-aTcext),2),0.5))/2;
	dmrna_LacI=(k_m0L+k_mL/(1+pow(TetR/theta_TetR*1/(1+pow(aTc/theta_aTc,N_aTc)),N_TetR))-g_mL*mrna_LacI);
	dmrna_TetR=(k_m0T+k_mT/(1+pow(LacI/theta_LacI*1/(1+pow(IPTG/theta_IPTG,N_IPTG)),N_LacI))-g_mT*mrna_TetR);
	dLacI=(k_pL*mrna_LacI-g_pL*LacI);
	dTetR=(k_pT*mrna_TetR-g_pT*TetR);

	return(0);

}


/* Jacobian of the system (dfdx)*/
int amigoJAC(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat J, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3){
	AMIGO_model* amigo_model=(AMIGO_model*)user_data;
	ctrlcCheckPoint(__FILE__, __LINE__);


	return(0);
}

/* R.H.S of the sensitivity dsi/dt = (df/dx)*si + df/dp_i */
int amigoSensRHS(int Ns, realtype t, N_Vector y, N_Vector ydot, int iS, N_Vector yS, N_Vector ySdot, void *data, N_Vector tmp1, N_Vector tmp2){
	AMIGO_model* amigo_model=(AMIGO_model*)data;

	return(0);

}