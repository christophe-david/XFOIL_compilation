
      SUBROUTINE FS(INORM,ISPEC,BSPEC,HSPEC,N,ETAE,GEO,ETA,F,U,S,DELTA)
      DIMENSION ETA(N), F(N), U(N), S(N)
C-----------------------------------------------------
C     Routine for solving the Falkner-Skan equation.
C
C     Input:
C     ------
C      INORM   1: eta = y / sqrt(vx/Ue)  "standard" Falkner-Skan coordinate
C              2: eta = y / sqrt(2vx/(m+1)Ue)  Hartree's coordinate
C              3: eta = y / Theta  momentum thickness normalized coordinate
C      ISPEC   1: BU  = x/Ue dUe/dx ( = "m")  specified
C              2: H12 = Dstar/Theta  specified
C      BSPEC   specified pressure gradient parameter  (if ISPEC = 1)
C      HSPEC   specified shape parameter of U profile (if ISPEC = 2)
C      N       total number of points in profiles
C      ETAE    edge value of normal coordinate
C      GEO     exponential stretching factor for ETA:
C                = (ETA(j+1)-ETA(j)) / (ETA(j)-ETA(j-1))
C
C     Output:
C     -------
C      BSPEC   calculated pressure gradient parameter  (if ISPEC = 2)
C      HSPEC   calculated shape parameter of U profile (if ISPEC = 1)
C      ETA     normal BL coordinate
C      F,U,S   Falkner Skan profiles
C      DELTA   normal coordinate scale for computing y values:
C                 y(j) = ETA(j) * DELTA
C-----------------------------------------------------
C
      PARAMETER (NMAX=2001,NRMAX=3)
      REAL A(3,3,NMAX),B(3,3,NMAX),C(3,3,NMAX), R(3,NRMAX,NMAX)
C
C---- set number of righthand sides.
      DATA NRHS / 3 /
C
C---- max number of Newton iterations
      ITMAX = 20
C
      IF(N.GT.NMAX) STOP 'FS: Array overflow.'
C
      PI = 4.0*ATAN(1.0)
C
CCCc---- skip initialization if initial-guess U(y) is passed in 
CCC      if(u(n) .ne. 0.0) go to 9991
CCC
C---- initialize H or BetaU with empirical curve fits
      IF(ISPEC.EQ.1) THEN
       H = 2.6
       BU = BSPEC
      ELSE
       H = HSPEC
       IF(H .LE. 14.07/6.54) STOP 'FS: Specified H too low'
       BU = (0.058*(H-4.0)**2/(H-1.0) - 0.068) / (6.54*H - 14.07) * H**2
       IF(H .GT. 4.0) BU = AMIN1( BU , 0.0 )
      ENDIF
C
C---- initialize TN = Delta^2 Ue / vx
      IF(INORM.EQ.3) THEN
       TN = (6.54*H - 14.07) / H**2
      ELSE
       TN = 1.0
      ENDIF
C
C---- set eta array
      DETA = 1.0
      ETA(1) = 0.0
      DO I=2, N
        ETA(I) = ETA(I-1) + DETA
        DETA = GEO*DETA
      ENDDO
C
      DO I=1, N
        ETA(I) = ETA(I) * ETAE/ETA(N)
      ENDDO
C
C
C---- initial guess for profiles using a sine loop for U for half near wall
      IF(H .LE. 3.0) THEN
C
       IF(INORM.EQ.3) THEN
        ETJOIN = 7.3
       ELSE
        ETJOIN = 5.0
       ENDIF
C
       EFAC = 0.5*PI/ETJOIN
       DO 10 I=1, N
         U(I) = SIN(EFAC*ETA(I))
         F(I) = 1.0/EFAC * (1.0 - COS(EFAC*ETA(I)))
         S(I) = EFAC*COS(EFAC*ETA(I))
         IF(ETA(I) .GT. ETJOIN) GO TO 11
  10   CONTINUE
  11   CONTINUE
       IJOIN = I
C
C----- constant U for outer half
       DO I=IJOIN+1, N
         U(I) = 1.0
         F(I) = F(IJOIN) + ETA(I) - ETA(IJOIN)
         S(I) = 0.
       ENDDO
C
      ELSE
C
       IF(INORM.EQ.3) THEN
        ETJOIN = 8.0
       ELSE
        ETJOIN = 8.0
       ENDIF
C
       EFAC = 0.5*PI/ETJOIN
       DO 15 I=1, N
         U(I) = 0.5 - 0.5*COS(2.0*EFAC*ETA(I))
         F(I) = 0.5*ETA(I) - 0.25/EFAC * SIN(2.0*EFAC*ETA(I))
         S(I) = EFAC*SIN(2.0*EFAC*ETA(I))
         IF(ETA(I) .GT. ETJOIN) GO TO 16
  15   CONTINUE
  16   CONTINUE
       IJOIN = I
C
C----- constant U for outer half
       DO I=IJOIN+1, N
         U(I) = 1.0
         F(I) = F(IJOIN) + ETA(I) - ETA(IJOIN)
         S(I) = 0.
       ENDDO
C
      ENDIF
c
 9991 continue
C
C
C---- Newton iteration loop
      DO 100 ITER=1, ITMAX
C
C------ zero out A,B,C blocks and righthand sides R
        DO I=1, N
          DO II=1,3
            DO III=1,3
              A(II,III,I) = 0.
              B(II,III,I) = 0.
              C(II,III,I) = 0.
            ENDDO
            R(II,1,I) = 0.
            R(II,2,I) = 0.
            R(II,3,I) = 0.
          ENDDO
        ENDDO
C
C...................................................
C
        A(1,1,1) = 1.0
        A(2,2,1) = 1.0
        A(3,2,N) = 1.0
        R(1,1,1) = F(1)
        R(2,1,1) = U(1)
        R(3,1,N) = U(N) - 1.0
C
        IF(INORM.EQ.2) THEN
         BETU    = 2.0*BU/(BU+1.0)
         BETU_BU = (2.0 - BETU/(BU+1.0))/(BU+1.0)
         BETN    = 1.0
         BETN_BU = 0.0
        ELSE
         BETU    = BU
         BETU_BU = 1.0
         BETN    = 0.5*(1.0 + BU)
         BETN_BU = 0.5
        ENDIF
C
        DO 30 I = 1, N-1
C
          DETA = ETA(I+1) - ETA(I)
          R(1,1,I+1) = F(I+1) - F(I) - 0.5*DETA*(U(I+1)+U(I))
          R(2,1,I+1) = U(I+1) - U(I) - 0.5*DETA*(S(I+1)+S(I))
          R(3,1,I)   = S(I+1) - S(I)
     &      + TN * (  BETN*DETA*0.5*(F(I+1)*S(I+1) + F(I)*S(I))
     &              + BETU*DETA*(1.0 - 0.5*(U(I+1)**2 + U(I)**2)) )
C
          A(3,1,I) =  TN * BETN*0.5*DETA*S(I)
          C(3,1,I) =  TN * BETN*0.5*DETA*S(I+1)
          A(3,2,I) = -TN * BETU    *DETA*U(I)
          C(3,2,I) = -TN * BETU    *DETA*U(I+1)
          A(3,3,I) =  TN * BETN*0.5*DETA*F(I)   - 1.0
          C(3,3,I) =  TN * BETN*0.5*DETA*F(I+1) + 1.0
C
          B(1,1,I+1) = -1.0
          A(1,1,I+1) =  1.0
          B(1,2,I+1) = -0.5*DETA
          A(1,2,I+1) = -0.5*DETA
C
          B(2,2,I+1) = -1.0
          A(2,2,I+1) =  1.0
          B(2,3,I+1) = -0.5*DETA
          A(2,3,I+1) = -0.5*DETA
C
          R(3,2,I) = TN 
     &          * ( BETN_BU*DETA*0.5*(F(I+1)*S(I+1) + F(I)*S(I))
     &            + BETU_BU*DETA*(1.0 - 0.5*(U(I+1)**2 + U(I)**2)))
          R(3,3,I) = ( BETN*DETA*0.5*(F(I+1)*S(I+1) + F(I)*S(I))
     &               + BETU*DETA*(1.0 - 0.5*(U(I+1)**2 + U(I)**2)) )
C
  30    CONTINUE
C
C------ shift momentum equations down for better matrix conditioning
        DO I = N, 2, -1
          R(3,1,I) = R(3,1,I) + R(3,1,I-1)
          R(3,2,I) = R(3,2,I) + R(3,2,I-1)
          R(3,3,I) = R(3,3,I) + R(3,3,I-1)
          DO L=1, 3
            A(3,L,I) = A(3,L,I) + C(3,L,I-1)
            B(3,L,I) = B(3,L,I) + A(3,L,I-1)
          ENDDO
        ENDDO
C...........................................................
C
C---- solve Newton system for the three solution vectors
      CALL B3SOLV(A,B,C,R,N,NRHS,NRMAX)
C
C---- calculate and linearize Dstar, Theta, in computational space
      DSI = 0.
      DSI1 = 0.
      DSI2 = 0.
      DSI3 = 0.
C
      THI = 0.
      THI1 = 0.
      THI2 = 0.
      THI3 = 0.
C
      DO 40 I = 1, N-1
        US  = U(I) + U(I+1)
        DETA = ETA(I+1) - ETA(I)
C
        DSI = DSI + (1.0 - 0.5*US)*DETA
        DSI_US = -0.5*DETA
C
        THI = THI + (1.0 - 0.5*US)*0.5*US*DETA
        THI_US = (0.5 - 0.5*US)*DETA
C
        DSI1 = DSI1 + DSI_US*(R(2,1,I) + R(2,1,I+1))
        DSI2 = DSI2 + DSI_US*(R(2,2,I) + R(2,2,I+1))
        DSI3 = DSI3 + DSI_US*(R(2,3,I) + R(2,3,I+1))
C
        THI1 = THI1 + THI_US*(R(2,1,I) + R(2,1,I+1))
        THI2 = THI2 + THI_US*(R(2,2,I) + R(2,2,I+1))
        THI3 = THI3 + THI_US*(R(2,3,I) + R(2,3,I+1))
  40  CONTINUE
C
C
      IF(ISPEC.EQ.1) THEN
C
C----- set and linearize  Bu = Bspec  residual
       R1 = BSPEC - BU
       Q11 = 1.0
       Q12 = 0.0
C
      ELSE
C
C----- set and linearize  H = Hspec  residual
       R1  =  DSI  - HSPEC*THI
     &       -DSI1 + HSPEC*THI1
       Q11 = -DSI2 + HSPEC*THI2
       Q12 = -DSI3 + HSPEC*THI3
C
      ENDIF
C
C
      IF(INORM.EQ.3) THEN
C
C----- set and linearize  normalized Theta = 1  residual
       R2  =  THI  - 1.0
     &       -THI1
       Q21 = -THI2
       Q22 = -THI3
C
      ELSE
C
C----- set eta scaling coefficient to unity
       R2  =  1.0 - TN
       Q21 = 0.0
       Q22 = 1.0
C
      ENDIF
C
C
      DET =   Q11*Q22 - Q12*Q21
      DBU = -(R1 *Q22 - Q12*R2 ) / DET
      DTN = -(Q11*R2  - R1 *Q21) / DET
C
C
C---- calculate changes in F,U,S, and the max and rms change
      RMAX = 0.
      RMS = 0.
      DO 50 I=1,N
        DF = -R(1,1,I) - DBU*R(1,2,I) - DTN*R(1,3,I)
        DU = -R(2,1,I) - DBU*R(2,2,I) - DTN*R(2,3,I)
        DS = -R(3,1,I) - DBU*R(3,2,I) - DTN*R(3,3,I)
C
        RMAX = MAX(RMAX,ABS(DF),ABS(DU),ABS(DS))
        RMS = DF**2 + DU**2 + DS**2  +  RMS
   50 CONTINUE
      RMS = SQRT(RMS/(3.0*FLOAT(N) + 3.0))
C
      RMAX = MAX(RMAX,ABS(DBU/0.5),ABS(DTN/TN))
C
C---- set underrelaxation factor if necessary by limiting max change to 0.5
      RLX = 1.0
      IF(RMAX.GT.0.5) RLX = 0.5/RMAX
C
C---- update F,U,S
      DO 60 I=1,N
        DF = -R(1,1,I) - DBU*R(1,2,I) - DTN*R(1,3,I)
        DU = -R(2,1,I) - DBU*R(2,2,I) - DTN*R(2,3,I)
        DS = -R(3,1,I) - DBU*R(3,2,I) - DTN*R(3,3,I)
C
        F(I) = F(I) + RLX*DF
        U(I) = U(I) + RLX*DU
        S(I) = S(I) + RLX*DS
   60 CONTINUE
C
C---- update BetaU and Theta
      BU = BU + RLX*DBU
      TN = TN + RLX*DTN
C    
      write(*,*) iter, rms, rlx

C---- check for convergence
      IF(ITER.GT.3 .AND. RMS.LT.1.E-5) GO TO 105
C
  100 CONTINUE
      WRITE(*,*) 'FS: Convergence failed'
C
  105 CONTINUE
C
      HSPEC = DSI/THI
      BSPEC = BU
C
      DELTA = SQRT(TN)
C
      RETURN
C
C     The
      END



      SUBROUTINE B3SOLV(A,B,C,R,N,NRHS,NRMAX)
      DIMENSION A(3,3,N), B(3,3,N), C(3,3,N), R(3,NRMAX,N)
C     **********************************************************************
C      This routine solves a 3x3 block-tridiagonal system with an arbitrary
C      number of righthand sides by a standard block elimination scheme.  
C      The solutions are returned in the Rj vectors.
C
C      |A C      ||d|   |R..|
C      |B A C    ||d|   |R..|
C      |  B . .  ||.| = |R..|
C      |    . . C||.|   |R..|
C      |      B A||d|   |R..|
C                                                  Mark Drela   10 March 86
C     **********************************************************************
C
CCC** Forward sweep: Elimination of lower block diagonal (B's).
      DO 1 I=1, N
C
        IM = I-1
C
C------ don't eliminate B1 block because it doesn't exist
        IF(I.EQ.1) GO TO 12
C
C------ eliminate Bi block, thus modifying Ai and Ci blocks
        DO 11 K=1, 3
          DO 111 L=1, 3
            A(K,L,I) = A(K,L,I)
     &               - (  B(K,1,I)*C(1,L,IM)
     &                  + B(K,2,I)*C(2,L,IM)
     &                  + B(K,3,I)*C(3,L,IM))
  111     CONTINUE
          DO 112 L=1, NRHS
            R(K,L,I) = R(K,L,I)
     &               - (  B(K,1,I)*R(1,L,IM)
     &                  + B(K,2,I)*R(2,L,IM)
     &                  + B(K,3,I)*R(3,L,IM))
  112     CONTINUE
   11   CONTINUE
C
C                                                              -1
CCC---- multiply Ci block and righthand side Ri vectors by (Ai)
C       using Gaussian elimination.
C
   12   DO 13 KPIV=1, 2
          KP1 = KPIV+1
C
C-------- find max pivot index KX
          KX = KPIV
          DO 131 K=KP1, 3
            IF(ABS(A(K,KPIV,I))-ABS(A(KX,KPIV,I))) 131,131,1311
 1311        KX = K
  131     CONTINUE
C
          IF(A(KX,KPIV,I).EQ.0.0) THEN
           WRITE(*,*) 'Singular A block, i = ',I
           STOP
          ENDIF
C
          PIVOT = 1.0/A(KX,KPIV,I)
C
C-------- switch pivots
          A(KX,KPIV,I) = A(KPIV,KPIV,I)
C
C-------- switch rows & normalize pivot row
          DO 132 L=KP1, 3
            TEMP = A(KX,L,I)*PIVOT
            A(KX,L,I) = A(KPIV,L,I)
            A(KPIV,L,I) = TEMP
  132     CONTINUE
C
          DO 133 L=1, 3
            TEMP = C(KX,L,I)*PIVOT
            C(KX,L,I) = C(KPIV,L,I)
            C(KPIV,L,I) = TEMP
  133     CONTINUE
C
          DO 134 L=1, NRHS
            TEMP = R(KX,L,I)*PIVOT
            R(KX,L,I) = R(KPIV,L,I)
            R(KPIV,L,I) = TEMP
  134     CONTINUE
CB
C-------- forward eliminate everything
          DO 135 K=KP1, 3
            DO 1351 L=KP1, 3
              A(K,L,I) = A(K,L,I) - A(K,KPIV,I)*A(KPIV,L,I)
 1351       CONTINUE
            C(K,1,I) = C(K,1,I) - A(K,KPIV,I)*C(KPIV,1,I)
            C(K,2,I) = C(K,2,I) - A(K,KPIV,I)*C(KPIV,2,I)
            C(K,3,I) = C(K,3,I) - A(K,KPIV,I)*C(KPIV,3,I)
            DO 1352 L=1, NRHS
              R(K,L,I) = R(K,L,I) - A(K,KPIV,I)*R(KPIV,L,I)
 1352       CONTINUE
  135     CONTINUE
C
   13   CONTINUE
C
C------ solve for last row
        IF(A(3,3,I).EQ.0.0) THEN
         WRITE(*,*) 'Singular A block, i = ',I
         STOP
        ENDIF
        PIVOT = 1.0/A(3,3,I)
        C(3,1,I) = C(3,1,I)*PIVOT
        C(3,2,I) = C(3,2,I)*PIVOT
        C(3,3,I) = C(3,3,I)*PIVOT
        DO 14 L=1, NRHS
          R(3,L,I) = R(3,L,I)*PIVOT
   14   CONTINUE
C
C------ back substitute everything
        DO 15 KPIV=2, 1, -1
          KP1 = KPIV+1
          DO 151 K=KP1, 3
            C(KPIV,1,I) = C(KPIV,1,I) - A(KPIV,K,I)*C(K,1,I)
            C(KPIV,2,I) = C(KPIV,2,I) - A(KPIV,K,I)*C(K,2,I)
            C(KPIV,3,I) = C(KPIV,3,I) - A(KPIV,K,I)*C(K,3,I)
            DO 1511 L=1, NRHS
              R(KPIV,L,I) = R(KPIV,L,I) - A(KPIV,K,I)*R(K,L,I)
 1511       CONTINUE
  151     CONTINUE
   15   CONTINUE
    1 CONTINUE
C
CCC** Backward sweep: Back substitution using upper block diagonal (Ci's).
      DO 2 I=N-1, 1, -1
        IP = I+1
        DO 21 L=1, NRHS
          DO 211 K=1, 3
            R(K,L,I) = R(K,L,I)
     &               - (  R(1,L,IP)*C(K,1,I)
     &                  + R(2,L,IP)*C(K,2,I)
     &                  + R(3,L,IP)*C(K,3,I))
  211     CONTINUE
   21   CONTINUE
    2 CONTINUE
C
      RETURN
      END ! B3SOLV

      SUBROUTINE B3SOLV1(A,B,C,R,N,NRHS,NRMAX)
      DIMENSION A(3,3,N), B(3,3,N), C(3,3,N), R(3,NRMAX,N)
C     **********************************************************************
C      This routine solves a 3x3 block-tridiagonal system with an arbitrary
C      number of righthand sides by a standard block elimination scheme.  
C      The solutions are returned in the Rj vectors.
C
C      |A C      ||d|   |R..|
C      |B A C    ||d|   |R..|
C      |  B . .  ||.| = |R..|
C      |    . . C||.|   |R..|
C      |      B A||d|   |R..|
C                                                  Mark Drela   10 March 86
C     **********************************************************************
C
CCC** Forward sweep: Elimination of lower block diagonal (B's).
      DO 1 I=1, N
C
        IM = I-1
C
C------ don't eliminate B1 block because it doesn't exist
        IF(I.EQ.1) GO TO 12
C
C------ eliminate Bi block, thus modifying Ai and Ci blocks
        DO 11 K=1, 3
          DO 111 L=1, 3
            A(K,L,I) = A(K,L,I)
     &               - (  B(K,1,I)*C(1,L,IM)
     &                  + B(K,2,I)*C(2,L,IM)
     &                  + B(K,3,I)*C(3,L,IM))
  111     CONTINUE
          DO 112 L=1, NRHS
            R(K,L,I) = R(K,L,I)
     &               - (  B(K,1,I)*R(1,L,IM)
     &                  + B(K,2,I)*R(2,L,IM)
     &                  + B(K,3,I)*R(3,L,IM))
  112     CONTINUE
   11   CONTINUE
C
C                                                              -1
CCC---- multiply Ci block and righthand side Ri vectors by (Ai)
C       using Gaussian elimination.
C
   12   DO 13 KPIV=1, 2
          KP1 = KPIV+1
C
C-------- find max pivot index KX
          KX = KPIV
          DO 131 K=KP1, 3
            IF(ABS(A(K,KPIV,I))-ABS(A(KX,KPIV,I))) 131,131,1311
 1311        KX = K
  131     CONTINUE
C
          IF(A(KX,KPIV,I).EQ.0.0) THEN
           WRITE(*,*) 'Singular A block, i = ',I
           STOP
          ENDIF
C
          PIVOT = 1.0/A(KX,KPIV,I)
C
C-------- switch pivots
          A(KX,KPIV,I) = A(KPIV,KPIV,I)
C
C-------- switch rows & normalize pivot row
          DO 132 L=KP1, 3
            TEMP = A(KX,L,I)*PIVOT
            A(KX,L,I) = A(KPIV,L,I)
            A(KPIV,L,I) = TEMP
  132     CONTINUE
C
          DO 133 L=1, 3
            TEMP = C(KX,L,I)*PIVOT
            C(KX,L,I) = C(KPIV,L,I)
            C(KPIV,L,I) = TEMP
  133     CONTINUE
C
          DO 134 L=1, NRHS
            TEMP = R(KX,L,I)*PIVOT
            R(KX,L,I) = R(KPIV,L,I)
            R(KPIV,L,I) = TEMP
  134     CONTINUE
CB
C-------- forward eliminate everything
          DO 135 K=KP1, 3
            DO 1351 L=KP1, 3
              A(K,L,I) = A(K,L,I) - A(K,KPIV,I)*A(KPIV,L,I)
 1351       CONTINUE
            C(K,1,I) = C(K,1,I) - A(K,KPIV,I)*C(KPIV,1,I)
            C(K,2,I) = C(K,2,I) - A(K,KPIV,I)*C(KPIV,2,I)
            C(K,3,I) = C(K,3,I) - A(K,KPIV,I)*C(KPIV,3,I)
            DO 1352 L=1, NRHS
              R(K,L,I) = R(K,L,I) - A(K,KPIV,I)*R(KPIV,L,I)
 1352       CONTINUE
  135     CONTINUE
C
   13   CONTINUE
C
C------ solve for last row
        IF(A(3,3,I).EQ.0.0) THEN
         WRITE(*,*) 'Singular A block, i = ',I
         STOP
        ENDIF
        PIVOT = 1.0/A(3,3,I)
        C(3,1,I) = C(3,1,I)*PIVOT
        C(3,2,I) = C(3,2,I)*PIVOT
        C(3,3,I) = C(3,3,I)*PIVOT
        DO 14 L=1, NRHS
          R(3,L,I) = R(3,L,I)*PIVOT
   14   CONTINUE
C
C------ back substitute everything
        DO 15 KPIV=2, 1, -1
          KP1 = KPIV+1
          DO 151 K=KP1, 3
            C(KPIV,1,I) = C(KPIV,1,I) - A(KPIV,K,I)*C(K,1,I)
            C(KPIV,2,I) = C(KPIV,2,I) - A(KPIV,K,I)*C(K,2,I)
            C(KPIV,3,I) = C(KPIV,3,I) - A(KPIV,K,I)*C(K,3,I)
            DO 1511 L=1, NRHS
              R(KPIV,L,I) = R(KPIV,L,I) - A(KPIV,K,I)*R(K,L,I)
 1511       CONTINUE
  151     CONTINUE
   15   CONTINUE
    1 CONTINUE
C
CCC** Backward sweep: Back substitution using upper block diagonal (Ci's).
      DO 2 I=N-1, 1, -1
        IP = I+1
        DO 21 L=1, NRHS
          DO 211 K=1, 3
            R(K,L,I) = R(K,L,I)
     &               - (  R(1,L,IP)*C(K,1,I)
     &                  + R(2,L,IP)*C(K,2,I)
     &                  + R(3,L,IP)*C(K,3,I))
  211     CONTINUE
   21   CONTINUE
    2 CONTINUE
C
      RETURN
      END ! B3SOLV
