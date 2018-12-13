      SUBROUTINE  RMNHB(B, D, FX, G, H, IV, LH, LIV, LV, N, V, X)
C
C  ***  CARRY OUT   MNHB (SIMPLY BOUNDED MINIMIZATION) ITERATIONS,
C  ***  USING HESSIAN MATRIX PROVIDED BY THE CALLER.
C
C  ***  PARAMETER DECLARATIONS  ***
C
      INTEGER LH, LIV, LV, N
      INTEGER IV(LIV)
      REAL B(2,N), D(N), FX, G(N), H(LH), V(LV), X(N)
C
C--------------------------  PARAMETER USAGE  --------------------------
C
C D.... SCALE VECTOR.
C FX... FUNCTION VALUE.
C G.... GRADIENT VECTOR.
C H.... LOWER TRIANGLE OF THE HESSIAN, STORED ROWWISE.
C IV... INTEGER VALUE ARRAY.
C LH... LENGTH OF H = P*(P+1)/2.
C LIV.. LENGTH OF IV (AT LEAST 59 + 3*N).
C LV... LENGTH OF V (AT LEAST 78 + N*(N+27)/2).
C N.... NUMBER OF VARIABLES (COMPONENTS IN X AND G).
C V.... FLOATING-POINT VALUE ARRAY.
C X.... PARAMETER VECTOR.
C
C  ***  DISCUSSION  ***
C
C        PARAMETERS IV, N, V, AND X ARE THE SAME AS THE CORRESPONDING
C     ONES TO   MNHB (WHICH SEE), EXCEPT THAT V CAN BE SHORTER (SINCE
C     THE PART OF V THAT   MNHB USES FOR STORING G AND H IS NOT NEEDED).
C     MOREOVER, COMPARED WITH   MNHB, IV(1) MAY HAVE THE TWO ADDITIONAL
C     OUTPUT VALUES 1 AND 2, WHICH ARE EXPLAINED BELOW, AS IS THE USE
C     OF IV(TOOBIG) AND IV(NFGCAL).  THE VALUE IV(G), WHICH IS AN
C     OUTPUT VALUE FROM   MNHB, IS NOT REFERENCED BY  RMNHB OR THE
C     SUBROUTINES IT CALLS.
C
C IV(1) = 1 MEANS THE CALLER SHOULD SET FX TO F(X), THE FUNCTION VALUE
C             AT X, AND CALL  RMNHB AGAIN, HAVING CHANGED NONE OF THE
C             OTHER PARAMETERS.  AN EXCEPTION OCCURS IF F(X) CANNOT BE
C             COMPUTED (E.G. IF OVERFLOW WOULD OCCUR), WHICH MAY HAPPEN
C             BECAUSE OF AN OVERSIZED STEP.  IN THIS CASE THE CALLER
C             SHOULD SET IV(TOOBIG) = IV(2) TO 1, WHICH WILL CAUSE
C              RMNHB TO IGNORE FX AND TRY A SMALLER STEP.  THE PARA-
C             METER NF THAT   MNH PASSES TO CALCF (FOR POSSIBLE USE BY
C             CALCGH) IS A COPY OF IV(NFCALL) = IV(6).
C IV(1) = 2 MEANS THE CALLER SHOULD SET G TO G(X), THE GRADIENT OF F AT
C             X, AND H TO THE LOWER TRIANGLE OF H(X), THE HESSIAN OF F
C             AT X, AND CALL  RMNHB AGAIN, HAVING CHANGED NONE OF THE
C             OTHER PARAMETERS EXCEPT PERHAPS THE SCALE VECTOR D.
C                  THE PARAMETER NF THAT   MNHB PASSES TO CALCG IS
C             IV(NFGCAL) = IV(7).  IF G(X) AND H(X) CANNOT BE EVALUATED,
C             THEN THE CALLER MAY SET IV(NFGCAL) TO 0, IN WHICH CASE
C              RMNHB WILL RETURN WITH IV(1) = 65.
C                  NOTE --  RMNHB OVERWRITES H WITH THE LOWER TRIANGLE
C             OF  DIAG(D)**-1 * H(X) * DIAG(D)**-1.
C.
C  ***  GENERAL  ***
C
C     CODED BY DAVID M. GAY (WINTER, SPRING 1983).
C
C        (SEE   MNG AND   MNH FOR REFERENCES.)
C
C+++++++++++++++++++++++++++  DECLARATIONS  ++++++++++++++++++++++++++++
C
C  ***  LOCAL VARIABLES  ***
C
      INTEGER DG1, DUMMY, I, IPI, IPIV2, IPN, J, K, L, LSTGST, NN1O2,
     1        RSTRST, STEP0, STEP1, TD1, TEMP0, TEMP1, TG1, W1, X01, X11
      REAL GI, T, XI
C
C     ***  CONSTANTS  ***
C
      REAL NEGONE, ONE, ONEP2, ZERO
C
C  ***  NO INTRINSIC FUNCTIONS  ***
C
C  ***  EXTERNAL FUNCTIONS AND SUBROUTINES  ***
C
      LOGICAL STOPX
      REAL  D7TPR,  RLDST,  V2NRM
      EXTERNAL A7SST, IVSET,  D7TPR, D7DUP,  G7QSB, I7PNVR, ITSUM,
     1         PARCK,  RLDST,  S7IPR,  S7LVM, STOPX,  V2NRM, V2AXY,
     2         V7CPY,  V7IPR,  V7SCP,  V7VMP
C
C A7SST.... ASSESSES CANDIDATE STEP.
C IVSET.... PROVIDES DEFAULT IV AND V INPUT VALUES.
C  D7TPR... RETURNS INNER PRODUCT OF TWO VECTORS.
C D7DUP.... UPDATES SCALE VECTOR D.
C  G7QSB... COMPUTES APPROXIMATE OPTIMAL BOUNDED STEP.
C I7PNVR... INVERTS PERMUTATION ARRAY.
C ITSUM.... PRINTS ITERATION SUMMARY AND INFO ON INITIAL AND FINAL X.
C PARCK.... CHECKS VALIDITY OF INPUT IV AND V VALUES.
C  RLDST... COMPUTES V(RELDX) = RELATIVE STEP SIZE.
C  S7IPR... APPLIES PERMUTATION TO LOWER TRIANG. OF SYM. MATRIX.
C  S7LVM... MULTIPLIES SYMMETRIC MATRIX TIMES VECTOR, GIVEN THE LOWER
C             TRIANGLE OF THE MATRIX.
C STOPX.... RETURNS .TRUE. IF THE BREAK KEY HAS BEEN PRESSED.
C  V2NRM... RETURNS THE 2-NORM OF A VECTOR.
C V2AXY.... COMPUTES SCALAR TIMES ONE VECTOR PLUS ANOTHER.
C V7CPY.... COPIES ONE VECTOR TO ANOTHER.
C  V7IPR... APPLIES PERMUTATION TO VECTOR.
C  V7SCP... SETS ALL ELEMENTS OF A VECTOR TO A SCALAR.
C  V7VMP... MULTIPLIES (OR DIVIDES) TWO VECTORS COMPONENTWISE.
C
C  ***  SUBSCRIPTS FOR IV AND V  ***
C
      INTEGER CNVCOD, DG, DGNORM, DINIT, DSTNRM, DTINIT, DTOL, DTYPE,
     1        D0INIT, F, F0, FDIF, GTSTEP, INCFAC, IVNEED, IRC, KAGQT,
     2        LMAT, LMAX0, LMAXS, MODE, MODEL, MXFCAL, MXITER, N0, NC,
     3        NEXTIV, NEXTV, NFCALL, NFGCAL, NGCALL, NITER, PERM,
     4        PHMXFC, PREDUC, RADFAC, RADINC, RADIUS, RAD0, RELDX,
     5        RESTOR, STEP, STGLIM, STPPAR, TOOBIG, TUNER4, TUNER5,
     6        VNEED, W, XIRC, X0
C
C  ***  IV SUBSCRIPT VALUES  ***
C
C  ***  (NOTE THAT NC AND N0 ARE STORED IN IV(G0) AND IV(STLSTG) RESP.)
C
C/6
C     DATA CNVCOD/55/, DG/37/, DTOL/59/, DTYPE/16/, IRC/29/, IVNEED/3/,
C    1     KAGQT/33/, LMAT/42/, MODE/35/, MODEL/5/, MXFCAL/17/,
C    2     MXITER/18/, N0/41/, NC/48/, NEXTIV/46/, NEXTV/47/, NFCALL/6/,
C    3     NFGCAL/7/, NGCALL/30/, NITER/31/, PERM/58/, RADINC/8/,
C    4     RESTOR/9/, STEP/40/, STGLIM/11/, TOOBIG/2/, VNEED/4/, W/34/,
C    5     XIRC/13/, X0/43/
C/7
      PARAMETER (CNVCOD=55, DG=37, DTOL=59, DTYPE=16, IRC=29, IVNEED=3,
     1           KAGQT=33, LMAT=42, MODE=35, MODEL=5, MXFCAL=17,
     2           MXITER=18, N0=41, NC=48, NEXTIV=46, NEXTV=47, NFCALL=6,
     3           NFGCAL=7, NGCALL=30, NITER=31, PERM=58, RADINC=8,
     4           RESTOR=9, STEP=40, STGLIM=11, TOOBIG=2, VNEED=4, W=34,
     5           XIRC=13, X0=43)
C/
C
C  ***  V SUBSCRIPT VALUES  ***
C
C/6
C     DATA DGNORM/1/, DINIT/38/, DSTNRM/2/, DTINIT/39/, D0INIT/40/,
C    1     F/10/, F0/13/, FDIF/11/, GTSTEP/4/, INCFAC/23/, LMAX0/35/,
C    2     LMAXS/36/, PHMXFC/21/, PREDUC/7/, RADFAC/16/, RADIUS/8/,
C    3     RAD0/9/, RELDX/17/, STPPAR/5/, TUNER4/29/, TUNER5/30/
C/7
      PARAMETER (DGNORM=1, DINIT=38, DSTNRM=2, DTINIT=39, D0INIT=40,
     1           F=10, F0=13, FDIF=11, GTSTEP=4, INCFAC=23, LMAX0=35,
     2           LMAXS=36, PHMXFC=21, PREDUC=7, RADFAC=16, RADIUS=8,
     3           RAD0=9, RELDX=17, STPPAR=5, TUNER4=29, TUNER5=30)
C/
C
C/6
C     DATA NEGONE/-1.E+0/, ONE/1.E+0/, ONEP2/1.2E+0/, ZERO/0.E+0/
C/7
      PARAMETER (NEGONE=-1.E+0, ONE=1.E+0, ONEP2=1.2E+0, ZERO=0.E+0)
C/
C
C+++++++++++++++++++++++++++++++  BODY  ++++++++++++++++++++++++++++++++
C
      I = IV(1)
      IF (I .EQ. 1) GO TO 50
      IF (I .EQ. 2) GO TO 60
C
C  ***  CHECK VALIDITY OF IV AND V INPUT VALUES  ***
C
      IF (IV(1) .EQ. 0) CALL IVSET(2, IV, LIV, LV, V)
      IF (IV(1) .LT. 12) GO TO 10
      IF (IV(1) .GT. 13) GO TO 10
         IV(VNEED) = IV(VNEED) + N*(N+27)/2 + 7
         IV(IVNEED) = IV(IVNEED) + 3*N
 10   CALL PARCK(2, D, IV, LIV, LV, N, V)
      I = IV(1) - 2
      IF (I .GT. 12) GO TO 999
      NN1O2 = N * (N + 1) / 2
      IF (LH .GE. NN1O2) GO TO (250,250,250,250,250,250,190,150,190,
     1                          20,20,30), I
         IV(1) = 81
         GO TO 440
C
C  ***  STORAGE ALLOCATION  ***
C
 20   IV(DTOL) = IV(LMAT) + NN1O2
      IV(X0) = IV(DTOL) + 2*N
      IV(STEP) = IV(X0) + 2*N
      IV(DG) = IV(STEP) + 3*N
      IV(W) = IV(DG) + 2*N
      IV(NEXTV) = IV(W) + 4*N + 7
      IV(NEXTIV) = IV(PERM) + 3*N
      IF (IV(1) .NE. 13) GO TO 30
         IV(1) = 14
         GO TO 999
C
C  ***  INITIALIZATION  ***
C
 30   IV(NITER) = 0
      IV(NFCALL) = 1
      IV(NGCALL) = 1
      IV(NFGCAL) = 1
      IV(MODE) = -1
      IV(MODEL) = 1
      IV(STGLIM) = 1
      IV(TOOBIG) = 0
      IV(CNVCOD) = 0
      IV(RADINC) = 0
      IV(NC) = N
      V(RAD0) = ZERO
      V(STPPAR) = ZERO
      IF (V(DINIT) .GE. ZERO) CALL  V7SCP(N, D, V(DINIT))
      K = IV(DTOL)
      IF (V(DTINIT) .GT. ZERO) CALL  V7SCP(N, V(K), V(DTINIT))
      K = K + N
      IF (V(D0INIT) .GT. ZERO) CALL  V7SCP(N, V(K), V(D0INIT))
C
C  ***  CHECK CONSISTENCY OF B AND INITIALIZE IP ARRAY  ***
C
      IPI = IV(PERM)
      DO 40 I = 1, N
         IV(IPI) = I
         IPI = IPI + 1
         IF (B(1,I) .GT. B(2,I)) GO TO 420
 40      CONTINUE
C
C  ***  GET INITIAL FUNCTION VALUE  ***
C
      IV(1) = 1
      GO TO 450
C
 50   V(F) = FX
      IF (IV(MODE) .GE. 0) GO TO 250
      V(F0) = FX
      IV(1) = 2
      IF (IV(TOOBIG) .EQ. 0) GO TO 999
         IV(1) = 63
         GO TO 440
C
C  ***  MAKE SURE GRADIENT COULD BE COMPUTED  ***
C
 60   IF (IV(TOOBIG) .EQ. 0) GO TO 70
         IV(1) = 65
         GO TO 440
C
C  ***  UPDATE THE SCALE VECTOR D  ***
C
 70   DG1 = IV(DG)
      IF (IV(DTYPE) .LE. 0) GO TO 90
      K = DG1
      J = 0
      DO 80 I = 1, N
         J = J + I
         V(K) = H(J)
         K = K + 1
 80      CONTINUE
      CALL D7DUP(D, V(DG1), IV, LIV, LV, N, V)
C
C  ***  COMPUTE SCALED GRADIENT AND ITS NORM  ***
C
 90   DG1 = IV(DG)
      CALL  V7VMP(N, V(DG1), G, D, -1)
C
C  ***  COMPUTE SCALED HESSIAN  ***
C
      K = 1
      DO 110 I = 1, N
         T = ONE / D(I)
         DO 100 J = 1, I
              H(K) = T * H(K) / D(J)
              K = K + 1
 100          CONTINUE
 110     CONTINUE
C
C  ***  CHOOSE INITIAL PERMUTATION  ***
C
      IPI = IV(PERM)
      IPN = IPI + N
      IPIV2 = IPN - 1
C     *** INVERT OLD PERMUTATION ARRAY ***
      CALL I7PNVR(N, IV(IPN), IV(IPI))
      K = IV(NC)
      DO 130 I = 1, N
         IF (B(1,I) .GE. B(2,I)) GO TO 120
         XI = X(I)
         GI = G(I)
         IF (XI .LE. B(1,I) .AND. GI .GT. ZERO) GO TO 120
         IF (XI .GE. B(2,I) .AND. GI .LT. ZERO) GO TO 120
            IV(IPI) = I
            IPI = IPI + 1
            J = IPIV2 + I
C           *** DISALLOW CONVERGENCE IF X(I) HAS JUST BEEN FREED ***
            IF (IV(J) .GT. K) IV(CNVCOD) = 0
            GO TO 130
 120     IPN = IPN - 1
         IV(IPN) = I
 130     CONTINUE
      IV(NC) = IPN - IV(PERM)
C
C  ***  PERMUTE SCALED GRADIENT AND HESSIAN ACCORDINGLY  ***
C
      IPI = IV(PERM)
      CALL  S7IPR(N, IV(IPI), H)
      CALL  V7IPR(N, IV(IPI), V(DG1))
      V(DGNORM) = ZERO
      IF (IV(NC) .GT. 0) V(DGNORM) =  V2NRM(IV(NC), V(DG1))
C
      IF (IV(CNVCOD) .NE. 0) GO TO 430
      IF (IV(MODE) .EQ. 0) GO TO 380
C
C  ***  ALLOW FIRST STEP TO HAVE SCALED 2-NORM AT MOST V(LMAX0)  ***
C
      V(RADIUS) = V(LMAX0) / (ONE + V(PHMXFC))
C
      IV(MODE) = 0
C
C
C-----------------------------  MAIN LOOP  -----------------------------
C
C
C  ***  PRINT ITERATION SUMMARY, CHECK ITERATION LIMIT  ***
C
 140  CALL ITSUM(D, G, IV, LIV, LV, N, V, X)
 150  K = IV(NITER)
      IF (K .LT. IV(MXITER)) GO TO 160
         IV(1) = 10
         GO TO 440
C
 160  IV(NITER) = K + 1
C
C  ***  INITIALIZE FOR START OF NEXT ITERATION  ***
C
      X01 = IV(X0)
      V(F0) = V(F)
      IV(IRC) = 4
      IV(KAGQT) = -1
C
C     ***  COPY X TO X0  ***
C
      CALL V7CPY(N, V(X01), X)
C
C  ***  UPDATE RADIUS  ***
C
      IF (K .EQ. 0) GO TO 180
      STEP1 = IV(STEP)
      K = STEP1
      DO 170 I = 1, N
         V(K) = D(I) * V(K)
         K = K + 1
 170     CONTINUE
      T = V(RADFAC) *  V2NRM(N, V(STEP1))
      IF (V(RADFAC) .LT. ONE .OR. T .GT. V(RADIUS)) V(RADIUS) = T
C
C  ***  CHECK STOPX AND FUNCTION EVALUATION LIMIT  ***
C
 180  IF (.NOT. STOPX(DUMMY)) GO TO 200
         IV(1) = 11
         GO TO 210
C
C     ***  COME HERE WHEN RESTARTING AFTER FUNC. EVAL. LIMIT OR STOPX.
C
 190  IF (V(F) .GE. V(F0)) GO TO 200
         V(RADFAC) = ONE
         K = IV(NITER)
         GO TO 160
C
 200  IF (IV(NFCALL) .LT. IV(MXFCAL)) GO TO 220
         IV(1) = 9
 210     IF (V(F) .GE. V(F0)) GO TO 440
C
C        ***  IN CASE OF STOPX OR FUNCTION EVALUATION LIMIT WITH
C        ***  IMPROVED V(F), EVALUATE THE GRADIENT AT X.
C
              IV(CNVCOD) = IV(1)
              GO TO 370
C
C. . . . . . . . . . . . .  COMPUTE CANDIDATE STEP  . . . . . . . . . .
C
 220  STEP1 = IV(STEP)
      L = IV(LMAT)
      W1 = IV(W)
      IPI = IV(PERM)
      IPN = IPI + N
      IPIV2 = IPN + N
      TG1 = IV(DG)
      TD1 = TG1 + N
      X01 = IV(X0)
      X11 = X01 + N
      CALL  G7QSB(B, D, H, G, IV(IPI), IV(IPN), IV(IPIV2), IV(KAGQT),
     1            V(L), LV, N, IV(N0), IV(NC), V(STEP1), V(TD1), V(TG1),
     2            V, V(W1), V(X11), V(X01))
      IF (IV(IRC) .NE. 6) GO TO 230
         IF (IV(RESTOR) .NE. 2) GO TO 250
         RSTRST = 2
         GO TO 260
C
C  ***  CHECK WHETHER EVALUATING F(X0 + STEP) LOOKS WORTHWHILE  ***
C
 230  IV(TOOBIG) = 0
      IF (V(DSTNRM) .LE. ZERO) GO TO 250
      IF (IV(IRC) .NE. 5) GO TO 240
      IF (V(RADFAC) .LE. ONE) GO TO 240
      IF (V(PREDUC) .GT. ONEP2 * V(FDIF)) GO TO 240
         IF (IV(RESTOR) .NE. 2) GO TO 250
         RSTRST = 0
         GO TO 260
C
C  ***  COMPUTE F(X0 + STEP)  ***
C
 240  CALL V2AXY(N, X, ONE, V(STEP1), V(X01))
      IV(NFCALL) = IV(NFCALL) + 1
      IV(1) = 1
      GO TO 450
C
C. . . . . . . . . . . . .  ASSESS CANDIDATE STEP  . . . . . . . . . . .
C
 250  RSTRST = 3
 260  X01 = IV(X0)
      V(RELDX) =  RLDST(N, D, X, V(X01))
      CALL A7SST(IV, LIV, LV, V)
      STEP1 = IV(STEP)
      LSTGST = STEP1 + 2*N
      I = IV(RESTOR) + 1
      GO TO (300, 270, 280, 290), I
 270  CALL V7CPY(N, X, V(X01))
      GO TO 300
 280   CALL V7CPY(N, V(LSTGST), X)
       GO TO 300
 290     CALL V7CPY(N, X, V(LSTGST))
         CALL V2AXY(N, V(STEP1), NEGONE, V(X01), X)
         V(RELDX) =  RLDST(N, D, X, V(X01))
         IV(RESTOR) = RSTRST
C
 300  K = IV(IRC)
      GO TO (310,340,340,340,310,320,330,330,330,330,330,330,410,380), K
C
C     ***  RECOMPUTE STEP WITH NEW RADIUS  ***
C
 310     V(RADIUS) = V(RADFAC) * V(DSTNRM)
         GO TO 180
C
C  ***  COMPUTE STEP OF LENGTH V(LMAXS) FOR SINGULAR CONVERGENCE TEST.
C
 320  V(RADIUS) = V(LMAXS)
      GO TO 220
C
C  ***  CONVERGENCE OR FALSE CONVERGENCE  ***
C
 330  IV(CNVCOD) = K - 4
      IF (V(F) .GE. V(F0)) GO TO 430
         IF (IV(XIRC) .EQ. 14) GO TO 430
              IV(XIRC) = 14
C
C. . . . . . . . . . . .  PROCESS ACCEPTABLE STEP  . . . . . . . . . . .
C
 340  IF (IV(IRC) .NE. 3) GO TO 370
         TEMP1 = LSTGST
C
C     ***  PREPARE FOR GRADIENT TESTS  ***
C     ***  SET  TEMP1 = HESSIAN * STEP + G(X0)
C     ***             = DIAG(D) * (H * STEP + G(X0))
C
         K = TEMP1
         STEP0 = STEP1 - 1
         IPI = IV(PERM)
         DO 350 I = 1, N
              J = IV(IPI)
              IPI = IPI + 1
              STEP1 = STEP0 + J
              V(K) = D(J) * V(STEP1)
              K = K + 1
 350          CONTINUE
C        USE X0 VECTOR AS TEMPORARY.
         CALL  S7LVM(N, V(X01), H, V(TEMP1))
         TEMP0 = TEMP1 - 1
         IPI = IV(PERM)
         DO 360 I = 1, N
              J = IV(IPI)
              IPI = IPI + 1
              TEMP1 = TEMP0 + J
              V(TEMP1) = D(J) * V(X01) + G(J)
              X01 = X01 + 1
 360          CONTINUE
C
C  ***  COMPUTE GRADIENT AND HESSIAN  ***
C
 370  IV(NGCALL) = IV(NGCALL) + 1
      IV(TOOBIG) = 0
      IV(1) = 2
      GO TO 450
C
 380  IV(1) = 2
      IF (IV(IRC) .NE. 3) GO TO 140
C
C  ***  SET V(RADFAC) BY GRADIENT TESTS  ***
C
      STEP1 = IV(STEP)
C     *** TEMP1 = STLSTG ***
      TEMP1 = STEP1 + 2*N
C
C     ***  SET  TEMP1 = DIAG(D)**-1 * (HESSIAN*STEP + (G(X0)-G(X)))  ***
C
      K = TEMP1
      DO 390 I = 1, N
         V(K) = (V(K) - G(I)) / D(I)
         K = K + 1
 390     CONTINUE
C
C     ***  DO GRADIENT TESTS  ***
C
      IF ( V2NRM(N, V(TEMP1)) .LE. V(DGNORM) * V(TUNER4)) GO TO 400
           IF ( D7TPR(N, G, V(STEP1))
     1               .GE. V(GTSTEP) * V(TUNER5))  GO TO 140
 400            V(RADFAC) = V(INCFAC)
                GO TO 140
C
C. . . . . . . . . . . . . .  MISC. DETAILS  . . . . . . . . . . . . . .
C
C  ***  BAD PARAMETERS TO ASSESS  ***
C
 410  IV(1) = 64
      GO TO 440
C
C  ***  INCONSISTENT B  ***
C
 420  IV(1) = 82
      GO TO 440
C
C  ***  PRINT SUMMARY OF FINAL ITERATION AND OTHER REQUESTED ITEMS  ***
C
 430  IV(1) = IV(CNVCOD)
      IV(CNVCOD) = 0
 440  CALL ITSUM(D, G, IV, LIV, LV, N, V, X)
      GO TO 999
C
C  ***  PROJECT X INTO FEASIBLE REGION (PRIOR TO COMPUTING F OR G)  ***
C
 450  DO 460 I = 1, N
         IF (X(I) .LT. B(1,I)) X(I) = B(1,I)
         IF (X(I) .GT. B(2,I)) X(I) = B(2,I)
 460     CONTINUE
C
 999  RETURN
C
C  ***  LAST CARD OF  RMNHB FOLLOWS  ***
      END
