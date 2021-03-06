*> \brief \b CBBCSD
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CBBCSD + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cbbcsd.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cbbcsd.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cbbcsd.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CBBCSD( JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS, M, P, Q,
*                          THETA, PHI, U1, LDU1, U2, LDU2, V1T, LDV1T,
*                          V2T, LDV2T, B11D, B11E, B12D, B12E, B21D, B21E,
*                          B22D, B22E, RWORK, LRWORK, INFO )
*
*       .. Scalar Arguments ..
*       CHARACTER          JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS
*       INTEGER            INFO, LDU1, LDU2, LDV1T, LDV2T, LRWORK, M, P, Q
*       ..
*       .. Array Arguments ..
*       REAL               B11D( * ), B11E( * ), B12D( * ), B12E( * ),
*      $                   B21D( * ), B21E( * ), B22D( * ), B22E( * ),
*      $                   PHI( * ), THETA( * ), RWORK( * )
*       COMPLEX            U1( LDU1, * ), U2( LDU2, * ), V1T( LDV1T, * ),
*      $                   V2T( LDV2T, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CBBCSD computes the CS decomposition of a unitary matrix in
*> bidiagonal-block form,
*>
*>
*>     [ B11 | B12 0  0 ]
*>     [  0  |  0 -I  0 ]
*> X = [----------------]
*>     [ B21 | B22 0  0 ]
*>     [  0  |  0  0  I ]
*>
*>                               [  C | -S  0  0 ]
*>                   [ U1 |    ] [  0 |  0 -I  0 ] [ V1 |    ]**H
*>                 = [---------] [---------------] [---------]   .
*>                   [    | U2 ] [  S |  C  0  0 ] [    | V2 ]
*>                               [  0 |  0  0  I ]
*>
*> X is M-by-M, its top-left block is P-by-Q, and Q must be no larger
*> than P, M-P, or M-Q. (If Q is not the smallest index, then X must be
*> transposed and/or permuted. This can be done in constant time using
*> the TRANS and SIGNS options. See CUNCSD for details.)
*>
*> The bidiagonal matrices B11, B12, B21, and B22 are represented
*> implicitly by angles THETA(1:Q) and PHI(1:Q-1).
*>
*> The unitary matrices U1, U2, V1T, and V2T are input/output.
*> The input matrices are pre- or post-multiplied by the appropriate
*> singular vector matrices.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] JOBU1
*> \verbatim
*>          JOBU1 is CHARACTER
*>          = 'Y':      U1 is updated;
*>          otherwise:  U1 is not updated.
*> \endverbatim
*>
*> \param[in] JOBU2
*> \verbatim
*>          JOBU2 is CHARACTER
*>          = 'Y':      U2 is updated;
*>          otherwise:  U2 is not updated.
*> \endverbatim
*>
*> \param[in] JOBV1T
*> \verbatim
*>          JOBV1T is CHARACTER
*>          = 'Y':      V1T is updated;
*>          otherwise:  V1T is not updated.
*> \endverbatim
*>
*> \param[in] JOBV2T
*> \verbatim
*>          JOBV2T is CHARACTER
*>          = 'Y':      V2T is updated;
*>          otherwise:  V2T is not updated.
*> \endverbatim
*>
*> \param[in] TRANS
*> \verbatim
*>          TRANS is CHARACTER
*>          = 'T':      X, U1, U2, V1T, and V2T are stored in row-major
*>                      order;
*>          otherwise:  X, U1, U2, V1T, and V2T are stored in column-
*>                      major order.
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows and columns in X, the unitary matrix in
*>          bidiagonal-block form.
*> \endverbatim
*>
*> \param[in] P
*> \verbatim
*>          P is INTEGER
*>          The number of rows in the top-left block of X. 0 <= P <= M.
*> \endverbatim
*>
*> \param[in] Q
*> \verbatim
*>          Q is INTEGER
*>          The number of columns in the top-left block of X.
*>          0 <= Q <= MIN(P,M-P,M-Q).
*> \endverbatim
*>
*> \param[in,out] THETA
*> \verbatim
*>          THETA is REAL array, dimension (Q)
*>          On entry, the angles THETA(1),...,THETA(Q) that, along with
*>          PHI(1), ...,PHI(Q-1), define the matrix in bidiagonal-block
*>          form. On exit, the angles whose cosines and sines define the
*>          diagonal blocks in the CS decomposition.
*> \endverbatim
*>
*> \param[in,out] PHI
*> \verbatim
*>          PHI is REAL array, dimension (Q-1)
*>          The angles PHI(1),...,PHI(Q-1) that, along with THETA(1),...,
*>          THETA(Q), define the matrix in bidiagonal-block form.
*> \endverbatim
*>
*> \param[in,out] U1
*> \verbatim
*>          U1 is COMPLEX array, dimension (LDU1,P)
*>          On entry, a P-by-P matrix. On exit, U1 is postmultiplied
*>          by the left singular vector matrix common to [ B11 ; 0 ] and
*>          [ B12 0 0 ; 0 -I 0 0 ].
*> \endverbatim
*>
*> \param[in] LDU1
*> \verbatim
*>          LDU1 is INTEGER
*>          The leading dimension of the array U1, LDU1 >= MAX(1,P).
*> \endverbatim
*>
*> \param[in,out] U2
*> \verbatim
*>          U2 is COMPLEX array, dimension (LDU2,M-P)
*>          On entry, an (M-P)-by-(M-P) matrix. On exit, U2 is
*>          postmultiplied by the left singular vector matrix common to
*>          [ B21 ; 0 ] and [ B22 0 0 ; 0 0 I ].
*> \endverbatim
*>
*> \param[in] LDU2
*> \verbatim
*>          LDU2 is INTEGER
*>          The leading dimension of the array U2, LDU2 >= MAX(1,M-P).
*> \endverbatim
*>
*> \param[in,out] V1T
*> \verbatim
*>          V1T is COMPLEX array, dimension (LDV1T,Q)
*>          On entry, a Q-by-Q matrix. On exit, V1T is premultiplied
*>          by the conjugate transpose of the right singular vector
*>          matrix common to [ B11 ; 0 ] and [ B21 ; 0 ].
*> \endverbatim
*>
*> \param[in] LDV1T
*> \verbatim
*>          LDV1T is INTEGER
*>          The leading dimension of the array V1T, LDV1T >= MAX(1,Q).
*> \endverbatim
*>
*> \param[in,out] V2T
*> \verbatim
*>          V2T is COMPLEX array, dimenison (LDV2T,M-Q)
*>          On entry, an (M-Q)-by-(M-Q) matrix. On exit, V2T is
*>          premultiplied by the conjugate transpose of the right
*>          singular vector matrix common to [ B12 0 0 ; 0 -I 0 ] and
*>          [ B22 0 0 ; 0 0 I ].
*> \endverbatim
*>
*> \param[in] LDV2T
*> \verbatim
*>          LDV2T is INTEGER
*>          The leading dimension of the array V2T, LDV2T >= MAX(1,M-Q).
*> \endverbatim
*>
*> \param[out] B11D
*> \verbatim
*>          B11D is REAL array, dimension (Q)
*>          When CBBCSD converges, B11D contains the cosines of THETA(1),
*>          ..., THETA(Q). If CBBCSD fails to converge, then B11D
*>          contains the diagonal of the partially reduced top-left
*>          block.
*> \endverbatim
*>
*> \param[out] B11E
*> \verbatim
*>          B11E is REAL array, dimension (Q-1)
*>          When CBBCSD converges, B11E contains zeros. If CBBCSD fails
*>          to converge, then B11E contains the superdiagonal of the
*>          partially reduced top-left block.
*> \endverbatim
*>
*> \param[out] B12D
*> \verbatim
*>          B12D is REAL array, dimension (Q)
*>          When CBBCSD converges, B12D contains the negative sines of
*>          THETA(1), ..., THETA(Q). If CBBCSD fails to converge, then
*>          B12D contains the diagonal of the partially reduced top-right
*>          block.
*> \endverbatim
*>
*> \param[out] B12E
*> \verbatim
*>          B12E is REAL array, dimension (Q-1)
*>          When CBBCSD converges, B12E contains zeros. If CBBCSD fails
*>          to converge, then B12E contains the subdiagonal of the
*>          partially reduced top-right block.
*> \endverbatim
*>
*> \param[out] B21D
*> \verbatim
*>          B21D is REAL array, dimension (Q)
*>          When CBBCSD converges, B21D contains the negative sines of
*>          THETA(1), ..., THETA(Q). If CBBCSD fails to converge, then
*>          B21D contains the diagonal of the partially reduced bottom-left
*>          block.
*> \endverbatim
*>
*> \param[out] B21E
*> \verbatim
*>          B21E is REAL array, dimension (Q-1)
*>          When CBBCSD converges, B21E contains zeros. If CBBCSD fails
*>          to converge, then B21E contains the subdiagonal of the
*>          partially reduced bottom-left block.
*> \endverbatim
*>
*> \param[out] B22D
*> \verbatim
*>          B22D is REAL array, dimension (Q)
*>          When CBBCSD converges, B22D contains the negative sines of
*>          THETA(1), ..., THETA(Q). If CBBCSD fails to converge, then
*>          B22D contains the diagonal of the partially reduced bottom-right
*>          block.
*> \endverbatim
*>
*> \param[out] B22E
*> \verbatim
*>          B22E is REAL array, dimension (Q-1)
*>          When CBBCSD converges, B22E contains zeros. If CBBCSD fails
*>          to converge, then B22E contains the subdiagonal of the
*>          partially reduced bottom-right block.
*> \endverbatim
*>
*> \param[out] RWORK
*> \verbatim
*>          RWORK is REAL array, dimension (MAX(1,LRWORK))
*>          On exit, if INFO = 0, RWORK(1) returns the optimal LRWORK.
*> \endverbatim
*>
*> \param[in] LRWORK
*> \verbatim
*>          LRWORK is INTEGER
*>          The dimension of the array RWORK. LRWORK >= MAX(1,8*Q).
*>
*>          If LRWORK = -1, then a workspace query is assumed; the
*>          routine only calculates the optimal size of the RWORK array,
*>          returns this value as the first entry of the work array, and
*>          no error message related to LRWORK is issued by XERBLA.
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit.
*>          < 0:  if INFO = -i, the i-th argument had an illegal value.
*>          > 0:  if CBBCSD did not converge, INFO specifies the number
*>                of nonzero entries in PHI, and B11D, B11E, etc.,
*>                contain the partially reduced matrix.
*> \endverbatim
*
*> \par Internal Parameters:
*  =========================
*>
*> \verbatim
*>  TOLMUL  REAL, default = MAX(10,MIN(100,EPS**(-1/8)))
*>          TOLMUL controls the convergence criterion of the QR loop.
*>          Angles THETA(i), PHI(i) are rounded to 0 or PI/2 when they
*>          are within TOLMUL*EPS of either bound.
*> \endverbatim
*
*> \par References:
*  ================
*>
*>  [1] Brian D. Sutton. Computing the complete CS decomposition. Numer.
*>      Algorithms, 50(1):33-65, 2009.
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date June 2016
*
*> \ingroup complexOTHERcomputational
*
*  =====================================================================
      SUBROUTINE CBBCSD( JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS, M, P, Q,
     $                   THETA, PHI, U1, LDU1, U2, LDU2, V1T, LDV1T,
     $                   V2T, LDV2T, B11D, B11E, B12D, B12E, B21D, B21E,
     $                   B22D, B22E, RWORK, LRWORK, INFO )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     June 2016
*
*     .. Scalar Arguments ..
      CHARACTER          JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS
      INTEGER            INFO, LDU1, LDU2, LDV1T, LDV2T, LRWORK, M, P, Q
*     ..
*     .. Array Arguments ..
      REAL               B11D( * ), B11E( * ), B12D( * ), B12E( * ),
     $                   B21D( * ), B21E( * ), B22D( * ), B22E( * ),
     $                   PHI( * ), THETA( * ), RWORK( * )
      COMPLEX            U1( LDU1, * ), U2( LDU2, * ), V1T( LDV1T, * ),
     $                   V2T( LDV2T, * )
*     ..
*
*  ===================================================================
*
*     .. Parameters ..
      INTEGER            MAXITR
      PARAMETER          ( MAXITR = 6 )
      REAL               HUNDRED, MEIGHTH, ONE, PIOVER2, TEN, ZERO
      PARAMETER          ( HUNDRED = 100.0E0, MEIGHTH = -0.125E0,
     $                     ONE = 1.0E0, PIOVER2 = 1.57079632679489662E0,
     $                     TEN = 10.0E0, ZERO = 0.0E0 )
      COMPLEX            NEGONECOMPLEX
      PARAMETER          ( NEGONECOMPLEX = (-1.0E0,0.0E0) )
*     ..
*     .. Local Scalars ..
      LOGICAL            COLMAJOR, LQUERY, RESTART11, RESTART12,
     $                   RESTART21, RESTART22, WANTU1, WANTU2, WANTV1T,
     $                   WANTV2T
      INTEGER            I, IMIN, IMAX, ITER, IU1CS, IU1SN, IU2CS,
     $                   IU2SN, IV1TCS, IV1TSN, IV2TCS, IV2TSN, J,
     $                   LRWORKMIN, LRWORKOPT, MAXIT, MINI
      REAL               B11BULGE, B12BULGE, B21BULGE, B22BULGE, DUMMY,
     $                   EPS, MU, NU, R, SIGMA11, SIGMA21,
     $                   TEMP, THETAMAX, THETAMIN, THRESH, TOL, TOLMUL,
     $                   UNFL, X1, X2, Y1, Y2
*
*     .. External Subroutines ..
      EXTERNAL           CLASR, CSCAL, CSWAP, SLARTGP, SLARTGS, SLAS2,
     $                   XERBLA
*     ..
*     .. External Functions ..
      REAL               SLAMCH
      LOGICAL            LSAME
      EXTERNAL           LSAME, SLAMCH
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, ATAN2, COS, MAX, MIN, SIN, SQRT
*     ..
*     .. Executable Statements ..
*
*     Test input arguments
*
      INFO = 0
      LQUERY = LRWORK .EQ. -1
      WANTU1 = LSAME( JOBU1, 'Y' )
      WANTU2 = LSAME( JOBU2, 'Y' )
      WANTV1T = LSAME( JOBV1T, 'Y' )
      WANTV2T = LSAME( JOBV2T, 'Y' )
      COLMAJOR = .NOT. LSAME( TRANS, 'T' )
*
      IF( M .LT. 0 ) THEN
         INFO = -6
      ELSE IF( P .LT. 0 .OR. P .GT. M ) THEN
         INFO = -7
      ELSE IF( Q .LT. 0 .OR. Q .GT. M ) THEN
         INFO = -8
      ELSE IF( Q .GT. P .OR. Q .GT. M-P .OR. Q .GT. M-Q ) THEN
         INFO = -8
      ELSE IF( WANTU1 .AND. LDU1 .LT. P ) THEN
         INFO = -12
      ELSE IF( WANTU2 .AND. LDU2 .LT. M-P ) THEN
         INFO = -14
      ELSE IF( WANTV1T .AND. LDV1T .LT. Q ) THEN
         INFO = -16
      ELSE IF( WANTV2T .AND. LDV2T .LT. M-Q ) THEN
         INFO = -18
      END IF
*
*     Quick return if Q = 0
*
      IF( INFO .EQ. 0 .AND. Q .EQ. 0 ) THEN
         LRWORKMIN = 1
         RWORK(1) = LRWORKMIN
         RETURN
      END IF
*
*     Compute workspace
*
      IF( INFO .EQ. 0 ) THEN
         IU1CS = 1
         IU1SN = IU1CS + Q
         IU2CS = IU1SN + Q
         IU2SN = IU2CS + Q
         IV1TCS = IU2SN + Q
         IV1TSN = IV1TCS + Q
         IV2TCS = IV1TSN + Q
         IV2TSN = IV2TCS + Q
         LRWORKOPT = IV2TSN + Q - 1
         LRWORKMIN = LRWORKOPT
         RWORK(1) = LRWORKOPT
         IF( LRWORK .LT. LRWORKMIN .AND. .NOT. LQUERY ) THEN
            INFO = -28
         END IF
      END IF
*
      IF( INFO .NE. 0 ) THEN
         CALL XERBLA( 'CBBCSD', -INFO )
         RETURN
      ELSE IF( LQUERY ) THEN
         RETURN
      END IF
*
*     Get machine constants
*
      EPS = SLAMCH( 'Epsilon' )
      UNFL = SLAMCH( 'Safe minimum' )
      TOLMUL = MAX( TEN, MIN( HUNDRED, EPS**MEIGHTH ) )
      TOL = TOLMUL*EPS
      THRESH = MAX( TOL, MAXITR*Q*Q*UNFL )
*
*     Test for negligible sines or cosines
*
      DO I = 1, Q
         IF( THETA(I) .LT. THRESH ) THEN
            THETA(I) = ZERO
         ELSE IF( THETA(I) .GT. PIOVER2-THRESH ) THEN
            THETA(I) = PIOVER2
         END IF
      END DO
      DO I = 1, Q-1
         IF( PHI(I) .LT. THRESH ) THEN
            PHI(I) = ZERO
         ELSE IF( PHI(I) .GT. PIOVER2-THRESH ) THEN
            PHI(I) = PIOVER2
         END IF
      END DO
*
*     Initial deflation
*
      IMAX = Q
      DO WHILE( IMAX .GT. 1 )
         IF( PHI(IMAX-1) .NE. ZERO ) THEN
            EXIT
         END IF
         IMAX = IMAX - 1
      END DO
      IMIN = IMAX - 1
      IF  ( IMIN .GT. 1 ) THEN
         DO WHILE( PHI(IMIN-1) .NE. ZERO )
            IMIN = IMIN - 1
            IF  ( IMIN .LE. 1 ) EXIT
         END DO
      END IF
*
*     Initialize iteration counter
*
      MAXIT = MAXITR*Q*Q
      ITER = 0
*
*     Begin main iteration loop
*
      DO WHILE( IMAX .GT. 1 )
*
*        Compute the matrix entries
*
         B11D(IMIN) = COS( THETA(IMIN) )
         B21D(IMIN) = -SIN( THETA(IMIN) )
         DO I = IMIN, IMAX - 1
            B11E(I) = -SIN( THETA(I) ) * SIN( PHI(I) )
            B11D(I+1) = COS( THETA(I+1) ) * COS( PHI(I) )
            B12D(I) = SIN( THETA(I) ) * COS( PHI(I) )
            B12E(I) = COS( THETA(I+1) ) * SIN( PHI(I) )
            B21E(I) = -COS( THETA(I) ) * SIN( PHI(I) )
            B21D(I+1) = -SIN( THETA(I+1) ) * COS( PHI(I) )
            B22D(I) = COS( THETA(I) ) * COS( PHI(I) )
            B22E(I) = -SIN( THETA(I+1) ) * SIN( PHI(I) )
         END DO
         B12D(IMAX) = SIN( THETA(IMAX) )
         B22D(IMAX) = COS( THETA(IMAX) )
*
*        Abort if not converging; otherwise, increment ITER
*
         IF( ITER .GT. MAXIT ) THEN
            INFO = 0
            DO I = 1, Q
               IF( PHI(I) .NE. ZERO )
     $            INFO = INFO + 1
            END DO
            RETURN
         END IF
*
         ITER = ITER + IMAX - IMIN
*
*        Compute shifts
*
         THETAMAX = THETA(IMIN)
         THETAMIN = THETA(IMIN)
         DO I = IMIN+1, IMAX
            IF( THETA(I) > THETAMAX )
     $         THETAMAX = THETA(I)
            IF( THETA(I) < THETAMIN )
     $         THETAMIN = THETA(I)
         END DO
*
         IF( THETAMAX .GT. PIOVER2 - THRESH ) THEN
*
*           Zero on diagonals of B11 and B22; induce deflation with a
*           zero shift
*
            MU = ZERO
            NU = ONE
*
         ELSE IF( THETAMIN .LT. THRESH ) THEN
*
*           Zero on diagonals of B12 and B22; induce deflation with a
*           zero shift
*
            MU = ONE
            NU = ZERO
*
         ELSE
*
*           Compute shifts for B11 and B21 and use the lesser
*
            CALL SLAS2( B11D(IMAX-1), B11E(IMAX-1), B11D(IMAX), SIGMA11,
     $                  DUMMY )
            CALL SLAS2( B21D(IMAX-1), B21E(IMAX-1), B21D(IMAX), SIGMA21,
     $                  DUMMY )
*
            IF( SIGMA11 .LE. SIGMA21 ) THEN
               MU = SIGMA11
               NU = SQRT( ONE - MU**2 )
               IF( MU .LT. THRESH ) THEN
                  MU = ZERO
                  NU = ONE
               END IF
            ELSE
               NU = SIGMA21
               MU = SQRT( 1.0 - NU**2 )
               IF( NU .LT. THRESH ) THEN
                  MU = ONE
                  NU = ZERO
               END IF
            END IF
         END IF
*
*        Rotate to produce bulges in B11 and B21
*
         IF( MU .LE. NU ) THEN
            CALL SLARTGS( B11D(IMIN), B11E(IMIN), MU,
     $                    RWORK(IV1TCS+IMIN-1), RWORK(IV1TSN+IMIN-1) )
         ELSE
            CALL SLARTGS( B21D(IMIN), B21E(IMIN), NU,
     $                    RWORK(IV1TCS+IMIN-1), RWORK(IV1TSN+IMIN-1) )
         END IF
*
         TEMP = RWORK(IV1TCS+IMIN-1)*B11D(IMIN) +
     $          RWORK(IV1TSN+IMIN-1)*B11E(IMIN)
         B11E(IMIN) = RWORK(IV1TCS+IMIN-1)*B11E(IMIN) -
     $                RWORK(IV1TSN+IMIN-1)*B11D(IMIN)
         B11D(IMIN) = TEMP
         B11BULGE = RWORK(IV1TSN+IMIN-1)*B11D(IMIN+1)
         B11D(IMIN+1) = RWORK(IV1TCS+IMIN-1)*B11D(IMIN+1)
         TEMP = RWORK(IV1TCS+IMIN-1)*B21D(IMIN) +
     $          RWORK(IV1TSN+IMIN-1)*B21E(IMIN)
         B21E(IMIN) = RWORK(IV1TCS+IMIN-1)*B21E(IMIN) -
     $                RWORK(IV1TSN+IMIN-1)*B21D(IMIN)
         B21D(IMIN) = TEMP
         B21BULGE = RWORK(IV1TSN+IMIN-1)*B21D(IMIN+1)
         B21D(IMIN+1) = RWORK(IV1TCS+IMIN-1)*B21D(IMIN+1)
*
*        Compute THETA(IMIN)
*
         THETA( IMIN ) = ATAN2( SQRT( B21D(IMIN)**2+B21BULGE**2 ),
     $                   SQRT( B11D(IMIN)**2+B11BULGE**2 ) )
*
*        Chase the bulges in B11(IMIN+1,IMIN) and B21(IMIN+1,IMIN)
*
         IF( B11D(IMIN)**2+B11BULGE**2 .GT. THRESH**2 ) THEN
            CALL SLARTGP( B11BULGE, B11D(IMIN), RWORK(IU1SN+IMIN-1),
     $                    RWORK(IU1CS+IMIN-1), R )
         ELSE IF( MU .LE. NU ) THEN
            CALL SLARTGS( B11E( IMIN ), B11D( IMIN + 1 ), MU,
     $                    RWORK(IU1CS+IMIN-1), RWORK(IU1SN+IMIN-1) )
         ELSE
            CALL SLARTGS( B12D( IMIN ), B12E( IMIN ), NU,
     $                    RWORK(IU1CS+IMIN-1), RWORK(IU1SN+IMIN-1) )
         END IF
         IF( B21D(IMIN)**2+B21BULGE**2 .GT. THRESH**2 ) THEN
            CALL SLARTGP( B21BULGE, B21D(IMIN), RWORK(IU2SN+IMIN-1),
     $                    RWORK(IU2CS+IMIN-1), R )
         ELSE IF( NU .LT. MU ) THEN
            CALL SLARTGS( B21E( IMIN ), B21D( IMIN + 1 ), NU,
     $                    RWORK(IU2CS+IMIN-1), RWORK(IU2SN+IMIN-1) )
         ELSE
            CALL SLARTGS( B22D(IMIN), B22E(IMIN), MU,
     $                    RWORK(IU2CS+IMIN-1), RWORK(IU2SN+IMIN-1) )
         END IF
         RWORK(IU2CS+IMIN-1) = -RWORK(IU2CS+IMIN-1)
         RWORK(IU2SN+IMIN-1) = -RWORK(IU2SN+IMIN-1)
*
         TEMP = RWORK(IU1CS+IMIN-1)*B11E(IMIN) +
     $          RWORK(IU1SN+IMIN-1)*B11D(IMIN+1)
         B11D(IMIN+1) = RWORK(IU1CS+IMIN-1)*B11D(IMIN+1) -
     $                  RWORK(IU1SN+IMIN-1)*B11E(IMIN)
         B11E(IMIN) = TEMP
         IF( IMAX .GT. IMIN+1 ) THEN
            B11BULGE = RWORK(IU1SN+IMIN-1)*B11E(IMIN+1)
            B11E(IMIN+1) = RWORK(IU1CS+IMIN-1)*B11E(IMIN+1)
         END IF
         TEMP = RWORK(IU1CS+IMIN-1)*B12D(IMIN) +
     $          RWORK(IU1SN+IMIN-1)*B12E(IMIN)
         B12E(IMIN) = RWORK(IU1CS+IMIN-1)*B12E(IMIN) -
     $                RWORK(IU1SN+IMIN-1)*B12D(IMIN)
         B12D(IMIN) = TEMP
         B12BULGE = RWORK(IU1SN+IMIN-1)*B12D(IMIN+1)
         B12D(IMIN+1) = RWORK(IU1CS+IMIN-1)*B12D(IMIN+1)
         TEMP = RWORK(IU2CS+IMIN-1)*B21E(IMIN) +
     $          RWORK(IU2SN+IMIN-1)*B21D(IMIN+1)
         B21D(IMIN+1) = RWORK(IU2CS+IMIN-1)*B21D(IMIN+1) -
     $                  RWORK(IU2SN+IMIN-1)*B21E(IMIN)
         B21E(IMIN) = TEMP
         IF( IMAX .GT. IMIN+1 ) THEN
            B21BULGE = RWORK(IU2SN+IMIN-1)*B21E(IMIN+1)
            B21E(IMIN+1) = RWORK(IU2CS+IMIN-1)*B21E(IMIN+1)
         END IF
         TEMP = RWORK(IU2CS+IMIN-1)*B22D(IMIN) +
     $          RWORK(IU2SN+IMIN-1)*B22E(IMIN)
         B22E(IMIN) = RWORK(IU2CS+IMIN-1)*B22E(IMIN) -
     $                RWORK(IU2SN+IMIN-1)*B22D(IMIN)
         B22D(IMIN) = TEMP
         B22BULGE = RWORK(IU2SN+IMIN-1)*B22D(IMIN+1)
         B22D(IMIN+1) = RWORK(IU2CS+IMIN-1)*B22D(IMIN+1)
*
*        Inner loop: chase bulges from B11(IMIN,IMIN+2),
*        B12(IMIN,IMIN+1), B21(IMIN,IMIN+2), and B22(IMIN,IMIN+1) to
*        bottom-right
*
         DO I = IMIN+1, IMAX-1
*
*           Compute PHI(I-1)
*
            X1 = SIN(THETA(I-1))*B11E(I-1) + COS(THETA(I-1))*B21E(I-1)
            X2 = SIN(THETA(I-1))*B11BULGE + COS(THETA(I-1))*B21BULGE
            Y1 = SIN(THETA(I-1))*B12D(I-1) + COS(THETA(I-1))*B22D(I-1)
            Y2 = SIN(THETA(I-1))*B12BULGE + COS(THETA(I-1))*B22BULGE
*
            PHI(I-1) = ATAN2( SQRT(X1**2+X2**2), SQRT(Y1**2+Y2**2) )
*
*           Determine if there are bulges to chase or if a new direct
*           summand has been reached
*
            RESTART11 = B11E(I-1)**2 + B11BULGE**2 .LE. THRESH**2
            RESTART21 = B21E(I-1)**2 + B21BULGE**2 .LE. THRESH**2
            RESTART12 = B12D(I-1)**2 + B12BULGE**2 .LE. THRESH**2
            RESTART22 = B22D(I-1)**2 + B22BULGE**2 .LE. THRESH**2
*
*           If possible, chase bulges from B11(I-1,I+1), B12(I-1,I),
*           B21(I-1,I+1), and B22(I-1,I). If necessary, restart bulge-
*           chasing by applying the original shift again.
*
            IF( .NOT. RESTART11 .AND. .NOT. RESTART21 ) THEN
               CALL SLARTGP( X2, X1, RWORK(IV1TSN+I-1),
     $                       RWORK(IV1TCS+I-1), R )
            ELSE IF( .NOT. RESTART11 .AND. RESTART21 ) THEN
               CALL SLARTGP( B11BULGE, B11E(I-1), RWORK(IV1TSN+I-1),
     $                       RWORK(IV1TCS+I-1), R )
            ELSE IF( RESTART11 .AND. .NOT. RESTART21 ) THEN
               CALL SLARTGP( B21BULGE, B21E(I-1), RWORK(IV1TSN+I-1),
     $                       RWORK(IV1TCS+I-1), R )
            ELSE IF( MU .LE. NU ) THEN
               CALL SLARTGS( B11D(I), B11E(I), MU, RWORK(IV1TCS+I-1),
     $                       RWORK(IV1TSN+I-1) )
            ELSE
               CALL SLARTGS( B21D(I), B21E(I), NU, RWORK(IV1TCS+I-1),
     $                       RWORK(IV1TSN+I-1) )
            END IF
            RWORK(IV1TCS+I-1) = -RWORK(IV1TCS+I-1)
            RWORK(IV1TSN+I-1) = -RWORK(IV1TSN+I-1)
            IF( .NOT. RESTART12 .AND. .NOT. RESTART22 ) THEN
               CALL SLARTGP( Y2, Y1, RWORK(IV2TSN+I-1-1),
     $                       RWORK(IV2TCS+I-1-1), R )
            ELSE IF( .NOT. RESTART12 .AND. RESTART22 ) THEN
               CALL SLARTGP( B12BULGE, B12D(I-1), RWORK(IV2TSN+I-1-1),
     $                       RWORK(IV2TCS+I-1-1), R )
            ELSE IF( RESTART12 .AND. .NOT. RESTART22 ) THEN
               CALL SLARTGP( B22BULGE, B22D(I-1), RWORK(IV2TSN+I-1-1),
     $                       RWORK(IV2TCS+I-1-1), R )
            ELSE IF( NU .LT. MU ) THEN
               CALL SLARTGS( B12E(I-1), B12D(I), NU,
     $                       RWORK(IV2TCS+I-1-1), RWORK(IV2TSN+I-1-1) )
            ELSE
               CALL SLARTGS( B22E(I-1), B22D(I), MU,
     $                       RWORK(IV2TCS+I-1-1), RWORK(IV2TSN+I-1-1) )
            END IF
*
            TEMP = RWORK(IV1TCS+I-1)*B11D(I) + RWORK(IV1TSN+I-1)*B11E(I)
            B11E(I) = RWORK(IV1TCS+I-1)*B11E(I) -
     $                RWORK(IV1TSN+I-1)*B11D(I)
            B11D(I) = TEMP
            B11BULGE = RWORK(IV1TSN+I-1)*B11D(I+1)
            B11D(I+1) = RWORK(IV1TCS+I-1)*B11D(I+1)
            TEMP = RWORK(IV1TCS+I-1)*B21D(I) + RWORK(IV1TSN+I-1)*B21E(I)
            B21E(I) = RWORK(IV1TCS+I-1)*B21E(I) -
     $                RWORK(IV1TSN+I-1)*B21D(I)
            B21D(I) = TEMP
            B21BULGE = RWORK(IV1TSN+I-1)*B21D(I+1)
            B21D(I+1) = RWORK(IV1TCS+I-1)*B21D(I+1)
            TEMP = RWORK(IV2TCS+I-1-1)*B12E(I-1) +
     $             RWORK(IV2TSN+I-1-1)*B12D(I)
            B12D(I) = RWORK(IV2TCS+I-1-1)*B12D(I) -
     $                RWORK(IV2TSN+I-1-1)*B12E(I-1)
            B12E(I-1) = TEMP
            B12BULGE = RWORK(IV2TSN+I-1-1)*B12E(I)
            B12E(I) = RWORK(IV2TCS+I-1-1)*B12E(I)
            TEMP = RWORK(IV2TCS+I-1-1)*B22E(I-1) +
     $             RWORK(IV2TSN+I-1-1)*B22D(I)
            B22D(I) = RWORK(IV2TCS+I-1-1)*B22D(I) -
     $                RWORK(IV2TSN+I-1-1)*B22E(I-1)
            B22E(I-1) = TEMP
            B22BULGE = RWORK(IV2TSN+I-1-1)*B22E(I)
            B22E(I) = RWORK(IV2TCS+I-1-1)*B22E(I)
*
*           Compute THETA(I)
*
            X1 = COS(PHI(I-1))*B11D(I) + SIN(PHI(I-1))*B12E(I-1)
            X2 = COS(PHI(I-1))*B11BULGE + SIN(PHI(I-1))*B12BULGE
            Y1 = COS(PHI(I-1))*B21D(I) + SIN(PHI(I-1))*B22E(I-1)
            Y2 = COS(PHI(I-1))*B21BULGE + SIN(PHI(I-1))*B22BULGE
*
            THETA(I) = ATAN2( SQRT(Y1**2+Y2**2), SQRT(X1**2+X2**2) )
*
*           Determine if there are bulges to chase or if a new direct
*           summand has been reached
*
            RESTART11 =   B11D(I)**2 + B11BULGE**2 .LE. THRESH**2
            RESTART12 = B12E(I-1)**2 + B12BULGE**2 .LE. THRESH**2
            RESTART21 =   B21D(I)**2 + B21BULGE**2 .LE. THRESH**2
            RESTART22 = B22E(I-1)**2 + B22BULGE**2 .LE. THRESH**2
*
*           If possible, chase bulges from B11(I+1,I), B12(I+1,I-1),
*           B21(I+1,I), and B22(I+1,I-1). If necessary, restart bulge-
*           chasing by applying the original shift again.
*
            IF( .NOT. RESTART11 .AND. .NOT. RESTART12 ) THEN
               CALL SLARTGP( X2, X1, RWORK(IU1SN+I-1), RWORK(IU1CS+I-1),
     $                       R )
            ELSE IF( .NOT. RESTART11 .AND. RESTART12 ) THEN
               CALL SLARTGP( B11BULGE, B11D(I), RWORK(IU1SN+I-1),
     $                       RWORK(IU1CS+I-1), R )
            ELSE IF( RESTART11 .AND. .NOT. RESTART12 ) THEN
               CALL SLARTGP( B12BULGE, B12E(I-1), RWORK(IU1SN+I-1),
     $                       RWORK(IU1CS+I-1), R )
            ELSE IF( MU .LE. NU ) THEN
               CALL SLARTGS( B11E(I), B11D(I+1), MU, RWORK(IU1CS+I-1),
     $                       RWORK(IU1SN+I-1) )
            ELSE
               CALL SLARTGS( B12D(I), B12E(I), NU, RWORK(IU1CS+I-1),
     $                       RWORK(IU1SN+I-1) )
            END IF
            IF( .NOT. RESTART21 .AND. .NOT. RESTART22 ) THEN
               CALL SLARTGP( Y2, Y1, RWORK(IU2SN+I-1), RWORK(IU2CS+I-1),
     $                       R )
            ELSE IF( .NOT. RESTART21 .AND. RESTART22 ) THEN
               CALL SLARTGP( B21BULGE, B21D(I), RWORK(IU2SN+I-1),
     $                       RWORK(IU2CS+I-1), R )
            ELSE IF( RESTART21 .AND. .NOT. RESTART22 ) THEN
               CALL SLARTGP( B22BULGE, B22E(I-1), RWORK(IU2SN+I-1),
     $                       RWORK(IU2CS+I-1), R )
            ELSE IF( NU .LT. MU ) THEN
               CALL SLARTGS( B21E(I), B21E(I+1), NU, RWORK(IU2CS+I-1),
     $                       RWORK(IU2SN+I-1) )
            ELSE
               CALL SLARTGS( B22D(I), B22E(I), MU, RWORK(IU2CS+I-1),
     $                       RWORK(IU2SN+I-1) )
            END IF
            RWORK(IU2CS+I-1) = -RWORK(IU2CS+I-1)
            RWORK(IU2SN+I-1) = -RWORK(IU2SN+I-1)
*
            TEMP = RWORK(IU1CS+I-1)*B11E(I) + RWORK(IU1SN+I-1)*B11D(I+1)
            B11D(I+1) = RWORK(IU1CS+I-1)*B11D(I+1) -
     $                  RWORK(IU1SN+I-1)*B11E(I)
            B11E(I) = TEMP
            IF( I .LT. IMAX - 1 ) THEN
               B11BULGE = RWORK(IU1SN+I-1)*B11E(I+1)
               B11E(I+1) = RWORK(IU1CS+I-1)*B11E(I+1)
            END IF
            TEMP = RWORK(IU2CS+I-1)*B21E(I) + RWORK(IU2SN+I-1)*B21D(I+1)
            B21D(I+1) = RWORK(IU2CS+I-1)*B21D(I+1) -
     $                  RWORK(IU2SN+I-1)*B21E(I)
            B21E(I) = TEMP
            IF( I .LT. IMAX - 1 ) THEN
               B21BULGE = RWORK(IU2SN+I-1)*B21E(I+1)
               B21E(I+1) = RWORK(IU2CS+I-1)*B21E(I+1)
            END IF
            TEMP = RWORK(IU1CS+I-1)*B12D(I) + RWORK(IU1SN+I-1)*B12E(I)
            B12E(I) = RWORK(IU1CS+I-1)*B12E(I) -
     $                RWORK(IU1SN+I-1)*B12D(I)
            B12D(I) = TEMP
            B12BULGE = RWORK(IU1SN+I-1)*B12D(I+1)
            B12D(I+1) = RWORK(IU1CS+I-1)*B12D(I+1)
            TEMP = RWORK(IU2CS+I-1)*B22D(I) + RWORK(IU2SN+I-1)*B22E(I)
            B22E(I) = RWORK(IU2CS+I-1)*B22E(I) -
     $                RWORK(IU2SN+I-1)*B22D(I)
            B22D(I) = TEMP
            B22BULGE = RWORK(IU2SN+I-1)*B22D(I+1)
            B22D(I+1) = RWORK(IU2CS+I-1)*B22D(I+1)
*
         END DO
*
*        Compute PHI(IMAX-1)
*
         X1 = SIN(THETA(IMAX-1))*B11E(IMAX-1) +
     $        COS(THETA(IMAX-1))*B21E(IMAX-1)
         Y1 = SIN(THETA(IMAX-1))*B12D(IMAX-1) +
     $        COS(THETA(IMAX-1))*B22D(IMAX-1)
         Y2 = SIN(THETA(IMAX-1))*B12BULGE + COS(THETA(IMAX-1))*B22BULGE
*
         PHI(IMAX-1) = ATAN2( ABS(X1), SQRT(Y1**2+Y2**2) )
*
*        Chase bulges from B12(IMAX-1,IMAX) and B22(IMAX-1,IMAX)
*
         RESTART12 = B12D(IMAX-1)**2 + B12BULGE**2 .LE. THRESH**2
         RESTART22 = B22D(IMAX-1)**2 + B22BULGE**2 .LE. THRESH**2
*
         IF( .NOT. RESTART12 .AND. .NOT. RESTART22 ) THEN
            CALL SLARTGP( Y2, Y1, RWORK(IV2TSN+IMAX-1-1),
     $                    RWORK(IV2TCS+IMAX-1-1), R )
         ELSE IF( .NOT. RESTART12 .AND. RESTART22 ) THEN
            CALL SLARTGP( B12BULGE, B12D(IMAX-1),
     $                    RWORK(IV2TSN+IMAX-1-1),
     $                    RWORK(IV2TCS+IMAX-1-1), R )
         ELSE IF( RESTART12 .AND. .NOT. RESTART22 ) THEN
            CALL SLARTGP( B22BULGE, B22D(IMAX-1),
     $                    RWORK(IV2TSN+IMAX-1-1),
     $                    RWORK(IV2TCS+IMAX-1-1), R )
         ELSE IF( NU .LT. MU ) THEN
            CALL SLARTGS( B12E(IMAX-1), B12D(IMAX), NU,
     $                    RWORK(IV2TCS+IMAX-1-1),
     $                    RWORK(IV2TSN+IMAX-1-1) )
         ELSE
            CALL SLARTGS( B22E(IMAX-1), B22D(IMAX), MU,
     $                    RWORK(IV2TCS+IMAX-1-1),
     $                    RWORK(IV2TSN+IMAX-1-1) )
         END IF
*
         TEMP = RWORK(IV2TCS+IMAX-1-1)*B12E(IMAX-1) +
     $          RWORK(IV2TSN+IMAX-1-1)*B12D(IMAX)
         B12D(IMAX) = RWORK(IV2TCS+IMAX-1-1)*B12D(IMAX) -
     $                RWORK(IV2TSN+IMAX-1-1)*B12E(IMAX-1)
         B12E(IMAX-1) = TEMP
         TEMP = RWORK(IV2TCS+IMAX-1-1)*B22E(IMAX-1) +
     $          RWORK(IV2TSN+IMAX-1-1)*B22D(IMAX)
         B22D(IMAX) = RWORK(IV2TCS+IMAX-1-1)*B22D(IMAX) -
     $                RWORK(IV2TSN+IMAX-1-1)*B22E(IMAX-1)
         B22E(IMAX-1) = TEMP
*
*        Update singular vectors
*
         IF( WANTU1 ) THEN
            IF( COLMAJOR ) THEN
               CALL CLASR( 'R', 'V', 'F', P, IMAX-IMIN+1,
     $                     RWORK(IU1CS+IMIN-1), RWORK(IU1SN+IMIN-1),
     $                     U1(1,IMIN), LDU1 )
            ELSE
               CALL CLASR( 'L', 'V', 'F', IMAX-IMIN+1, P,
     $                     RWORK(IU1CS+IMIN-1), RWORK(IU1SN+IMIN-1),
     $                     U1(IMIN,1), LDU1 )
            END IF
         END IF
         IF( WANTU2 ) THEN
            IF( COLMAJOR ) THEN
               CALL CLASR( 'R', 'V', 'F', M-P, IMAX-IMIN+1,
     $                     RWORK(IU2CS+IMIN-1), RWORK(IU2SN+IMIN-1),
     $                     U2(1,IMIN), LDU2 )
            ELSE
               CALL CLASR( 'L', 'V', 'F', IMAX-IMIN+1, M-P,
     $                     RWORK(IU2CS+IMIN-1), RWORK(IU2SN+IMIN-1),
     $                     U2(IMIN,1), LDU2 )
            END IF
         END IF
         IF( WANTV1T ) THEN
            IF( COLMAJOR ) THEN
               CALL CLASR( 'L', 'V', 'F', IMAX-IMIN+1, Q,
     $                     RWORK(IV1TCS+IMIN-1), RWORK(IV1TSN+IMIN-1),
     $                     V1T(IMIN,1), LDV1T )
            ELSE
               CALL CLASR( 'R', 'V', 'F', Q, IMAX-IMIN+1,
     $                     RWORK(IV1TCS+IMIN-1), RWORK(IV1TSN+IMIN-1),
     $                     V1T(1,IMIN), LDV1T )
            END IF
         END IF
         IF( WANTV2T ) THEN
            IF( COLMAJOR ) THEN
               CALL CLASR( 'L', 'V', 'F', IMAX-IMIN+1, M-Q,
     $                     RWORK(IV2TCS+IMIN-1), RWORK(IV2TSN+IMIN-1),
     $                     V2T(IMIN,1), LDV2T )
            ELSE
               CALL CLASR( 'R', 'V', 'F', M-Q, IMAX-IMIN+1,
     $                     RWORK(IV2TCS+IMIN-1), RWORK(IV2TSN+IMIN-1),
     $                     V2T(1,IMIN), LDV2T )
            END IF
         END IF
*
*        Fix signs on B11(IMAX-1,IMAX) and B21(IMAX-1,IMAX)
*
         IF( B11E(IMAX-1)+B21E(IMAX-1) .GT. 0 ) THEN
            B11D(IMAX) = -B11D(IMAX)
            B21D(IMAX) = -B21D(IMAX)
            IF( WANTV1T ) THEN
               IF( COLMAJOR ) THEN
                  CALL CSCAL( Q, NEGONECOMPLEX, V1T(IMAX,1), LDV1T )
               ELSE
                  CALL CSCAL( Q, NEGONECOMPLEX, V1T(1,IMAX), 1 )
               END IF
            END IF
         END IF
*
*        Compute THETA(IMAX)
*
         X1 = COS(PHI(IMAX-1))*B11D(IMAX) +
     $        SIN(PHI(IMAX-1))*B12E(IMAX-1)
         Y1 = COS(PHI(IMAX-1))*B21D(IMAX) +
     $        SIN(PHI(IMAX-1))*B22E(IMAX-1)
*
         THETA(IMAX) = ATAN2( ABS(Y1), ABS(X1) )
*
*        Fix signs on B11(IMAX,IMAX), B12(IMAX,IMAX-1), B21(IMAX,IMAX),
*        and B22(IMAX,IMAX-1)
*
         IF( B11D(IMAX)+B12E(IMAX-1) .LT. 0 ) THEN
            B12D(IMAX) = -B12D(IMAX)
            IF( WANTU1 ) THEN
               IF( COLMAJOR ) THEN
                  CALL CSCAL( P, NEGONECOMPLEX, U1(1,IMAX), 1 )
               ELSE
                  CALL CSCAL( P, NEGONECOMPLEX, U1(IMAX,1), LDU1 )
               END IF
            END IF
         END IF
         IF( B21D(IMAX)+B22E(IMAX-1) .GT. 0 ) THEN
            B22D(IMAX) = -B22D(IMAX)
            IF( WANTU2 ) THEN
               IF( COLMAJOR ) THEN
                  CALL CSCAL( M-P, NEGONECOMPLEX, U2(1,IMAX), 1 )
               ELSE
                  CALL CSCAL( M-P, NEGONECOMPLEX, U2(IMAX,1), LDU2 )
               END IF
            END IF
         END IF
*
*        Fix signs on B12(IMAX,IMAX) and B22(IMAX,IMAX)
*
         IF( B12D(IMAX)+B22D(IMAX) .LT. 0 ) THEN
            IF( WANTV2T ) THEN
               IF( COLMAJOR ) THEN
                  CALL CSCAL( M-Q, NEGONECOMPLEX, V2T(IMAX,1), LDV2T )
               ELSE
                  CALL CSCAL( M-Q, NEGONECOMPLEX, V2T(1,IMAX), 1 )
               END IF
            END IF
         END IF
*
*        Test for negligible sines or cosines
*
         DO I = IMIN, IMAX
            IF( THETA(I) .LT. THRESH ) THEN
               THETA(I) = ZERO
            ELSE IF( THETA(I) .GT. PIOVER2-THRESH ) THEN
               THETA(I) = PIOVER2
            END IF
         END DO
         DO I = IMIN, IMAX-1
            IF( PHI(I) .LT. THRESH ) THEN
               PHI(I) = ZERO
            ELSE IF( PHI(I) .GT. PIOVER2-THRESH ) THEN
               PHI(I) = PIOVER2
            END IF
         END DO
*
*        Deflate
*
         IF (IMAX .GT. 1) THEN
            DO WHILE( PHI(IMAX-1) .EQ. ZERO )
               IMAX = IMAX - 1
               IF (IMAX .LE. 1) EXIT
            END DO
         END IF
         IF( IMIN .GT. IMAX - 1 )
     $      IMIN = IMAX - 1
         IF (IMIN .GT. 1) THEN
            DO WHILE (PHI(IMIN-1) .NE. ZERO)
                IMIN = IMIN - 1
                IF (IMIN .LE. 1) EXIT
            END DO
         END IF
*
*        Repeat main iteration loop
*
      END DO
*
*     Postprocessing: order THETA from least to greatest
*
      DO I = 1, Q
*
         MINI = I
         THETAMIN = THETA(I)
         DO J = I+1, Q
            IF( THETA(J) .LT. THETAMIN ) THEN
               MINI = J
               THETAMIN = THETA(J)
            END IF
         END DO
*
         IF( MINI .NE. I ) THEN
            THETA(MINI) = THETA(I)
            THETA(I) = THETAMIN
            IF( COLMAJOR ) THEN
               IF( WANTU1 )
     $            CALL CSWAP( P, U1(1,I), 1, U1(1,MINI), 1 )
               IF( WANTU2 )
     $            CALL CSWAP( M-P, U2(1,I), 1, U2(1,MINI), 1 )
               IF( WANTV1T )
     $            CALL CSWAP( Q, V1T(I,1), LDV1T, V1T(MINI,1), LDV1T )
               IF( WANTV2T )
     $            CALL CSWAP( M-Q, V2T(I,1), LDV2T, V2T(MINI,1),
     $               LDV2T )
            ELSE
               IF( WANTU1 )
     $            CALL CSWAP( P, U1(I,1), LDU1, U1(MINI,1), LDU1 )
               IF( WANTU2 )
     $            CALL CSWAP( M-P, U2(I,1), LDU2, U2(MINI,1), LDU2 )
               IF( WANTV1T )
     $            CALL CSWAP( Q, V1T(1,I), 1, V1T(1,MINI), 1 )
               IF( WANTV2T )
     $            CALL CSWAP( M-Q, V2T(1,I), 1, V2T(1,MINI), 1 )
            END IF
         END IF
*
      END DO
*
      RETURN
*
*     End of CBBCSD
*
      END

*> \brief \b CLACGV conjugates a complex vector.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLACGV + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clacgv.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clacgv.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clacgv.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLACGV( N, X, INCX )
*
*       .. Scalar Arguments ..
*       INTEGER            INCX, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            X( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLACGV conjugates a complex vector of length N.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The length of the vector X.  N >= 0.
*> \endverbatim
*>
*> \param[in,out] X
*> \verbatim
*>          X is COMPLEX array, dimension
*>                         (1+(N-1)*abs(INCX))
*>          On entry, the vector of length N to be conjugated.
*>          On exit, X is overwritten with conjg(X).
*> \endverbatim
*>
*> \param[in] INCX
*> \verbatim
*>          INCX is INTEGER
*>          The spacing between successive elements of X.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLACGV( N, X, INCX )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            INCX, N
*     ..
*     .. Array Arguments ..
      COMPLEX            X( * )
*     ..
*
* =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, IOFF
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CONJG
*     ..
*     .. Executable Statements ..
*
      IF( INCX.EQ.1 ) THEN
         DO 10 I = 1, N
            X( I ) = CONJG( X( I ) )
   10    CONTINUE
      ELSE
         IOFF = 1
         IF( INCX.LT.0 )
     $      IOFF = 1 - ( N-1 )*INCX
         DO 20 I = 1, N
            X( IOFF ) = CONJG( X( IOFF ) )
            IOFF = IOFF + INCX
   20    CONTINUE
      END IF
      RETURN
*
*     End of CLACGV
*
      END
*> \brief \b CLACPY copies all or part of one two-dimensional array to another.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLACPY + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clacpy.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clacpy.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clacpy.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLACPY( UPLO, M, N, A, LDA, B, LDB )
*
*       .. Scalar Arguments ..
*       CHARACTER          UPLO
*       INTEGER            LDA, LDB, M, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            A( LDA, * ), B( LDB, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLACPY copies all or part of a two-dimensional matrix A to another
*> matrix B.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] UPLO
*> \verbatim
*>          UPLO is CHARACTER*1
*>          Specifies the part of the matrix A to be copied to B.
*>          = 'U':      Upper triangular part
*>          = 'L':      Lower triangular part
*>          Otherwise:  All of the matrix A
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix A.  M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix A.  N >= 0.
*> \endverbatim
*>
*> \param[in] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          The m by n matrix A.  If UPLO = 'U', only the upper trapezium
*>          is accessed; if UPLO = 'L', only the lower trapezium is
*>          accessed.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A.  LDA >= max(1,M).
*> \endverbatim
*>
*> \param[out] B
*> \verbatim
*>          B is COMPLEX array, dimension (LDB,N)
*>          On exit, B = A in the locations specified by UPLO.
*> \endverbatim
*>
*> \param[in] LDB
*> \verbatim
*>          LDB is INTEGER
*>          The leading dimension of the array B.  LDB >= max(1,M).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLACPY( UPLO, M, N, A, LDA, B, LDB )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          UPLO
      INTEGER            LDA, LDB, M, N
*     ..
*     .. Array Arguments ..
      COMPLEX            A( LDA, * ), B( LDB, * )
*     ..
*
*  =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, J
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MIN
*     ..
*     .. Executable Statements ..
*
      IF( LSAME( UPLO, 'U' ) ) THEN
         DO 20 J = 1, N
            DO 10 I = 1, MIN( J, M )
               B( I, J ) = A( I, J )
   10       CONTINUE
   20    CONTINUE
*
      ELSE IF( LSAME( UPLO, 'L' ) ) THEN
         DO 40 J = 1, N
            DO 30 I = J, M
               B( I, J ) = A( I, J )
   30       CONTINUE
   40    CONTINUE
*
      ELSE
         DO 60 J = 1, N
            DO 50 I = 1, M
               B( I, J ) = A( I, J )
   50       CONTINUE
   60    CONTINUE
      END IF
*
      RETURN
*
*     End of CLACPY
*
      END
*> \brief \b CLADIV performs complex division in real arithmetic, avoiding unnecessary overflow.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLADIV + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cladiv.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cladiv.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cladiv.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       COMPLEX FUNCTION CLADIV( X, Y )
*
*       .. Scalar Arguments ..
*       COMPLEX            X, Y
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLADIV := X / Y, where X and Y are complex.  The computation of X / Y
*> will not overflow on an intermediary step unless the results
*> overflows.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] X
*> \verbatim
*>          X is COMPLEX
*> \endverbatim
*>
*> \param[in] Y
*> \verbatim
*>          Y is COMPLEX
*>          The complex scalars X and Y.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      COMPLEX FUNCTION CLADIV( X, Y )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      COMPLEX            X, Y
*     ..
*
*  =====================================================================
*
*     .. Local Scalars ..
      REAL               ZI, ZR
*     ..
*     .. External Subroutines ..
      EXTERNAL           SLADIV
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          AIMAG, CMPLX, REAL
*     ..
*     .. Executable Statements ..
*
      CALL SLADIV( REAL( X ), AIMAG( X ), REAL( Y ), AIMAG( Y ), ZR,
     $             ZI )
      CLADIV = CMPLX( ZR, ZI )
*
      RETURN
*
*     End of CLADIV
*
      END
*> \brief \b CLAPMR rearranges rows of a matrix as specified by a permutation vector.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLAPMR + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clapmr.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clapmr.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clapmr.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLAPMR( FORWRD, M, N, X, LDX, K )
*
*       .. Scalar Arguments ..
*       LOGICAL            FORWRD
*       INTEGER            LDX, M, N
*       ..
*       .. Array Arguments ..
*       INTEGER            K( * )
*       COMPLEX            X( LDX, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLAPMR rearranges the rows of the M by N matrix X as specified
*> by the permutation K(1),K(2),...,K(M) of the integers 1,...,M.
*> If FORWRD = .TRUE.,  forward permutation:
*>
*>      X(K(I),*) is moved X(I,*) for I = 1,2,...,M.
*>
*> If FORWRD = .FALSE., backward permutation:
*>
*>      X(I,*) is moved to X(K(I),*) for I = 1,2,...,M.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] FORWRD
*> \verbatim
*>          FORWRD is LOGICAL
*>          = .TRUE., forward permutation
*>          = .FALSE., backward permutation
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix X. M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix X. N >= 0.
*> \endverbatim
*>
*> \param[in,out] X
*> \verbatim
*>          X is COMPLEX array, dimension (LDX,N)
*>          On entry, the M by N matrix X.
*>          On exit, X contains the permuted matrix X.
*> \endverbatim
*>
*> \param[in] LDX
*> \verbatim
*>          LDX is INTEGER
*>          The leading dimension of the array X, LDX >= MAX(1,M).
*> \endverbatim
*>
*> \param[in,out] K
*> \verbatim
*>          K is INTEGER array, dimension (M)
*>          On entry, K contains the permutation vector. K is used as
*>          internal workspace, but reset to its original value on
*>          output.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLAPMR( FORWRD, M, N, X, LDX, K )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      LOGICAL            FORWRD
      INTEGER            LDX, M, N
*     ..
*     .. Array Arguments ..
      INTEGER            K( * )
      COMPLEX            X( LDX, * )
*     ..
*
*  =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, IN, J, JJ
      COMPLEX            TEMP
*     ..
*     .. Executable Statements ..
*
      IF( M.LE.1 )
     $   RETURN
*
      DO 10 I = 1, M
         K( I ) = -K( I )
   10 CONTINUE
*
      IF( FORWRD ) THEN
*
*        Forward permutation
*
         DO 50 I = 1, M
*
            IF( K( I ).GT.0 )
     $         GO TO 40
*
            J = I
            K( J ) = -K( J )
            IN = K( J )
*
   20       CONTINUE
            IF( K( IN ).GT.0 )
     $         GO TO 40
*
            DO 30 JJ = 1, N
               TEMP = X( J, JJ )
               X( J, JJ ) = X( IN, JJ )
               X( IN, JJ ) = TEMP
   30       CONTINUE
*
            K( IN ) = -K( IN )
            J = IN
            IN = K( IN )
            GO TO 20
*
   40       CONTINUE
*
   50    CONTINUE
*
      ELSE
*
*        Backward permutation
*
         DO 90 I = 1, M
*
            IF( K( I ).GT.0 )
     $         GO TO 80
*
            K( I ) = -K( I )
            J = K( I )
   60       CONTINUE
            IF( J.EQ.I )
     $         GO TO 80
*
            DO 70 JJ = 1, N
               TEMP = X( I, JJ )
               X( I, JJ ) = X( J, JJ )
               X( J, JJ ) = TEMP
   70       CONTINUE
*
            K( J ) = -K( J )
            J = K( J )
            GO TO 60
*
   80       CONTINUE
*
   90    CONTINUE
*
      END IF
*
      RETURN
*
*     End of ZLAPMT
*
      END

*> \brief \b CLAPMT performs a forward or backward permutation of the columns of a matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLAPMT + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clapmt.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clapmt.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clapmt.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLAPMT( FORWRD, M, N, X, LDX, K )
*
*       .. Scalar Arguments ..
*       LOGICAL            FORWRD
*       INTEGER            LDX, M, N
*       ..
*       .. Array Arguments ..
*       INTEGER            K( * )
*       COMPLEX            X( LDX, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLAPMT rearranges the columns of the M by N matrix X as specified
*> by the permutation K(1),K(2),...,K(N) of the integers 1,...,N.
*> If FORWRD = .TRUE.,  forward permutation:
*>
*>      X(*,K(J)) is moved X(*,J) for J = 1,2,...,N.
*>
*> If FORWRD = .FALSE., backward permutation:
*>
*>      X(*,J) is moved to X(*,K(J)) for J = 1,2,...,N.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] FORWRD
*> \verbatim
*>          FORWRD is LOGICAL
*>          = .TRUE., forward permutation
*>          = .FALSE., backward permutation
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix X. M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix X. N >= 0.
*> \endverbatim
*>
*> \param[in,out] X
*> \verbatim
*>          X is COMPLEX array, dimension (LDX,N)
*>          On entry, the M by N matrix X.
*>          On exit, X contains the permuted matrix X.
*> \endverbatim
*>
*> \param[in] LDX
*> \verbatim
*>          LDX is INTEGER
*>          The leading dimension of the array X, LDX >= MAX(1,M).
*> \endverbatim
*>
*> \param[in,out] K
*> \verbatim
*>          K is INTEGER array, dimension (N)
*>          On entry, K contains the permutation vector. K is used as
*>          internal workspace, but reset to its original value on
*>          output.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLAPMT( FORWRD, M, N, X, LDX, K )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      LOGICAL            FORWRD
      INTEGER            LDX, M, N
*     ..
*     .. Array Arguments ..
      INTEGER            K( * )
      COMPLEX            X( LDX, * )
*     ..
*
*  =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, II, J, IN
      COMPLEX            TEMP
*     ..
*     .. Executable Statements ..
*
      IF( N.LE.1 )
     $   RETURN
*
      DO 10 I = 1, N
         K( I ) = -K( I )
   10 CONTINUE
*
      IF( FORWRD ) THEN
*
*        Forward permutation
*
         DO 60 I = 1, N
*
            IF( K( I ).GT.0 )
     $         GO TO 40
*
            J = I
            K( J ) = -K( J )
            IN = K( J )
*
   20       CONTINUE
            IF( K( IN ).GT.0 )
     $         GO TO 40
*
            DO 30 II = 1, M
               TEMP = X( II, J )
               X( II, J ) = X( II, IN )
               X( II, IN ) = TEMP
   30       CONTINUE
*
            K( IN ) = -K( IN )
            J = IN
            IN = K( IN )
            GO TO 20
*
   40       CONTINUE
*
   60    CONTINUE
*
      ELSE
*
*        Backward permutation
*
         DO 110 I = 1, N
*
            IF( K( I ).GT.0 )
     $         GO TO 100
*
            K( I ) = -K( I )
            J = K( I )
   80       CONTINUE
            IF( J.EQ.I )
     $         GO TO 100
*
            DO 90 II = 1, M
               TEMP = X( II, I )
               X( II, I ) = X( II, J )
               X( II, J ) = TEMP
   90       CONTINUE
*
            K( J ) = -K( J )
            J = K( J )
            GO TO 80
*
  100       CONTINUE

  110    CONTINUE
*
      END IF
*
      RETURN
*
*     End of CLAPMT
*
      END
*> \brief \b CLARF applies an elementary reflector to a general rectangular matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLARF + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clarf.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clarf.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clarf.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLARF( SIDE, M, N, V, INCV, TAU, C, LDC, WORK )
*
*       .. Scalar Arguments ..
*       CHARACTER          SIDE
*       INTEGER            INCV, LDC, M, N
*       COMPLEX            TAU
*       ..
*       .. Array Arguments ..
*       COMPLEX            C( LDC, * ), V( * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLARF applies a complex elementary reflector H to a complex M-by-N
*> matrix C, from either the left or the right. H is represented in the
*> form
*>
*>       H = I - tau * v * v**H
*>
*> where tau is a complex scalar and v is a complex vector.
*>
*> If tau = 0, then H is taken to be the unit matrix.
*>
*> To apply H**H (the conjugate transpose of H), supply conjg(tau) instead
*> tau.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] SIDE
*> \verbatim
*>          SIDE is CHARACTER*1
*>          = 'L': form  H * C
*>          = 'R': form  C * H
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix C.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix C.
*> \endverbatim
*>
*> \param[in] V
*> \verbatim
*>          V is COMPLEX array, dimension
*>                     (1 + (M-1)*abs(INCV)) if SIDE = 'L'
*>                  or (1 + (N-1)*abs(INCV)) if SIDE = 'R'
*>          The vector v in the representation of H. V is not used if
*>          TAU = 0.
*> \endverbatim
*>
*> \param[in] INCV
*> \verbatim
*>          INCV is INTEGER
*>          The increment between elements of v. INCV <> 0.
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX
*>          The value tau in the representation of H.
*> \endverbatim
*>
*> \param[in,out] C
*> \verbatim
*>          C is COMPLEX array, dimension (LDC,N)
*>          On entry, the M-by-N matrix C.
*>          On exit, C is overwritten by the matrix H * C if SIDE = 'L',
*>          or C * H if SIDE = 'R'.
*> \endverbatim
*>
*> \param[in] LDC
*> \verbatim
*>          LDC is INTEGER
*>          The leading dimension of the array C. LDC >= max(1,M).
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension
*>                         (N) if SIDE = 'L'
*>                      or (M) if SIDE = 'R'
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLARF( SIDE, M, N, V, INCV, TAU, C, LDC, WORK )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          SIDE
      INTEGER            INCV, LDC, M, N
      COMPLEX            TAU
*     ..
*     .. Array Arguments ..
      COMPLEX            C( LDC, * ), V( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ONE, ZERO
      PARAMETER          ( ONE = ( 1.0E+0, 0.0E+0 ),
     $                   ZERO = ( 0.0E+0, 0.0E+0 ) )
*     ..
*     .. Local Scalars ..
      LOGICAL            APPLYLEFT
      INTEGER            I, LASTV, LASTC
*     ..
*     .. External Subroutines ..
      EXTERNAL           CGEMV, CGERC
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      INTEGER            ILACLR, ILACLC
      EXTERNAL           LSAME, ILACLR, ILACLC
*     ..
*     .. Executable Statements ..
*
      APPLYLEFT = LSAME( SIDE, 'L' )
      LASTV = 0
      LASTC = 0
      IF( TAU.NE.ZERO ) THEN
!     Set up variables for scanning V.  LASTV begins pointing to the end
!     of V.
         IF( APPLYLEFT ) THEN
            LASTV = M
         ELSE
            LASTV = N
         END IF
         IF( INCV.GT.0 ) THEN
            I = 1 + (LASTV-1) * INCV
         ELSE
            I = 1
         END IF
!     Look for the last non-zero row in V.
         DO WHILE( LASTV.GT.0 .AND. V( I ).EQ.ZERO )
            LASTV = LASTV - 1
            I = I - INCV
         END DO
         IF( APPLYLEFT ) THEN
!     Scan for the last non-zero column in C(1:lastv,:).
            LASTC = ILACLC(LASTV, N, C, LDC)
         ELSE
!     Scan for the last non-zero row in C(:,1:lastv).
            LASTC = ILACLR(M, LASTV, C, LDC)
         END IF
      END IF
!     Note that lastc.eq.0 renders the BLAS operations null; no special
!     case is needed at this level.
      IF( APPLYLEFT ) THEN
*
*        Form  H * C
*
         IF( LASTV.GT.0 ) THEN
*
*           w(1:lastc,1) := C(1:lastv,1:lastc)**H * v(1:lastv,1)
*
            CALL CGEMV( 'Conjugate transpose', LASTV, LASTC, ONE,
     $           C, LDC, V, INCV, ZERO, WORK, 1 )
*
*           C(1:lastv,1:lastc) := C(...) - v(1:lastv,1) * w(1:lastc,1)**H
*
            CALL CGERC( LASTV, LASTC, -TAU, V, INCV, WORK, 1, C, LDC )
         END IF
      ELSE
*
*        Form  C * H
*
         IF( LASTV.GT.0 ) THEN
*
*           w(1:lastc,1) := C(1:lastc,1:lastv) * v(1:lastv,1)
*
            CALL CGEMV( 'No transpose', LASTC, LASTV, ONE, C, LDC,
     $           V, INCV, ZERO, WORK, 1 )
*
*           C(1:lastc,1:lastv) := C(...) - w(1:lastc,1) * v(1:lastv,1)**H
*
            CALL CGERC( LASTC, LASTV, -TAU, WORK, 1, V, INCV, C, LDC )
         END IF
      END IF
      RETURN
*
*     End of CLARF
*
      END
*> \brief \b CLARFB applies a block reflector or its conjugate-transpose to a general rectangular matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLARFB + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clarfb.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clarfb.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clarfb.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLARFB( SIDE, TRANS, DIRECT, STOREV, M, N, K, V, LDV,
*                          T, LDT, C, LDC, WORK, LDWORK )
*
*       .. Scalar Arguments ..
*       CHARACTER          DIRECT, SIDE, STOREV, TRANS
*       INTEGER            K, LDC, LDT, LDV, LDWORK, M, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            C( LDC, * ), T( LDT, * ), V( LDV, * ),
*      $                   WORK( LDWORK, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLARFB applies a complex block reflector H or its transpose H**H to a
*> complex M-by-N matrix C, from either the left or the right.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] SIDE
*> \verbatim
*>          SIDE is CHARACTER*1
*>          = 'L': apply H or H**H from the Left
*>          = 'R': apply H or H**H from the Right
*> \endverbatim
*>
*> \param[in] TRANS
*> \verbatim
*>          TRANS is CHARACTER*1
*>          = 'N': apply H (No transpose)
*>          = 'C': apply H**H (Conjugate transpose)
*> \endverbatim
*>
*> \param[in] DIRECT
*> \verbatim
*>          DIRECT is CHARACTER*1
*>          Indicates how H is formed from a product of elementary
*>          reflectors
*>          = 'F': H = H(1) H(2) . . . H(k) (Forward)
*>          = 'B': H = H(k) . . . H(2) H(1) (Backward)
*> \endverbatim
*>
*> \param[in] STOREV
*> \verbatim
*>          STOREV is CHARACTER*1
*>          Indicates how the vectors which define the elementary
*>          reflectors are stored:
*>          = 'C': Columnwise
*>          = 'R': Rowwise
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix C.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix C.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The order of the matrix T (= the number of elementary
*>          reflectors whose product defines the block reflector).
*> \endverbatim
*>
*> \param[in] V
*> \verbatim
*>          V is COMPLEX array, dimension
*>                                (LDV,K) if STOREV = 'C'
*>                                (LDV,M) if STOREV = 'R' and SIDE = 'L'
*>                                (LDV,N) if STOREV = 'R' and SIDE = 'R'
*>          The matrix V. See Further Details.
*> \endverbatim
*>
*> \param[in] LDV
*> \verbatim
*>          LDV is INTEGER
*>          The leading dimension of the array V.
*>          If STOREV = 'C' and SIDE = 'L', LDV >= max(1,M);
*>          if STOREV = 'C' and SIDE = 'R', LDV >= max(1,N);
*>          if STOREV = 'R', LDV >= K.
*> \endverbatim
*>
*> \param[in] T
*> \verbatim
*>          T is COMPLEX array, dimension (LDT,K)
*>          The triangular K-by-K matrix T in the representation of the
*>          block reflector.
*> \endverbatim
*>
*> \param[in] LDT
*> \verbatim
*>          LDT is INTEGER
*>          The leading dimension of the array T. LDT >= K.
*> \endverbatim
*>
*> \param[in,out] C
*> \verbatim
*>          C is COMPLEX array, dimension (LDC,N)
*>          On entry, the M-by-N matrix C.
*>          On exit, C is overwritten by H*C or H**H*C or C*H or C*H**H.
*> \endverbatim
*>
*> \param[in] LDC
*> \verbatim
*>          LDC is INTEGER
*>          The leading dimension of the array C. LDC >= max(1,M).
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (LDWORK,K)
*> \endverbatim
*>
*> \param[in] LDWORK
*> \verbatim
*>          LDWORK is INTEGER
*>          The leading dimension of the array WORK.
*>          If SIDE = 'L', LDWORK >= max(1,N);
*>          if SIDE = 'R', LDWORK >= max(1,M).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date June 2013
*
*> \ingroup complexOTHERauxiliary
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  The shape of the matrix V and the storage of the vectors which define
*>  the H(i) is best illustrated by the following example with n = 5 and
*>  k = 3. The elements equal to 1 are not stored; the corresponding
*>  array elements are modified but restored on exit. The rest of the
*>  array is not used.
*>
*>  DIRECT = 'F' and STOREV = 'C':         DIRECT = 'F' and STOREV = 'R':
*>
*>               V = (  1       )                 V = (  1 v1 v1 v1 v1 )
*>                   ( v1  1    )                     (     1 v2 v2 v2 )
*>                   ( v1 v2  1 )                     (        1 v3 v3 )
*>                   ( v1 v2 v3 )
*>                   ( v1 v2 v3 )
*>
*>  DIRECT = 'B' and STOREV = 'C':         DIRECT = 'B' and STOREV = 'R':
*>
*>               V = ( v1 v2 v3 )                 V = ( v1 v1  1       )
*>                   ( v1 v2 v3 )                     ( v2 v2 v2  1    )
*>                   (  1 v2 v3 )                     ( v3 v3 v3 v3  1 )
*>                   (     1 v3 )
*>                   (        1 )
*> \endverbatim
*>
*  =====================================================================
      SUBROUTINE CLARFB( SIDE, TRANS, DIRECT, STOREV, M, N, K, V, LDV,
     $                   T, LDT, C, LDC, WORK, LDWORK )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     June 2013
*
*     .. Scalar Arguments ..
      CHARACTER          DIRECT, SIDE, STOREV, TRANS
      INTEGER            K, LDC, LDT, LDV, LDWORK, M, N
*     ..
*     .. Array Arguments ..
      COMPLEX            C( LDC, * ), T( LDT, * ), V( LDV, * ),
     $                   WORK( LDWORK, * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ONE
      PARAMETER          ( ONE = ( 1.0E+0, 0.0E+0 ) )
*     ..
*     .. Local Scalars ..
      CHARACTER          TRANST
      INTEGER            I, J
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. External Subroutines ..
      EXTERNAL           CCOPY, CGEMM, CLACGV, CTRMM
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CONJG
*     ..
*     .. Executable Statements ..
*
*     Quick return if possible
*
      IF( M.LE.0 .OR. N.LE.0 )
     $   RETURN
*
      IF( LSAME( TRANS, 'N' ) ) THEN
         TRANST = 'C'
      ELSE
         TRANST = 'N'
      END IF
*
      IF( LSAME( STOREV, 'C' ) ) THEN
*
         IF( LSAME( DIRECT, 'F' ) ) THEN
*
*           Let  V =  ( V1 )    (first K rows)
*                     ( V2 )
*           where  V1  is unit lower triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**H * C  where  C = ( C1 )
*                                                    ( C2 )
*
*              W := C**H * V  =  (C1**H * V1 + C2**H * V2)  (stored in WORK)
*
*              W := C1**H
*
               DO 10 J = 1, K
                  CALL CCOPY( N, C( J, 1 ), LDC, WORK( 1, J ), 1 )
                  CALL CLACGV( N, WORK( 1, J ), 1 )
   10          CONTINUE
*
*              W := W * V1
*
               CALL CTRMM( 'Right', 'Lower', 'No transpose', 'Unit', N,
     $                     K, ONE, V, LDV, WORK, LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C2**H *V2
*
                  CALL CGEMM( 'Conjugate transpose', 'No transpose', N,
     $                        K, M-K, ONE, C( K+1, 1 ), LDC,
     $                        V( K+1, 1 ), LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T**H  or  W * T
*
               CALL CTRMM( 'Right', 'Upper', TRANST, 'Non-unit', N, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V * W**H
*
               IF( M.GT.K ) THEN
*
*                 C2 := C2 - V2 * W**H
*
                  CALL CGEMM( 'No transpose', 'Conjugate transpose',
     $                        M-K, N, K, -ONE, V( K+1, 1 ), LDV, WORK,
     $                        LDWORK, ONE, C( K+1, 1 ), LDC )
               END IF
*
*              W := W * V1**H
*
               CALL CTRMM( 'Right', 'Lower', 'Conjugate transpose',
     $                     'Unit', N, K, ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W**H
*
               DO 30 J = 1, K
                  DO 20 I = 1, N
                     C( J, I ) = C( J, I ) - CONJG( WORK( I, J ) )
   20             CONTINUE
   30          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H**H  where  C = ( C1  C2 )
*
*              W := C * V  =  (C1*V1 + C2*V2)  (stored in WORK)
*
*              W := C1
*
               DO 40 J = 1, K
                  CALL CCOPY( M, C( 1, J ), 1, WORK( 1, J ), 1 )
   40          CONTINUE
*
*              W := W * V1
*
               CALL CTRMM( 'Right', 'Lower', 'No transpose', 'Unit', M,
     $                     K, ONE, V, LDV, WORK, LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C2 * V2
*
                  CALL CGEMM( 'No transpose', 'No transpose', M, K, N-K,
     $                        ONE, C( 1, K+1 ), LDC, V( K+1, 1 ), LDV,
     $                        ONE, WORK, LDWORK )
               END IF
*
*              W := W * T  or  W * T**H
*
               CALL CTRMM( 'Right', 'Upper', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V**H
*
               IF( N.GT.K ) THEN
*
*                 C2 := C2 - W * V2**H
*
                  CALL CGEMM( 'No transpose', 'Conjugate transpose', M,
     $                        N-K, K, -ONE, WORK, LDWORK, V( K+1, 1 ),
     $                        LDV, ONE, C( 1, K+1 ), LDC )
               END IF
*
*              W := W * V1**H
*
               CALL CTRMM( 'Right', 'Lower', 'Conjugate transpose',
     $                     'Unit', M, K, ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W
*
               DO 60 J = 1, K
                  DO 50 I = 1, M
                     C( I, J ) = C( I, J ) - WORK( I, J )
   50             CONTINUE
   60          CONTINUE
            END IF
*
         ELSE
*
*           Let  V =  ( V1 )
*                     ( V2 )    (last K rows)
*           where  V2  is unit upper triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**H * C  where  C = ( C1 )
*                                                  ( C2 )
*
*              W := C**H * V  =  (C1**H * V1 + C2**H * V2)  (stored in WORK)
*
*              W := C2**H
*
               DO 70 J = 1, K
                  CALL CCOPY( N, C( M-K+J, 1 ), LDC, WORK( 1, J ), 1 )
                  CALL CLACGV( N, WORK( 1, J ), 1 )
   70          CONTINUE
*
*              W := W * V2
*
               CALL CTRMM( 'Right', 'Upper', 'No transpose', 'Unit', N,
     $                     K, ONE, V( M-K+1, 1 ), LDV, WORK, LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C1**H * V1
*
                  CALL CGEMM( 'Conjugate transpose', 'No transpose', N,
     $                        K, M-K, ONE, C, LDC, V, LDV, ONE, WORK,
     $                        LDWORK )
               END IF
*
*              W := W * T**H  or  W * T
*
               CALL CTRMM( 'Right', 'Lower', TRANST, 'Non-unit', N, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V * W**H
*
               IF( M.GT.K ) THEN
*
*                 C1 := C1 - V1 * W**H
*
                  CALL CGEMM( 'No transpose', 'Conjugate transpose',
     $                        M-K, N, K, -ONE, V, LDV, WORK, LDWORK,
     $                        ONE, C, LDC )
               END IF
*
*              W := W * V2**H
*
               CALL CTRMM( 'Right', 'Upper', 'Conjugate transpose',
     $                     'Unit', N, K, ONE, V( M-K+1, 1 ), LDV, WORK,
     $                     LDWORK )
*
*              C2 := C2 - W**H
*
               DO 90 J = 1, K
                  DO 80 I = 1, N
                     C( M-K+J, I ) = C( M-K+J, I ) -
     $                               CONJG( WORK( I, J ) )
   80             CONTINUE
   90          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H**H  where  C = ( C1  C2 )
*
*              W := C * V  =  (C1*V1 + C2*V2)  (stored in WORK)
*
*              W := C2
*
               DO 100 J = 1, K
                  CALL CCOPY( M, C( 1, N-K+J ), 1, WORK( 1, J ), 1 )
  100          CONTINUE
*
*              W := W * V2
*
               CALL CTRMM( 'Right', 'Upper', 'No transpose', 'Unit', M,
     $                     K, ONE, V( N-K+1, 1 ), LDV, WORK, LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C1 * V1
*
                  CALL CGEMM( 'No transpose', 'No transpose', M, K, N-K,
     $                        ONE, C, LDC, V, LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T  or  W * T**H
*
               CALL CTRMM( 'Right', 'Lower', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V**H
*
               IF( N.GT.K ) THEN
*
*                 C1 := C1 - W * V1**H
*
                  CALL CGEMM( 'No transpose', 'Conjugate transpose', M,
     $                        N-K, K, -ONE, WORK, LDWORK, V, LDV, ONE,
     $                        C, LDC )
               END IF
*
*              W := W * V2**H
*
               CALL CTRMM( 'Right', 'Upper', 'Conjugate transpose',
     $                     'Unit', M, K, ONE, V( N-K+1, 1 ), LDV, WORK,
     $                     LDWORK )
*
*              C2 := C2 - W
*
               DO 120 J = 1, K
                  DO 110 I = 1, M
                     C( I, N-K+J ) = C( I, N-K+J ) - WORK( I, J )
  110             CONTINUE
  120          CONTINUE
            END IF
         END IF
*
      ELSE IF( LSAME( STOREV, 'R' ) ) THEN
*
         IF( LSAME( DIRECT, 'F' ) ) THEN
*
*           Let  V =  ( V1  V2 )    (V1: first K columns)
*           where  V1  is unit upper triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**H * C  where  C = ( C1 )
*                                                    ( C2 )
*
*              W := C**H * V**H  =  (C1**H * V1**H + C2**H * V2**H) (stored in WORK)
*
*              W := C1**H
*
               DO 130 J = 1, K
                  CALL CCOPY( N, C( J, 1 ), LDC, WORK( 1, J ), 1 )
                  CALL CLACGV( N, WORK( 1, J ), 1 )
  130          CONTINUE
*
*              W := W * V1**H
*
               CALL CTRMM( 'Right', 'Upper', 'Conjugate transpose',
     $                     'Unit', N, K, ONE, V, LDV, WORK, LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C2**H * V2**H
*
                  CALL CGEMM( 'Conjugate transpose',
     $                        'Conjugate transpose', N, K, M-K, ONE,
     $                        C( K+1, 1 ), LDC, V( 1, K+1 ), LDV, ONE,
     $                        WORK, LDWORK )
               END IF
*
*              W := W * T**H  or  W * T
*
               CALL CTRMM( 'Right', 'Upper', TRANST, 'Non-unit', N, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V**H * W**H
*
               IF( M.GT.K ) THEN
*
*                 C2 := C2 - V2**H * W**H
*
                  CALL CGEMM( 'Conjugate transpose',
     $                        'Conjugate transpose', M-K, N, K, -ONE,
     $                        V( 1, K+1 ), LDV, WORK, LDWORK, ONE,
     $                        C( K+1, 1 ), LDC )
               END IF
*
*              W := W * V1
*
               CALL CTRMM( 'Right', 'Upper', 'No transpose', 'Unit', N,
     $                     K, ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W**H
*
               DO 150 J = 1, K
                  DO 140 I = 1, N
                     C( J, I ) = C( J, I ) - CONJG( WORK( I, J ) )
  140             CONTINUE
  150          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H**H  where  C = ( C1  C2 )
*
*              W := C * V**H  =  (C1*V1**H + C2*V2**H)  (stored in WORK)
*
*              W := C1
*
               DO 160 J = 1, K
                  CALL CCOPY( M, C( 1, J ), 1, WORK( 1, J ), 1 )
  160          CONTINUE
*
*              W := W * V1**H
*
               CALL CTRMM( 'Right', 'Upper', 'Conjugate transpose',
     $                     'Unit', M, K, ONE, V, LDV, WORK, LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C2 * V2**H
*
                  CALL CGEMM( 'No transpose', 'Conjugate transpose', M,
     $                        K, N-K, ONE, C( 1, K+1 ), LDC,
     $                        V( 1, K+1 ), LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T  or  W * T**H
*
               CALL CTRMM( 'Right', 'Upper', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V
*
               IF( N.GT.K ) THEN
*
*                 C2 := C2 - W * V2
*
                  CALL CGEMM( 'No transpose', 'No transpose', M, N-K, K,
     $                        -ONE, WORK, LDWORK, V( 1, K+1 ), LDV, ONE,
     $                        C( 1, K+1 ), LDC )
               END IF
*
*              W := W * V1
*
               CALL CTRMM( 'Right', 'Upper', 'No transpose', 'Unit', M,
     $                     K, ONE, V, LDV, WORK, LDWORK )
*
*              C1 := C1 - W
*
               DO 180 J = 1, K
                  DO 170 I = 1, M
                     C( I, J ) = C( I, J ) - WORK( I, J )
  170             CONTINUE
  180          CONTINUE
*
            END IF
*
         ELSE
*
*           Let  V =  ( V1  V2 )    (V2: last K columns)
*           where  V2  is unit lower triangular.
*
            IF( LSAME( SIDE, 'L' ) ) THEN
*
*              Form  H * C  or  H**H * C  where  C = ( C1 )
*                                                    ( C2 )
*
*              W := C**H * V**H  =  (C1**H * V1**H + C2**H * V2**H) (stored in WORK)
*
*              W := C2**H
*
               DO 190 J = 1, K
                  CALL CCOPY( N, C( M-K+J, 1 ), LDC, WORK( 1, J ), 1 )
                  CALL CLACGV( N, WORK( 1, J ), 1 )
  190          CONTINUE
*
*              W := W * V2**H
*
               CALL CTRMM( 'Right', 'Lower', 'Conjugate transpose',
     $                     'Unit', N, K, ONE, V( 1, M-K+1 ), LDV, WORK,
     $                     LDWORK )
               IF( M.GT.K ) THEN
*
*                 W := W + C1**H * V1**H
*
                  CALL CGEMM( 'Conjugate transpose',
     $                        'Conjugate transpose', N, K, M-K, ONE, C,
     $                        LDC, V, LDV, ONE, WORK, LDWORK )
               END IF
*
*              W := W * T**H  or  W * T
*
               CALL CTRMM( 'Right', 'Lower', TRANST, 'Non-unit', N, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - V**H * W**H
*
               IF( M.GT.K ) THEN
*
*                 C1 := C1 - V1**H * W**H
*
                  CALL CGEMM( 'Conjugate transpose',
     $                        'Conjugate transpose', M-K, N, K, -ONE, V,
     $                        LDV, WORK, LDWORK, ONE, C, LDC )
               END IF
*
*              W := W * V2
*
               CALL CTRMM( 'Right', 'Lower', 'No transpose', 'Unit', N,
     $                     K, ONE, V( 1, M-K+1 ), LDV, WORK, LDWORK )
*
*              C2 := C2 - W**H
*
               DO 210 J = 1, K
                  DO 200 I = 1, N
                     C( M-K+J, I ) = C( M-K+J, I ) -
     $                               CONJG( WORK( I, J ) )
  200             CONTINUE
  210          CONTINUE
*
            ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*              Form  C * H  or  C * H**H  where  C = ( C1  C2 )
*
*              W := C * V**H  =  (C1*V1**H + C2*V2**H)  (stored in WORK)
*
*              W := C2
*
               DO 220 J = 1, K
                  CALL CCOPY( M, C( 1, N-K+J ), 1, WORK( 1, J ), 1 )
  220          CONTINUE
*
*              W := W * V2**H
*
               CALL CTRMM( 'Right', 'Lower', 'Conjugate transpose',
     $                     'Unit', M, K, ONE, V( 1, N-K+1 ), LDV, WORK,
     $                     LDWORK )
               IF( N.GT.K ) THEN
*
*                 W := W + C1 * V1**H
*
                  CALL CGEMM( 'No transpose', 'Conjugate transpose', M,
     $                        K, N-K, ONE, C, LDC, V, LDV, ONE, WORK,
     $                        LDWORK )
               END IF
*
*              W := W * T  or  W * T**H
*
               CALL CTRMM( 'Right', 'Lower', TRANS, 'Non-unit', M, K,
     $                     ONE, T, LDT, WORK, LDWORK )
*
*              C := C - W * V
*
               IF( N.GT.K ) THEN
*
*                 C1 := C1 - W * V1
*
                  CALL CGEMM( 'No transpose', 'No transpose', M, N-K, K,
     $                        -ONE, WORK, LDWORK, V, LDV, ONE, C, LDC )
               END IF
*
*              W := W * V2
*
               CALL CTRMM( 'Right', 'Lower', 'No transpose', 'Unit', M,
     $                     K, ONE, V( 1, N-K+1 ), LDV, WORK, LDWORK )
*
*              C1 := C1 - W
*
               DO 240 J = 1, K
                  DO 230 I = 1, M
                     C( I, N-K+J ) = C( I, N-K+J ) - WORK( I, J )
  230             CONTINUE
  240          CONTINUE
*
            END IF
*
         END IF
      END IF
*
      RETURN
*
*     End of CLARFB
*
      END
*> \brief \b CLARFGP generates an elementary reflector (Householder matrix) with non-negative beta.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLARFGP + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clarfgp.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clarfgp.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clarfgp.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLARFGP( N, ALPHA, X, INCX, TAU )
*
*       .. Scalar Arguments ..
*       INTEGER            INCX, N
*       COMPLEX            ALPHA, TAU
*       ..
*       .. Array Arguments ..
*       COMPLEX            X( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLARFGP generates a complex elementary reflector H of order n, such
*> that
*>
*>       H**H * ( alpha ) = ( beta ),   H**H * H = I.
*>              (   x   )   (   0  )
*>
*> where alpha and beta are scalars, beta is real and non-negative, and
*> x is an (n-1)-element complex vector.  H is represented in the form
*>
*>       H = I - tau * ( 1 ) * ( 1 v**H ) ,
*>                     ( v )
*>
*> where tau is a complex scalar and v is a complex (n-1)-element
*> vector. Note that H is not hermitian.
*>
*> If the elements of x are all zero and alpha is real, then tau = 0
*> and H is taken to be the unit matrix.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The order of the elementary reflector.
*> \endverbatim
*>
*> \param[in,out] ALPHA
*> \verbatim
*>          ALPHA is COMPLEX
*>          On entry, the value alpha.
*>          On exit, it is overwritten with the value beta.
*> \endverbatim
*>
*> \param[in,out] X
*> \verbatim
*>          X is COMPLEX array, dimension
*>                         (1+(N-2)*abs(INCX))
*>          On entry, the vector x.
*>          On exit, it is overwritten with the vector v.
*> \endverbatim
*>
*> \param[in] INCX
*> \verbatim
*>          INCX is INTEGER
*>          The increment between elements of X. INCX > 0.
*> \endverbatim
*>
*> \param[out] TAU
*> \verbatim
*>          TAU is COMPLEX
*>          The value tau.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLARFGP( N, ALPHA, X, INCX, TAU )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            INCX, N
      COMPLEX            ALPHA, TAU
*     ..
*     .. Array Arguments ..
      COMPLEX            X( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               TWO, ONE, ZERO
      PARAMETER          ( TWO = 2.0E+0, ONE = 1.0E+0, ZERO = 0.0E+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            J, KNT
      REAL               ALPHI, ALPHR, BETA, BIGNUM, SMLNUM, XNORM
      COMPLEX            SAVEALPHA
*     ..
*     .. External Functions ..
      REAL               SCNRM2, SLAMCH, SLAPY3, SLAPY2
      COMPLEX            CLADIV
      EXTERNAL           SCNRM2, SLAMCH, SLAPY3, SLAPY2, CLADIV
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, AIMAG, CMPLX, REAL, SIGN
*     ..
*     .. External Subroutines ..
      EXTERNAL           CSCAL, CSSCAL
*     ..
*     .. Executable Statements ..
*
      IF( N.LE.0 ) THEN
         TAU = ZERO
         RETURN
      END IF
*
      XNORM = SCNRM2( N-1, X, INCX )
      ALPHR = REAL( ALPHA )
      ALPHI = AIMAG( ALPHA )
*
      IF( XNORM.EQ.ZERO ) THEN
*
*        H  =  [1-alpha/abs(alpha) 0; 0 I], sign chosen so ALPHA >= 0.
*
         IF( ALPHI.EQ.ZERO ) THEN
            IF( ALPHR.GE.ZERO ) THEN
*              When TAU.eq.ZERO, the vector is special-cased to be
*              all zeros in the application routines.  We do not need
*              to clear it.
               TAU = ZERO
            ELSE
*              However, the application routines rely on explicit
*              zero checks when TAU.ne.ZERO, and we must clear X.
               TAU = TWO
               DO J = 1, N-1
                  X( 1 + (J-1)*INCX ) = ZERO
               END DO
               ALPHA = -ALPHA
            END IF
         ELSE
*           Only "reflecting" the diagonal entry to be real and non-negative.
            XNORM = SLAPY2( ALPHR, ALPHI )
            TAU = CMPLX( ONE - ALPHR / XNORM, -ALPHI / XNORM )
            DO J = 1, N-1
               X( 1 + (J-1)*INCX ) = ZERO
            END DO
            ALPHA = XNORM
         END IF
      ELSE
*
*        general case
*
         BETA = SIGN( SLAPY3( ALPHR, ALPHI, XNORM ), ALPHR )
         SMLNUM = SLAMCH( 'S' ) / SLAMCH( 'E' )
         BIGNUM = ONE / SMLNUM
*
         KNT = 0
         IF( ABS( BETA ).LT.SMLNUM ) THEN
*
*           XNORM, BETA may be inaccurate; scale X and recompute them
*
   10       CONTINUE
            KNT = KNT + 1
            CALL CSSCAL( N-1, BIGNUM, X, INCX )
            BETA = BETA*BIGNUM
            ALPHI = ALPHI*BIGNUM
            ALPHR = ALPHR*BIGNUM
            IF( ABS( BETA ).LT.SMLNUM )
     $         GO TO 10
*
*           New BETA is at most 1, at least SMLNUM
*
            XNORM = SCNRM2( N-1, X, INCX )
            ALPHA = CMPLX( ALPHR, ALPHI )
            BETA = SIGN( SLAPY3( ALPHR, ALPHI, XNORM ), ALPHR )
         END IF
         SAVEALPHA = ALPHA
         ALPHA = ALPHA + BETA
         IF( BETA.LT.ZERO ) THEN
            BETA = -BETA
            TAU = -ALPHA / BETA
         ELSE
            ALPHR = ALPHI * (ALPHI/REAL( ALPHA ))
            ALPHR = ALPHR + XNORM * (XNORM/REAL( ALPHA ))
            TAU = CMPLX( ALPHR/BETA, -ALPHI/BETA )
            ALPHA = CMPLX( -ALPHR, ALPHI )
         END IF
         ALPHA = CLADIV( CMPLX( ONE ), ALPHA )
*
         IF ( ABS(TAU).LE.SMLNUM ) THEN
*
*           In the case where the computed TAU ends up being a denormalized number,
*           it loses relative accuracy. This is a BIG problem. Solution: flush TAU
*           to ZERO (or TWO or whatever makes a nonnegative real number for BETA).
*
*           (Bug report provided by Pat Quillen from MathWorks on Jul 29, 2009.)
*           (Thanks Pat. Thanks MathWorks.)
*
            ALPHR = REAL( SAVEALPHA )
            ALPHI = AIMAG( SAVEALPHA )
            IF( ALPHI.EQ.ZERO ) THEN
               IF( ALPHR.GE.ZERO ) THEN
                  TAU = ZERO
               ELSE
                  TAU = TWO
                  DO J = 1, N-1
                     X( 1 + (J-1)*INCX ) = ZERO
                  END DO
                  BETA = -SAVEALPHA
               END IF
            ELSE
               XNORM = SLAPY2( ALPHR, ALPHI )
               TAU = CMPLX( ONE - ALPHR / XNORM, -ALPHI / XNORM )
               DO J = 1, N-1
                  X( 1 + (J-1)*INCX ) = ZERO
               END DO
               BETA = XNORM
            END IF
*
         ELSE
*
*           This is the general case.
*
            CALL CSCAL( N-1, ALPHA, X, INCX )
*
         END IF
*
*        If BETA is subnormal, it may lose relative accuracy
*
         DO 20 J = 1, KNT
            BETA = BETA*SMLNUM
 20      CONTINUE
         ALPHA = BETA
      END IF
*
      RETURN
*
*     End of CLARFGP
*
      END
*> \brief \b CLARFT forms the triangular factor T of a block reflector H = I - vtvH
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLARFT + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clarft.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clarft.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clarft.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLARFT( DIRECT, STOREV, N, K, V, LDV, TAU, T, LDT )
*
*       .. Scalar Arguments ..
*       CHARACTER          DIRECT, STOREV
*       INTEGER            K, LDT, LDV, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            T( LDT, * ), TAU( * ), V( LDV, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLARFT forms the triangular factor T of a complex block reflector H
*> of order n, which is defined as a product of k elementary reflectors.
*>
*> If DIRECT = 'F', H = H(1) H(2) . . . H(k) and T is upper triangular;
*>
*> If DIRECT = 'B', H = H(k) . . . H(2) H(1) and T is lower triangular.
*>
*> If STOREV = 'C', the vector which defines the elementary reflector
*> H(i) is stored in the i-th column of the array V, and
*>
*>    H  =  I - V * T * V**H
*>
*> If STOREV = 'R', the vector which defines the elementary reflector
*> H(i) is stored in the i-th row of the array V, and
*>
*>    H  =  I - V**H * T * V
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] DIRECT
*> \verbatim
*>          DIRECT is CHARACTER*1
*>          Specifies the order in which the elementary reflectors are
*>          multiplied to form the block reflector:
*>          = 'F': H = H(1) H(2) . . . H(k) (Forward)
*>          = 'B': H = H(k) . . . H(2) H(1) (Backward)
*> \endverbatim
*>
*> \param[in] STOREV
*> \verbatim
*>          STOREV is CHARACTER*1
*>          Specifies how the vectors which define the elementary
*>          reflectors are stored (see also Further Details):
*>          = 'C': columnwise
*>          = 'R': rowwise
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The order of the block reflector H. N >= 0.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The order of the triangular factor T (= the number of
*>          elementary reflectors). K >= 1.
*> \endverbatim
*>
*> \param[in] V
*> \verbatim
*>          V is COMPLEX array, dimension
*>                               (LDV,K) if STOREV = 'C'
*>                               (LDV,N) if STOREV = 'R'
*>          The matrix V. See further details.
*> \endverbatim
*>
*> \param[in] LDV
*> \verbatim
*>          LDV is INTEGER
*>          The leading dimension of the array V.
*>          If STOREV = 'C', LDV >= max(1,N); if STOREV = 'R', LDV >= K.
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX array, dimension (K)
*>          TAU(i) must contain the scalar factor of the elementary
*>          reflector H(i).
*> \endverbatim
*>
*> \param[out] T
*> \verbatim
*>          T is COMPLEX array, dimension (LDT,K)
*>          The k by k triangular factor T of the block reflector.
*>          If DIRECT = 'F', T is upper triangular; if DIRECT = 'B', T is
*>          lower triangular. The rest of the array is not used.
*> \endverbatim
*>
*> \param[in] LDT
*> \verbatim
*>          LDT is INTEGER
*>          The leading dimension of the array T. LDT >= K.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  The shape of the matrix V and the storage of the vectors which define
*>  the H(i) is best illustrated by the following example with n = 5 and
*>  k = 3. The elements equal to 1 are not stored.
*>
*>  DIRECT = 'F' and STOREV = 'C':         DIRECT = 'F' and STOREV = 'R':
*>
*>               V = (  1       )                 V = (  1 v1 v1 v1 v1 )
*>                   ( v1  1    )                     (     1 v2 v2 v2 )
*>                   ( v1 v2  1 )                     (        1 v3 v3 )
*>                   ( v1 v2 v3 )
*>                   ( v1 v2 v3 )
*>
*>  DIRECT = 'B' and STOREV = 'C':         DIRECT = 'B' and STOREV = 'R':
*>
*>               V = ( v1 v2 v3 )                 V = ( v1 v1  1       )
*>                   ( v1 v2 v3 )                     ( v2 v2 v2  1    )
*>                   (  1 v2 v3 )                     ( v3 v3 v3 v3  1 )
*>                   (     1 v3 )
*>                   (        1 )
*> \endverbatim
*>
*  =====================================================================
      SUBROUTINE CLARFT( DIRECT, STOREV, N, K, V, LDV, TAU, T, LDT )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          DIRECT, STOREV
      INTEGER            K, LDT, LDV, N
*     ..
*     .. Array Arguments ..
      COMPLEX            T( LDT, * ), TAU( * ), V( LDV, * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ONE, ZERO
      PARAMETER          ( ONE = ( 1.0E+0, 0.0E+0 ),
     $                   ZERO = ( 0.0E+0, 0.0E+0 ) )
*     ..
*     .. Local Scalars ..
      INTEGER            I, J, PREVLASTV, LASTV
*     ..
*     .. External Subroutines ..
      EXTERNAL           CGEMM, CGEMV, CTRMV
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. Executable Statements ..
*
*     Quick return if possible
*
      IF( N.EQ.0 )
     $   RETURN
*
      IF( LSAME( DIRECT, 'F' ) ) THEN
         PREVLASTV = N
         DO I = 1, K
            PREVLASTV = MAX( PREVLASTV, I )
            IF( TAU( I ).EQ.ZERO ) THEN
*
*              H(i)  =  I
*
               DO J = 1, I
                  T( J, I ) = ZERO
               END DO
            ELSE
*
*              general case
*
               IF( LSAME( STOREV, 'C' ) ) THEN
*                 Skip any trailing zeros.
                  DO LASTV = N, I+1, -1
                     IF( V( LASTV, I ).NE.ZERO ) EXIT
                  END DO
                  DO J = 1, I-1
                     T( J, I ) = -TAU( I ) * CONJG( V( I , J ) )
                  END DO
                  J = MIN( LASTV, PREVLASTV )
*
*                 T(1:i-1,i) := - tau(i) * V(i:j,1:i-1)**H * V(i:j,i)
*
                  CALL CGEMV( 'Conjugate transpose', J-I, I-1,
     $                        -TAU( I ), V( I+1, 1 ), LDV,
     $                        V( I+1, I ), 1,
     $                        ONE, T( 1, I ), 1 )
               ELSE
*                 Skip any trailing zeros.
                  DO LASTV = N, I+1, -1
                     IF( V( I, LASTV ).NE.ZERO ) EXIT
                  END DO
                  DO J = 1, I-1
                     T( J, I ) = -TAU( I ) * V( J , I )
                  END DO
                  J = MIN( LASTV, PREVLASTV )
*
*                 T(1:i-1,i) := - tau(i) * V(1:i-1,i:j) * V(i,i:j)**H
*
                  CALL CGEMM( 'N', 'C', I-1, 1, J-I, -TAU( I ),
     $                        V( 1, I+1 ), LDV, V( I, I+1 ), LDV,
     $                        ONE, T( 1, I ), LDT )
               END IF
*
*              T(1:i-1,i) := T(1:i-1,1:i-1) * T(1:i-1,i)
*
               CALL CTRMV( 'Upper', 'No transpose', 'Non-unit', I-1, T,
     $                     LDT, T( 1, I ), 1 )
               T( I, I ) = TAU( I )
               IF( I.GT.1 ) THEN
                  PREVLASTV = MAX( PREVLASTV, LASTV )
               ELSE
                  PREVLASTV = LASTV
               END IF
            END IF
         END DO
      ELSE
         PREVLASTV = 1
         DO I = K, 1, -1
            IF( TAU( I ).EQ.ZERO ) THEN
*
*              H(i)  =  I
*
               DO J = I, K
                  T( J, I ) = ZERO
               END DO
            ELSE
*
*              general case
*
               IF( I.LT.K ) THEN
                  IF( LSAME( STOREV, 'C' ) ) THEN
*                    Skip any leading zeros.
                     DO LASTV = 1, I-1
                        IF( V( LASTV, I ).NE.ZERO ) EXIT
                     END DO
                     DO J = I+1, K
                        T( J, I ) = -TAU( I ) * CONJG( V( N-K+I , J ) )
                     END DO
                     J = MAX( LASTV, PREVLASTV )
*
*                    T(i+1:k,i) = -tau(i) * V(j:n-k+i,i+1:k)**H * V(j:n-k+i,i)
*
                     CALL CGEMV( 'Conjugate transpose', N-K+I-J, K-I,
     $                           -TAU( I ), V( J, I+1 ), LDV, V( J, I ),
     $                           1, ONE, T( I+1, I ), 1 )
                  ELSE
*                    Skip any leading zeros.
                     DO LASTV = 1, I-1
                        IF( V( I, LASTV ).NE.ZERO ) EXIT
                     END DO
                     DO J = I+1, K
                        T( J, I ) = -TAU( I ) * V( J, N-K+I )
                     END DO
                     J = MAX( LASTV, PREVLASTV )
*
*                    T(i+1:k,i) = -tau(i) * V(i+1:k,j:n-k+i) * V(i,j:n-k+i)**H
*
                     CALL CGEMM( 'N', 'C', K-I, 1, N-K+I-J, -TAU( I ),
     $                           V( I+1, J ), LDV, V( I, J ), LDV,
     $                           ONE, T( I+1, I ), LDT )
                  END IF
*
*                 T(i+1:k,i) := T(i+1:k,i+1:k) * T(i+1:k,i)
*
                  CALL CTRMV( 'Lower', 'No transpose', 'Non-unit', K-I,
     $                        T( I+1, I+1 ), LDT, T( I+1, I ), 1 )
                  IF( I.GT.1 ) THEN
                     PREVLASTV = MIN( PREVLASTV, LASTV )
                  ELSE
                     PREVLASTV = LASTV
                  END IF
               END IF
               T( I, I ) = TAU( I )
            END IF
         END DO
      END IF
      RETURN
*
*     End of CLARFT
*
      END
*> \brief \b CLASR applies a sequence of plane rotations to a general rectangular matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLASR + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clasr.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clasr.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clasr.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLASR( SIDE, PIVOT, DIRECT, M, N, C, S, A, LDA )
*
*       .. Scalar Arguments ..
*       CHARACTER          DIRECT, PIVOT, SIDE
*       INTEGER            LDA, M, N
*       ..
*       .. Array Arguments ..
*       REAL               C( * ), S( * )
*       COMPLEX            A( LDA, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLASR applies a sequence of real plane rotations to a complex matrix
*> A, from either the left or the right.
*>
*> When SIDE = 'L', the transformation takes the form
*>
*>    A := P*A
*>
*> and when SIDE = 'R', the transformation takes the form
*>
*>    A := A*P**T
*>
*> where P is an orthogonal matrix consisting of a sequence of z plane
*> rotations, with z = M when SIDE = 'L' and z = N when SIDE = 'R',
*> and P**T is the transpose of P.
*>
*> When DIRECT = 'F' (Forward sequence), then
*>
*>    P = P(z-1) * ... * P(2) * P(1)
*>
*> and when DIRECT = 'B' (Backward sequence), then
*>
*>    P = P(1) * P(2) * ... * P(z-1)
*>
*> where P(k) is a plane rotation matrix defined by the 2-by-2 rotation
*>
*>    R(k) = (  c(k)  s(k) )
*>         = ( -s(k)  c(k) ).
*>
*> When PIVOT = 'V' (Variable pivot), the rotation is performed
*> for the plane (k,k+1), i.e., P(k) has the form
*>
*>    P(k) = (  1                                            )
*>           (       ...                                     )
*>           (              1                                )
*>           (                   c(k)  s(k)                  )
*>           (                  -s(k)  c(k)                  )
*>           (                                1              )
*>           (                                     ...       )
*>           (                                            1  )
*>
*> where R(k) appears as a rank-2 modification to the identity matrix in
*> rows and columns k and k+1.
*>
*> When PIVOT = 'T' (Top pivot), the rotation is performed for the
*> plane (1,k+1), so P(k) has the form
*>
*>    P(k) = (  c(k)                    s(k)                 )
*>           (         1                                     )
*>           (              ...                              )
*>           (                     1                         )
*>           ( -s(k)                    c(k)                 )
*>           (                                 1             )
*>           (                                      ...      )
*>           (                                             1 )
*>
*> where R(k) appears in rows and columns 1 and k+1.
*>
*> Similarly, when PIVOT = 'B' (Bottom pivot), the rotation is
*> performed for the plane (k,z), giving P(k) the form
*>
*>    P(k) = ( 1                                             )
*>           (      ...                                      )
*>           (             1                                 )
*>           (                  c(k)                    s(k) )
*>           (                         1                     )
*>           (                              ...              )
*>           (                                     1         )
*>           (                 -s(k)                    c(k) )
*>
*> where R(k) appears in rows and columns k and z.  The rotations are
*> performed without ever forming P(k) explicitly.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] SIDE
*> \verbatim
*>          SIDE is CHARACTER*1
*>          Specifies whether the plane rotation matrix P is applied to
*>          A on the left or the right.
*>          = 'L':  Left, compute A := P*A
*>          = 'R':  Right, compute A:= A*P**T
*> \endverbatim
*>
*> \param[in] PIVOT
*> \verbatim
*>          PIVOT is CHARACTER*1
*>          Specifies the plane for which P(k) is a plane rotation
*>          matrix.
*>          = 'V':  Variable pivot, the plane (k,k+1)
*>          = 'T':  Top pivot, the plane (1,k+1)
*>          = 'B':  Bottom pivot, the plane (k,z)
*> \endverbatim
*>
*> \param[in] DIRECT
*> \verbatim
*>          DIRECT is CHARACTER*1
*>          Specifies whether P is a forward or backward sequence of
*>          plane rotations.
*>          = 'F':  Forward, P = P(z-1)*...*P(2)*P(1)
*>          = 'B':  Backward, P = P(1)*P(2)*...*P(z-1)
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix A.  If m <= 1, an immediate
*>          return is effected.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix A.  If n <= 1, an
*>          immediate return is effected.
*> \endverbatim
*>
*> \param[in] C
*> \verbatim
*>          C is REAL array, dimension
*>                  (M-1) if SIDE = 'L'
*>                  (N-1) if SIDE = 'R'
*>          The cosines c(k) of the plane rotations.
*> \endverbatim
*>
*> \param[in] S
*> \verbatim
*>          S is REAL array, dimension
*>                  (M-1) if SIDE = 'L'
*>                  (N-1) if SIDE = 'R'
*>          The sines s(k) of the plane rotations.  The 2-by-2 plane
*>          rotation part of the matrix P(k), R(k), has the form
*>          R(k) = (  c(k)  s(k) )
*>                 ( -s(k)  c(k) ).
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          The M-by-N matrix A.  On exit, A is overwritten by P*A if
*>          SIDE = 'R' or by A*P**T if SIDE = 'L'.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A.  LDA >= max(1,M).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLASR( SIDE, PIVOT, DIRECT, M, N, C, S, A, LDA )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          DIRECT, PIVOT, SIDE
      INTEGER            LDA, M, N
*     ..
*     .. Array Arguments ..
      REAL               C( * ), S( * )
      COMPLEX            A( LDA, * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ONE, ZERO
      PARAMETER          ( ONE = 1.0E+0, ZERO = 0.0E+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I, INFO, J
      REAL               CTEMP, STEMP
      COMPLEX            TEMP
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. External Subroutines ..
      EXTERNAL           XERBLA
*     ..
*     .. Executable Statements ..
*
*     Test the input parameters
*
      INFO = 0
      IF( .NOT.( LSAME( SIDE, 'L' ) .OR. LSAME( SIDE, 'R' ) ) ) THEN
         INFO = 1
      ELSE IF( .NOT.( LSAME( PIVOT, 'V' ) .OR. LSAME( PIVOT,
     $         'T' ) .OR. LSAME( PIVOT, 'B' ) ) ) THEN
         INFO = 2
      ELSE IF( .NOT.( LSAME( DIRECT, 'F' ) .OR. LSAME( DIRECT, 'B' ) ) )
     $          THEN
         INFO = 3
      ELSE IF( M.LT.0 ) THEN
         INFO = 4
      ELSE IF( N.LT.0 ) THEN
         INFO = 5
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = 9
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'CLASR ', INFO )
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( ( M.EQ.0 ) .OR. ( N.EQ.0 ) )
     $   RETURN
      IF( LSAME( SIDE, 'L' ) ) THEN
*
*        Form  P * A
*
         IF( LSAME( PIVOT, 'V' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 20 J = 1, M - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 10 I = 1, N
                        TEMP = A( J+1, I )
                        A( J+1, I ) = CTEMP*TEMP - STEMP*A( J, I )
                        A( J, I ) = STEMP*TEMP + CTEMP*A( J, I )
   10                CONTINUE
                  END IF
   20          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 40 J = M - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 30 I = 1, N
                        TEMP = A( J+1, I )
                        A( J+1, I ) = CTEMP*TEMP - STEMP*A( J, I )
                        A( J, I ) = STEMP*TEMP + CTEMP*A( J, I )
   30                CONTINUE
                  END IF
   40          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'T' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 60 J = 2, M
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 50 I = 1, N
                        TEMP = A( J, I )
                        A( J, I ) = CTEMP*TEMP - STEMP*A( 1, I )
                        A( 1, I ) = STEMP*TEMP + CTEMP*A( 1, I )
   50                CONTINUE
                  END IF
   60          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 80 J = M, 2, -1
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 70 I = 1, N
                        TEMP = A( J, I )
                        A( J, I ) = CTEMP*TEMP - STEMP*A( 1, I )
                        A( 1, I ) = STEMP*TEMP + CTEMP*A( 1, I )
   70                CONTINUE
                  END IF
   80          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'B' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 100 J = 1, M - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 90 I = 1, N
                        TEMP = A( J, I )
                        A( J, I ) = STEMP*A( M, I ) + CTEMP*TEMP
                        A( M, I ) = CTEMP*A( M, I ) - STEMP*TEMP
   90                CONTINUE
                  END IF
  100          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 120 J = M - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 110 I = 1, N
                        TEMP = A( J, I )
                        A( J, I ) = STEMP*A( M, I ) + CTEMP*TEMP
                        A( M, I ) = CTEMP*A( M, I ) - STEMP*TEMP
  110                CONTINUE
                  END IF
  120          CONTINUE
            END IF
         END IF
      ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*        Form A * P**T
*
         IF( LSAME( PIVOT, 'V' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 140 J = 1, N - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 130 I = 1, M
                        TEMP = A( I, J+1 )
                        A( I, J+1 ) = CTEMP*TEMP - STEMP*A( I, J )
                        A( I, J ) = STEMP*TEMP + CTEMP*A( I, J )
  130                CONTINUE
                  END IF
  140          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 160 J = N - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 150 I = 1, M
                        TEMP = A( I, J+1 )
                        A( I, J+1 ) = CTEMP*TEMP - STEMP*A( I, J )
                        A( I, J ) = STEMP*TEMP + CTEMP*A( I, J )
  150                CONTINUE
                  END IF
  160          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'T' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 180 J = 2, N
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 170 I = 1, M
                        TEMP = A( I, J )
                        A( I, J ) = CTEMP*TEMP - STEMP*A( I, 1 )
                        A( I, 1 ) = STEMP*TEMP + CTEMP*A( I, 1 )
  170                CONTINUE
                  END IF
  180          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 200 J = N, 2, -1
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 190 I = 1, M
                        TEMP = A( I, J )
                        A( I, J ) = CTEMP*TEMP - STEMP*A( I, 1 )
                        A( I, 1 ) = STEMP*TEMP + CTEMP*A( I, 1 )
  190                CONTINUE
                  END IF
  200          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'B' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 220 J = 1, N - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 210 I = 1, M
                        TEMP = A( I, J )
                        A( I, J ) = STEMP*A( I, N ) + CTEMP*TEMP
                        A( I, N ) = CTEMP*A( I, N ) - STEMP*TEMP
  210                CONTINUE
                  END IF
  220          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 240 J = N - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     DO 230 I = 1, M
                        TEMP = A( I, J )
                        A( I, J ) = STEMP*A( I, N ) + CTEMP*TEMP
                        A( I, N ) = CTEMP*A( I, N ) - STEMP*TEMP
  230                CONTINUE
                  END IF
  240          CONTINUE
            END IF
         END IF
      END IF
*
      RETURN
*
*     End of CLASR
*
      END
*> \brief \b CUNBDB
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CUNBDB + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cunbdb.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cunbdb.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cunbdb.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CUNBDB( TRANS, SIGNS, M, P, Q, X11, LDX11, X12, LDX12,
*                          X21, LDX21, X22, LDX22, THETA, PHI, TAUP1,
*                          TAUP2, TAUQ1, TAUQ2, WORK, LWORK, INFO )
*
*       .. Scalar Arguments ..
*       CHARACTER          SIGNS, TRANS
*       INTEGER            INFO, LDX11, LDX12, LDX21, LDX22, LWORK, M, P,
*      $                   Q
*       ..
*       .. Array Arguments ..
*       REAL               PHI( * ), THETA( * )
*       COMPLEX            TAUP1( * ), TAUP2( * ), TAUQ1( * ), TAUQ2( * ),
*      $                   WORK( * ), X11( LDX11, * ), X12( LDX12, * ),
*      $                   X21( LDX21, * ), X22( LDX22, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CUNBDB simultaneously bidiagonalizes the blocks of an M-by-M
*> partitioned unitary matrix X:
*>
*>                                 [ B11 | B12 0  0 ]
*>     [ X11 | X12 ]   [ P1 |    ] [  0  |  0 -I  0 ] [ Q1 |    ]**H
*> X = [-----------] = [---------] [----------------] [---------]   .
*>     [ X21 | X22 ]   [    | P2 ] [ B21 | B22 0  0 ] [    | Q2 ]
*>                                 [  0  |  0  0  I ]
*>
*> X11 is P-by-Q. Q must be no larger than P, M-P, or M-Q. (If this is
*> not the case, then X must be transposed and/or permuted. This can be
*> done in constant time using the TRANS and SIGNS options. See CUNCSD
*> for details.)
*>
*> The unitary matrices P1, P2, Q1, and Q2 are P-by-P, (M-P)-by-
*> (M-P), Q-by-Q, and (M-Q)-by-(M-Q), respectively. They are
*> represented implicitly by Householder vectors.
*>
*> B11, B12, B21, and B22 are Q-by-Q bidiagonal matrices represented
*> implicitly by angles THETA, PHI.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] TRANS
*> \verbatim
*>          TRANS is CHARACTER
*>          = 'T':      X, U1, U2, V1T, and V2T are stored in row-major
*>                      order;
*>          otherwise:  X, U1, U2, V1T, and V2T are stored in column-
*>                      major order.
*> \endverbatim
*>
*> \param[in] SIGNS
*> \verbatim
*>          SIGNS is CHARACTER
*>          = 'O':      The lower-left block is made nonpositive (the
*>                      "other" convention);
*>          otherwise:  The upper-right block is made nonpositive (the
*>                      "default" convention).
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows and columns in X.
*> \endverbatim
*>
*> \param[in] P
*> \verbatim
*>          P is INTEGER
*>          The number of rows in X11 and X12. 0 <= P <= M.
*> \endverbatim
*>
*> \param[in] Q
*> \verbatim
*>          Q is INTEGER
*>          The number of columns in X11 and X21. 0 <= Q <=
*>          MIN(P,M-P,M-Q).
*> \endverbatim
*>
*> \param[in,out] X11
*> \verbatim
*>          X11 is COMPLEX array, dimension (LDX11,Q)
*>          On entry, the top-left block of the unitary matrix to be
*>          reduced. On exit, the form depends on TRANS:
*>          If TRANS = 'N', then
*>             the columns of tril(X11) specify reflectors for P1,
*>             the rows of triu(X11,1) specify reflectors for Q1;
*>          else TRANS = 'T', and
*>             the rows of triu(X11) specify reflectors for P1,
*>             the columns of tril(X11,-1) specify reflectors for Q1.
*> \endverbatim
*>
*> \param[in] LDX11
*> \verbatim
*>          LDX11 is INTEGER
*>          The leading dimension of X11. If TRANS = 'N', then LDX11 >=
*>          P; else LDX11 >= Q.
*> \endverbatim
*>
*> \param[in,out] X12
*> \verbatim
*>          X12 is COMPLEX array, dimension (LDX12,M-Q)
*>          On entry, the top-right block of the unitary matrix to
*>          be reduced. On exit, the form depends on TRANS:
*>          If TRANS = 'N', then
*>             the rows of triu(X12) specify the first P reflectors for
*>             Q2;
*>          else TRANS = 'T', and
*>             the columns of tril(X12) specify the first P reflectors
*>             for Q2.
*> \endverbatim
*>
*> \param[in] LDX12
*> \verbatim
*>          LDX12 is INTEGER
*>          The leading dimension of X12. If TRANS = 'N', then LDX12 >=
*>          P; else LDX11 >= M-Q.
*> \endverbatim
*>
*> \param[in,out] X21
*> \verbatim
*>          X21 is COMPLEX array, dimension (LDX21,Q)
*>          On entry, the bottom-left block of the unitary matrix to
*>          be reduced. On exit, the form depends on TRANS:
*>          If TRANS = 'N', then
*>             the columns of tril(X21) specify reflectors for P2;
*>          else TRANS = 'T', and
*>             the rows of triu(X21) specify reflectors for P2.
*> \endverbatim
*>
*> \param[in] LDX21
*> \verbatim
*>          LDX21 is INTEGER
*>          The leading dimension of X21. If TRANS = 'N', then LDX21 >=
*>          M-P; else LDX21 >= Q.
*> \endverbatim
*>
*> \param[in,out] X22
*> \verbatim
*>          X22 is COMPLEX array, dimension (LDX22,M-Q)
*>          On entry, the bottom-right block of the unitary matrix to
*>          be reduced. On exit, the form depends on TRANS:
*>          If TRANS = 'N', then
*>             the rows of triu(X22(Q+1:M-P,P+1:M-Q)) specify the last
*>             M-P-Q reflectors for Q2,
*>          else TRANS = 'T', and
*>             the columns of tril(X22(P+1:M-Q,Q+1:M-P)) specify the last
*>             M-P-Q reflectors for P2.
*> \endverbatim
*>
*> \param[in] LDX22
*> \verbatim
*>          LDX22 is INTEGER
*>          The leading dimension of X22. If TRANS = 'N', then LDX22 >=
*>          M-P; else LDX22 >= M-Q.
*> \endverbatim
*>
*> \param[out] THETA
*> \verbatim
*>          THETA is REAL array, dimension (Q)
*>          The entries of the bidiagonal blocks B11, B12, B21, B22 can
*>          be computed from the angles THETA and PHI. See Further
*>          Details.
*> \endverbatim
*>
*> \param[out] PHI
*> \verbatim
*>          PHI is REAL array, dimension (Q-1)
*>          The entries of the bidiagonal blocks B11, B12, B21, B22 can
*>          be computed from the angles THETA and PHI. See Further
*>          Details.
*> \endverbatim
*>
*> \param[out] TAUP1
*> \verbatim
*>          TAUP1 is COMPLEX array, dimension (P)
*>          The scalar factors of the elementary reflectors that define
*>          P1.
*> \endverbatim
*>
*> \param[out] TAUP2
*> \verbatim
*>          TAUP2 is COMPLEX array, dimension (M-P)
*>          The scalar factors of the elementary reflectors that define
*>          P2.
*> \endverbatim
*>
*> \param[out] TAUQ1
*> \verbatim
*>          TAUQ1 is COMPLEX array, dimension (Q)
*>          The scalar factors of the elementary reflectors that define
*>          Q1.
*> \endverbatim
*>
*> \param[out] TAUQ2
*> \verbatim
*>          TAUQ2 is COMPLEX array, dimension (M-Q)
*>          The scalar factors of the elementary reflectors that define
*>          Q2.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (LWORK)
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          LWORK is INTEGER
*>          The dimension of the array WORK. LWORK >= M-Q.
*>
*>          If LWORK = -1, then a workspace query is assumed; the routine
*>          only calculates the optimal size of the WORK array, returns
*>          this value as the first entry of the WORK array, and no error
*>          message related to LWORK is issued by XERBLA.
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit.
*>          < 0:  if INFO = -i, the i-th argument had an illegal value.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERcomputational
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  The bidiagonal blocks B11, B12, B21, and B22 are represented
*>  implicitly by angles THETA(1), ..., THETA(Q) and PHI(1), ...,
*>  PHI(Q-1). B11 and B21 are upper bidiagonal, while B21 and B22 are
*>  lower bidiagonal. Every entry in each bidiagonal band is a product
*>  of a sine or cosine of a THETA with a sine or cosine of a PHI. See
*>  [1] or CUNCSD for details.
*>
*>  P1, P2, Q1, and Q2 are represented as products of elementary
*>  reflectors. See CUNCSD for details on generating P1, P2, Q1, and Q2
*>  using CUNGQR and CUNGLQ.
*> \endverbatim
*
*> \par References:
*  ================
*>
*>  [1] Brian D. Sutton. Computing the complete CS decomposition. Numer.
*>      Algorithms, 50(1):33-65, 2009.
*>
*  =====================================================================
      SUBROUTINE CUNBDB( TRANS, SIGNS, M, P, Q, X11, LDX11, X12, LDX12,
     $                   X21, LDX21, X22, LDX22, THETA, PHI, TAUP1,
     $                   TAUP2, TAUQ1, TAUQ2, WORK, LWORK, INFO )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          SIGNS, TRANS
      INTEGER            INFO, LDX11, LDX12, LDX21, LDX22, LWORK, M, P,
     $                   Q
*     ..
*     .. Array Arguments ..
      REAL               PHI( * ), THETA( * )
      COMPLEX            TAUP1( * ), TAUP2( * ), TAUQ1( * ), TAUQ2( * ),
     $                   WORK( * ), X11( LDX11, * ), X12( LDX12, * ),
     $                   X21( LDX21, * ), X22( LDX22, * )
*     ..
*
*  ====================================================================
*
*     .. Parameters ..
      REAL               REALONE
      PARAMETER          ( REALONE = 1.0E0 )
      COMPLEX            ONE
      PARAMETER          ( ONE = (1.0E0,0.0E0) )
*     ..
*     .. Local Scalars ..
      LOGICAL            COLMAJOR, LQUERY
      INTEGER            I, LWORKMIN, LWORKOPT
      REAL               Z1, Z2, Z3, Z4
*     ..
*     .. External Subroutines ..
      EXTERNAL           CAXPY, CLARF, CLARFGP, CSCAL, XERBLA
      EXTERNAL           CLACGV
*
*     ..
*     .. External Functions ..
      REAL               SCNRM2
      LOGICAL            LSAME
      EXTERNAL           SCNRM2, LSAME
*     ..
*     .. Intrinsic Functions
      INTRINSIC          ATAN2, COS, MAX, MIN, SIN
      INTRINSIC          CMPLX, CONJG
*     ..
*     .. Executable Statements ..
*
*     Test input arguments
*
      INFO = 0
      COLMAJOR = .NOT. LSAME( TRANS, 'T' )
      IF( .NOT. LSAME( SIGNS, 'O' ) ) THEN
         Z1 = REALONE
         Z2 = REALONE
         Z3 = REALONE
         Z4 = REALONE
      ELSE
         Z1 = REALONE
         Z2 = -REALONE
         Z3 = REALONE
         Z4 = -REALONE
      END IF
      LQUERY = LWORK .EQ. -1
*
      IF( M .LT. 0 ) THEN
         INFO = -3
      ELSE IF( P .LT. 0 .OR. P .GT. M ) THEN
         INFO = -4
      ELSE IF( Q .LT. 0 .OR. Q .GT. P .OR. Q .GT. M-P .OR.
     $         Q .GT. M-Q ) THEN
         INFO = -5
      ELSE IF( COLMAJOR .AND. LDX11 .LT. MAX( 1, P ) ) THEN
         INFO = -7
      ELSE IF( .NOT.COLMAJOR .AND. LDX11 .LT. MAX( 1, Q ) ) THEN
         INFO = -7
      ELSE IF( COLMAJOR .AND. LDX12 .LT. MAX( 1, P ) ) THEN
         INFO = -9
      ELSE IF( .NOT.COLMAJOR .AND. LDX12 .LT. MAX( 1, M-Q ) ) THEN
         INFO = -9
      ELSE IF( COLMAJOR .AND. LDX21 .LT. MAX( 1, M-P ) ) THEN
         INFO = -11
      ELSE IF( .NOT.COLMAJOR .AND. LDX21 .LT. MAX( 1, Q ) ) THEN
         INFO = -11
      ELSE IF( COLMAJOR .AND. LDX22 .LT. MAX( 1, M-P ) ) THEN
         INFO = -13
      ELSE IF( .NOT.COLMAJOR .AND. LDX22 .LT. MAX( 1, M-Q ) ) THEN
         INFO = -13
      END IF
*
*     Compute workspace
*
      IF( INFO .EQ. 0 ) THEN
         LWORKOPT = M - Q
         LWORKMIN = M - Q
         WORK(1) = LWORKOPT
         IF( LWORK .LT. LWORKMIN .AND. .NOT. LQUERY ) THEN
            INFO = -21
         END IF
      END IF
      IF( INFO .NE. 0 ) THEN
         CALL XERBLA( 'xORBDB', -INFO )
         RETURN
      ELSE IF( LQUERY ) THEN
         RETURN
      END IF
*
*     Handle column-major and row-major separately
*
      IF( COLMAJOR ) THEN
*
*        Reduce columns 1, ..., Q of X11, X12, X21, and X22
*
         DO I = 1, Q
*
            IF( I .EQ. 1 ) THEN
               CALL CSCAL( P-I+1, CMPLX( Z1, 0.0E0 ), X11(I,I), 1 )
            ELSE
               CALL CSCAL( P-I+1, CMPLX( Z1*COS(PHI(I-1)), 0.0E0 ),
     $                     X11(I,I), 1 )
               CALL CAXPY( P-I+1, CMPLX( -Z1*Z3*Z4*SIN(PHI(I-1)),
     $                     0.0E0 ), X12(I,I-1), 1, X11(I,I), 1 )
            END IF
            IF( I .EQ. 1 ) THEN
               CALL CSCAL( M-P-I+1, CMPLX( Z2, 0.0E0 ), X21(I,I), 1 )
            ELSE
               CALL CSCAL( M-P-I+1, CMPLX( Z2*COS(PHI(I-1)), 0.0E0 ),
     $                     X21(I,I), 1 )
               CALL CAXPY( M-P-I+1, CMPLX( -Z2*Z3*Z4*SIN(PHI(I-1)),
     $                     0.0E0 ), X22(I,I-1), 1, X21(I,I), 1 )
            END IF
*
            THETA(I) = ATAN2( SCNRM2( M-P-I+1, X21(I,I), 1 ),
     $                 SCNRM2( P-I+1, X11(I,I), 1 ) )
*
            IF( P .GT. I ) THEN
               CALL CLARFGP( P-I+1, X11(I,I), X11(I+1,I), 1, TAUP1(I) )
            ELSE IF ( P .EQ. I ) THEN
               CALL CLARFGP( P-I+1, X11(I,I), X11(I,I), 1, TAUP1(I) )
            END IF
            X11(I,I) = ONE
            IF ( M-P .GT. I ) THEN
               CALL CLARFGP( M-P-I+1, X21(I,I), X21(I+1,I), 1,
     $                       TAUP2(I) )
            ELSE IF ( M-P .EQ. I ) THEN
               CALL CLARFGP( M-P-I+1, X21(I,I), X21(I,I), 1,
     $                       TAUP2(I) )
            END IF
            X21(I,I) = ONE
*
            IF ( Q .GT. I ) THEN
               CALL CLARF( 'L', P-I+1, Q-I, X11(I,I), 1,
     $                     CONJG(TAUP1(I)), X11(I,I+1), LDX11, WORK )
               CALL CLARF( 'L', M-P-I+1, Q-I, X21(I,I), 1,
     $                     CONJG(TAUP2(I)), X21(I,I+1), LDX21, WORK )
            END IF
            IF ( M-Q+1 .GT. I ) THEN
               CALL CLARF( 'L', P-I+1, M-Q-I+1, X11(I,I), 1,
     $                     CONJG(TAUP1(I)), X12(I,I), LDX12, WORK )
               CALL CLARF( 'L', M-P-I+1, M-Q-I+1, X21(I,I), 1,
     $                     CONJG(TAUP2(I)), X22(I,I), LDX22, WORK )
            END IF
*
            IF( I .LT. Q ) THEN
               CALL CSCAL( Q-I, CMPLX( -Z1*Z3*SIN(THETA(I)), 0.0E0 ),
     $                     X11(I,I+1), LDX11 )
               CALL CAXPY( Q-I, CMPLX( Z2*Z3*COS(THETA(I)), 0.0E0 ),
     $                     X21(I,I+1), LDX21, X11(I,I+1), LDX11 )
            END IF
            CALL CSCAL( M-Q-I+1, CMPLX( -Z1*Z4*SIN(THETA(I)), 0.0E0 ),
     $                  X12(I,I), LDX12 )
            CALL CAXPY( M-Q-I+1, CMPLX( Z2*Z4*COS(THETA(I)), 0.0E0 ),
     $                  X22(I,I), LDX22, X12(I,I), LDX12 )
*
            IF( I .LT. Q )
     $         PHI(I) = ATAN2( SCNRM2( Q-I, X11(I,I+1), LDX11 ),
     $                  SCNRM2( M-Q-I+1, X12(I,I), LDX12 ) )
*
            IF( I .LT. Q ) THEN
               CALL CLACGV( Q-I, X11(I,I+1), LDX11 )
               IF ( I .EQ. Q-1 ) THEN
                  CALL CLARFGP( Q-I, X11(I,I+1), X11(I,I+1), LDX11,
     $                          TAUQ1(I) )
               ELSE
                  CALL CLARFGP( Q-I, X11(I,I+1), X11(I,I+2), LDX11,
     $                          TAUQ1(I) )
               END IF
               X11(I,I+1) = ONE
            END IF
            IF ( M-Q+1 .GT. I ) THEN
               CALL CLACGV( M-Q-I+1, X12(I,I), LDX12 )
               IF ( M-Q .EQ. I ) THEN
                  CALL CLARFGP( M-Q-I+1, X12(I,I), X12(I,I), LDX12,
     $                          TAUQ2(I) )
               ELSE
                  CALL CLARFGP( M-Q-I+1, X12(I,I), X12(I,I+1), LDX12,
     $                          TAUQ2(I) )
               END IF
            END IF
            X12(I,I) = ONE
*
            IF( I .LT. Q ) THEN
               CALL CLARF( 'R', P-I, Q-I, X11(I,I+1), LDX11, TAUQ1(I),
     $                     X11(I+1,I+1), LDX11, WORK )
               CALL CLARF( 'R', M-P-I, Q-I, X11(I,I+1), LDX11, TAUQ1(I),
     $                     X21(I+1,I+1), LDX21, WORK )
            END IF
            IF ( P .GT. I ) THEN
               CALL CLARF( 'R', P-I, M-Q-I+1, X12(I,I), LDX12, TAUQ2(I),
     $                     X12(I+1,I), LDX12, WORK )
            END IF
            IF ( M-P .GT. I ) THEN
               CALL CLARF( 'R', M-P-I, M-Q-I+1, X12(I,I), LDX12,
     $                     TAUQ2(I), X22(I+1,I), LDX22, WORK )
            END IF
*
            IF( I .LT. Q )
     $         CALL CLACGV( Q-I, X11(I,I+1), LDX11 )
            CALL CLACGV( M-Q-I+1, X12(I,I), LDX12 )
*
         END DO
*
*        Reduce columns Q + 1, ..., P of X12, X22
*
         DO I = Q + 1, P
*
            CALL CSCAL( M-Q-I+1, CMPLX( -Z1*Z4, 0.0E0 ), X12(I,I),
     $                  LDX12 )
            CALL CLACGV( M-Q-I+1, X12(I,I), LDX12 )
            IF ( I .GE. M-Q ) THEN
               CALL CLARFGP( M-Q-I+1, X12(I,I), X12(I,I), LDX12,
     $                       TAUQ2(I) )
            ELSE
               CALL CLARFGP( M-Q-I+1, X12(I,I), X12(I,I+1), LDX12,
     $                       TAUQ2(I) )
            END IF
            X12(I,I) = ONE
*
            IF ( P .GT. I ) THEN
               CALL CLARF( 'R', P-I, M-Q-I+1, X12(I,I), LDX12, TAUQ2(I),
     $                     X12(I+1,I), LDX12, WORK )
            END IF
            IF( M-P-Q .GE. 1 )
     $         CALL CLARF( 'R', M-P-Q, M-Q-I+1, X12(I,I), LDX12,
     $                     TAUQ2(I), X22(Q+1,I), LDX22, WORK )
*
            CALL CLACGV( M-Q-I+1, X12(I,I), LDX12 )
*
         END DO
*
*        Reduce columns P + 1, ..., M - Q of X12, X22
*
         DO I = 1, M - P - Q
*
            CALL CSCAL( M-P-Q-I+1, CMPLX( Z2*Z4, 0.0E0 ),
     $                  X22(Q+I,P+I), LDX22 )
            CALL CLACGV( M-P-Q-I+1, X22(Q+I,P+I), LDX22 )
            CALL CLARFGP( M-P-Q-I+1, X22(Q+I,P+I), X22(Q+I,P+I+1),
     $                    LDX22, TAUQ2(P+I) )
            X22(Q+I,P+I) = ONE
            CALL CLARF( 'R', M-P-Q-I, M-P-Q-I+1, X22(Q+I,P+I), LDX22,
     $                  TAUQ2(P+I), X22(Q+I+1,P+I), LDX22, WORK )
*
            CALL CLACGV( M-P-Q-I+1, X22(Q+I,P+I), LDX22 )
*
         END DO
*
      ELSE
*
*        Reduce columns 1, ..., Q of X11, X12, X21, X22
*
         DO I = 1, Q
*
            IF( I .EQ. 1 ) THEN
               CALL CSCAL( P-I+1, CMPLX( Z1, 0.0E0 ), X11(I,I),
     $                     LDX11 )
            ELSE
               CALL CSCAL( P-I+1, CMPLX( Z1*COS(PHI(I-1)), 0.0E0 ),
     $                     X11(I,I), LDX11 )
               CALL CAXPY( P-I+1, CMPLX( -Z1*Z3*Z4*SIN(PHI(I-1)),
     $                     0.0E0 ), X12(I-1,I), LDX12, X11(I,I), LDX11 )
            END IF
            IF( I .EQ. 1 ) THEN
               CALL CSCAL( M-P-I+1, CMPLX( Z2, 0.0E0 ), X21(I,I),
     $                     LDX21 )
            ELSE
               CALL CSCAL( M-P-I+1, CMPLX( Z2*COS(PHI(I-1)), 0.0E0 ),
     $                     X21(I,I), LDX21 )
               CALL CAXPY( M-P-I+1, CMPLX( -Z2*Z3*Z4*SIN(PHI(I-1)),
     $                     0.0E0 ), X22(I-1,I), LDX22, X21(I,I), LDX21 )
            END IF
*
            THETA(I) = ATAN2( SCNRM2( M-P-I+1, X21(I,I), LDX21 ),
     $                 SCNRM2( P-I+1, X11(I,I), LDX11 ) )
*
            CALL CLACGV( P-I+1, X11(I,I), LDX11 )
            CALL CLACGV( M-P-I+1, X21(I,I), LDX21 )
*
            CALL CLARFGP( P-I+1, X11(I,I), X11(I,I+1), LDX11, TAUP1(I) )
            X11(I,I) = ONE
            IF ( I .EQ. M-P ) THEN
               CALL CLARFGP( M-P-I+1, X21(I,I), X21(I,I), LDX21,
     $                       TAUP2(I) )
            ELSE
               CALL CLARFGP( M-P-I+1, X21(I,I), X21(I,I+1), LDX21,
     $                       TAUP2(I) )
            END IF
            X21(I,I) = ONE
*
            CALL CLARF( 'R', Q-I, P-I+1, X11(I,I), LDX11, TAUP1(I),
     $                  X11(I+1,I), LDX11, WORK )
            CALL CLARF( 'R', M-Q-I+1, P-I+1, X11(I,I), LDX11, TAUP1(I),
     $                  X12(I,I), LDX12, WORK )
            CALL CLARF( 'R', Q-I, M-P-I+1, X21(I,I), LDX21, TAUP2(I),
     $                  X21(I+1,I), LDX21, WORK )
            CALL CLARF( 'R', M-Q-I+1, M-P-I+1, X21(I,I), LDX21,
     $                  TAUP2(I), X22(I,I), LDX22, WORK )
*
            CALL CLACGV( P-I+1, X11(I,I), LDX11 )
            CALL CLACGV( M-P-I+1, X21(I,I), LDX21 )
*
            IF( I .LT. Q ) THEN
               CALL CSCAL( Q-I, CMPLX( -Z1*Z3*SIN(THETA(I)), 0.0E0 ),
     $                     X11(I+1,I), 1 )
               CALL CAXPY( Q-I, CMPLX( Z2*Z3*COS(THETA(I)), 0.0E0 ),
     $                     X21(I+1,I), 1, X11(I+1,I), 1 )
            END IF
            CALL CSCAL( M-Q-I+1, CMPLX( -Z1*Z4*SIN(THETA(I)), 0.0E0 ),
     $                  X12(I,I), 1 )
            CALL CAXPY( M-Q-I+1, CMPLX( Z2*Z4*COS(THETA(I)), 0.0E0 ),
     $                  X22(I,I), 1, X12(I,I), 1 )
*
            IF( I .LT. Q )
     $         PHI(I) = ATAN2( SCNRM2( Q-I, X11(I+1,I), 1 ),
     $                  SCNRM2( M-Q-I+1, X12(I,I), 1 ) )
*
            IF( I .LT. Q ) THEN
               CALL CLARFGP( Q-I, X11(I+1,I), X11(I+2,I), 1, TAUQ1(I) )
               X11(I+1,I) = ONE
            END IF
            CALL CLARFGP( M-Q-I+1, X12(I,I), X12(I+1,I), 1, TAUQ2(I) )
            X12(I,I) = ONE
*
            IF( I .LT. Q ) THEN
               CALL CLARF( 'L', Q-I, P-I, X11(I+1,I), 1,
     $                     CONJG(TAUQ1(I)), X11(I+1,I+1), LDX11, WORK )
               CALL CLARF( 'L', Q-I, M-P-I, X11(I+1,I), 1,
     $                     CONJG(TAUQ1(I)), X21(I+1,I+1), LDX21, WORK )
            END IF
            CALL CLARF( 'L', M-Q-I+1, P-I, X12(I,I), 1, CONJG(TAUQ2(I)),
     $                  X12(I,I+1), LDX12, WORK )

            IF ( M-P .GT. I ) THEN
               CALL CLARF( 'L', M-Q-I+1, M-P-I, X12(I,I), 1,
     $                     CONJG(TAUQ2(I)), X22(I,I+1), LDX22, WORK )
            END IF
         END DO
*
*        Reduce columns Q + 1, ..., P of X12, X22
*
         DO I = Q + 1, P
*
            CALL CSCAL( M-Q-I+1, CMPLX( -Z1*Z4, 0.0E0 ), X12(I,I), 1 )
            CALL CLARFGP( M-Q-I+1, X12(I,I), X12(I+1,I), 1, TAUQ2(I) )
            X12(I,I) = ONE
*
            IF ( P .GT. I ) THEN
               CALL CLARF( 'L', M-Q-I+1, P-I, X12(I,I), 1,
     $                     CONJG(TAUQ2(I)), X12(I,I+1), LDX12, WORK )
            END IF
            IF( M-P-Q .GE. 1 )
     $         CALL CLARF( 'L', M-Q-I+1, M-P-Q, X12(I,I), 1,
     $                     CONJG(TAUQ2(I)), X22(I,Q+1), LDX22, WORK )
*
         END DO
*
*        Reduce columns P + 1, ..., M - Q of X12, X22
*
         DO I = 1, M - P - Q
*
            CALL CSCAL( M-P-Q-I+1, CMPLX( Z2*Z4, 0.0E0 ),
     $                  X22(P+I,Q+I), 1 )
            CALL CLARFGP( M-P-Q-I+1, X22(P+I,Q+I), X22(P+I+1,Q+I), 1,
     $                    TAUQ2(P+I) )
            X22(P+I,Q+I) = ONE
            IF ( M-P-Q .NE. I ) THEN
               CALL CLARF( 'L', M-P-Q-I+1, M-P-Q-I, X22(P+I,Q+I), 1,
     $                     CONJG(TAUQ2(P+I)), X22(P+I,Q+I+1), LDX22,
     $                     WORK )
            END IF
         END DO
*
      END IF
*
      RETURN
*
*     End of CUNBDB
*
      END

*> \brief \b CUNCSD
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CUNCSD + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cuncsd.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cuncsd.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cuncsd.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       RECURSIVE SUBROUTINE CUNCSD( JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS,
*                                    SIGNS, M, P, Q, X11, LDX11, X12,
*                                    LDX12, X21, LDX21, X22, LDX22, THETA,
*                                    U1, LDU1, U2, LDU2, V1T, LDV1T, V2T,
*                                    LDV2T, WORK, LWORK, RWORK, LRWORK,
*                                    IWORK, INFO )
*
*       .. Scalar Arguments ..
*       CHARACTER          JOBU1, JOBU2, JOBV1T, JOBV2T, SIGNS, TRANS
*       INTEGER            INFO, LDU1, LDU2, LDV1T, LDV2T, LDX11, LDX12,
*      $                   LDX21, LDX22, LRWORK, LWORK, M, P, Q
*       ..
*       .. Array Arguments ..
*       INTEGER            IWORK( * )
*       REAL               THETA( * )
*       REAL               RWORK( * )
*       COMPLEX            U1( LDU1, * ), U2( LDU2, * ), V1T( LDV1T, * ),
*      $                   V2T( LDV2T, * ), WORK( * ), X11( LDX11, * ),
*      $                   X12( LDX12, * ), X21( LDX21, * ), X22( LDX22,
*      $                   * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CUNCSD computes the CS decomposition of an M-by-M partitioned
*> unitary matrix X:
*>
*>                                 [  I  0  0 |  0  0  0 ]
*>                                 [  0  C  0 |  0 -S  0 ]
*>     [ X11 | X12 ]   [ U1 |    ] [  0  0  0 |  0  0 -I ] [ V1 |    ]**H
*> X = [-----------] = [---------] [---------------------] [---------]   .
*>     [ X21 | X22 ]   [    | U2 ] [  0  0  0 |  I  0  0 ] [    | V2 ]
*>                                 [  0  S  0 |  0  C  0 ]
*>                                 [  0  0  I |  0  0  0 ]
*>
*> X11 is P-by-Q. The unitary matrices U1, U2, V1, and V2 are P-by-P,
*> (M-P)-by-(M-P), Q-by-Q, and (M-Q)-by-(M-Q), respectively. C and S are
*> R-by-R nonnegative diagonal matrices satisfying C^2 + S^2 = I, in
*> which R = MIN(P,M-P,Q,M-Q).
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] JOBU1
*> \verbatim
*>          JOBU1 is CHARACTER
*>          = 'Y':      U1 is computed;
*>          otherwise:  U1 is not computed.
*> \endverbatim
*>
*> \param[in] JOBU2
*> \verbatim
*>          JOBU2 is CHARACTER
*>          = 'Y':      U2 is computed;
*>          otherwise:  U2 is not computed.
*> \endverbatim
*>
*> \param[in] JOBV1T
*> \verbatim
*>          JOBV1T is CHARACTER
*>          = 'Y':      V1T is computed;
*>          otherwise:  V1T is not computed.
*> \endverbatim
*>
*> \param[in] JOBV2T
*> \verbatim
*>          JOBV2T is CHARACTER
*>          = 'Y':      V2T is computed;
*>          otherwise:  V2T is not computed.
*> \endverbatim
*>
*> \param[in] TRANS
*> \verbatim
*>          TRANS is CHARACTER
*>          = 'T':      X, U1, U2, V1T, and V2T are stored in row-major
*>                      order;
*>          otherwise:  X, U1, U2, V1T, and V2T are stored in column-
*>                      major order.
*> \endverbatim
*>
*> \param[in] SIGNS
*> \verbatim
*>          SIGNS is CHARACTER
*>          = 'O':      The lower-left block is made nonpositive (the
*>                      "other" convention);
*>          otherwise:  The upper-right block is made nonpositive (the
*>                      "default" convention).
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows and columns in X.
*> \endverbatim
*>
*> \param[in] P
*> \verbatim
*>          P is INTEGER
*>          The number of rows in X11 and X12. 0 <= P <= M.
*> \endverbatim
*>
*> \param[in] Q
*> \verbatim
*>          Q is INTEGER
*>          The number of columns in X11 and X21. 0 <= Q <= M.
*> \endverbatim
*>
*> \param[in,out] X11
*> \verbatim
*>          X11 is COMPLEX array, dimension (LDX11,Q)
*>          On entry, part of the unitary matrix whose CSD is desired.
*> \endverbatim
*>
*> \param[in] LDX11
*> \verbatim
*>          LDX11 is INTEGER
*>          The leading dimension of X11. LDX11 >= MAX(1,P).
*> \endverbatim
*>
*> \param[in,out] X12
*> \verbatim
*>          X12 is COMPLEX array, dimension (LDX12,M-Q)
*>          On entry, part of the unitary matrix whose CSD is desired.
*> \endverbatim
*>
*> \param[in] LDX12
*> \verbatim
*>          LDX12 is INTEGER
*>          The leading dimension of X12. LDX12 >= MAX(1,P).
*> \endverbatim
*>
*> \param[in,out] X21
*> \verbatim
*>          X21 is COMPLEX array, dimension (LDX21,Q)
*>          On entry, part of the unitary matrix whose CSD is desired.
*> \endverbatim
*>
*> \param[in] LDX21
*> \verbatim
*>          LDX21 is INTEGER
*>          The leading dimension of X11. LDX21 >= MAX(1,M-P).
*> \endverbatim
*>
*> \param[in,out] X22
*> \verbatim
*>          X22 is COMPLEX array, dimension (LDX22,M-Q)
*>          On entry, part of the unitary matrix whose CSD is desired.
*> \endverbatim
*>
*> \param[in] LDX22
*> \verbatim
*>          LDX22 is INTEGER
*>          The leading dimension of X11. LDX22 >= MAX(1,M-P).
*> \endverbatim
*>
*> \param[out] THETA
*> \verbatim
*>          THETA is REAL array, dimension (R), in which R =
*>          MIN(P,M-P,Q,M-Q).
*>          C = DIAG( COS(THETA(1)), ... , COS(THETA(R)) ) and
*>          S = DIAG( SIN(THETA(1)), ... , SIN(THETA(R)) ).
*> \endverbatim
*>
*> \param[out] U1
*> \verbatim
*>          U1 is COMPLEX array, dimension (P)
*>          If JOBU1 = 'Y', U1 contains the P-by-P unitary matrix U1.
*> \endverbatim
*>
*> \param[in] LDU1
*> \verbatim
*>          LDU1 is INTEGER
*>          The leading dimension of U1. If JOBU1 = 'Y', LDU1 >=
*>          MAX(1,P).
*> \endverbatim
*>
*> \param[out] U2
*> \verbatim
*>          U2 is COMPLEX array, dimension (M-P)
*>          If JOBU2 = 'Y', U2 contains the (M-P)-by-(M-P) unitary
*>          matrix U2.
*> \endverbatim
*>
*> \param[in] LDU2
*> \verbatim
*>          LDU2 is INTEGER
*>          The leading dimension of U2. If JOBU2 = 'Y', LDU2 >=
*>          MAX(1,M-P).
*> \endverbatim
*>
*> \param[out] V1T
*> \verbatim
*>          V1T is COMPLEX array, dimension (Q)
*>          If JOBV1T = 'Y', V1T contains the Q-by-Q matrix unitary
*>          matrix V1**H.
*> \endverbatim
*>
*> \param[in] LDV1T
*> \verbatim
*>          LDV1T is INTEGER
*>          The leading dimension of V1T. If JOBV1T = 'Y', LDV1T >=
*>          MAX(1,Q).
*> \endverbatim
*>
*> \param[out] V2T
*> \verbatim
*>          V2T is COMPLEX array, dimension (M-Q)
*>          If JOBV2T = 'Y', V2T contains the (M-Q)-by-(M-Q) unitary
*>          matrix V2**H.
*> \endverbatim
*>
*> \param[in] LDV2T
*> \verbatim
*>          LDV2T is INTEGER
*>          The leading dimension of V2T. If JOBV2T = 'Y', LDV2T >=
*>          MAX(1,M-Q).
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (MAX(1,LWORK))
*>          On exit, if INFO = 0, WORK(1) returns the optimal LWORK.
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          LWORK is INTEGER
*>          The dimension of the array WORK.
*>
*>          If LWORK = -1, then a workspace query is assumed; the routine
*>          only calculates the optimal size of the WORK array, returns
*>          this value as the first entry of the work array, and no error
*>          message related to LWORK is issued by XERBLA.
*> \endverbatim
*>
*> \param[out] RWORK
*> \verbatim
*>          RWORK is REAL array, dimension MAX(1,LRWORK)
*>          On exit, if INFO = 0, RWORK(1) returns the optimal LRWORK.
*>          If INFO > 0 on exit, RWORK(2:R) contains the values PHI(1),
*>          ..., PHI(R-1) that, together with THETA(1), ..., THETA(R),
*>          define the matrix in intermediate bidiagonal-block form
*>          remaining after nonconvergence. INFO specifies the number
*>          of nonzero PHI's.
*> \endverbatim
*>
*> \param[in] LRWORK
*> \verbatim
*>          LRWORK is INTEGER
*>          The dimension of the array RWORK.
*>
*>          If LRWORK = -1, then a workspace query is assumed; the routine
*>          only calculates the optimal size of the RWORK array, returns
*>          this value as the first entry of the work array, and no error
*>          message related to LRWORK is issued by XERBLA.
*> \endverbatim
*>
*> \param[out] IWORK
*> \verbatim
*>          IWORK is INTEGER array, dimension (M-MIN(P,M-P,Q,M-Q))
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit.
*>          < 0:  if INFO = -i, the i-th argument had an illegal value.
*>          > 0:  CBBCSD did not converge. See the description of RWORK
*>                above for details.
*> \endverbatim
*
*> \par References:
*  ================
*>
*>  [1] Brian D. Sutton. Computing the complete CS decomposition. Numer.
*>      Algorithms, 50(1):33-65, 2009.
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date June 2016
*
*> \ingroup complexOTHERcomputational
*
*  =====================================================================
      RECURSIVE SUBROUTINE CUNCSD( JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS,
     $                             SIGNS, M, P, Q, X11, LDX11, X12,
     $                             LDX12, X21, LDX21, X22, LDX22, THETA,
     $                             U1, LDU1, U2, LDU2, V1T, LDV1T, V2T,
     $                             LDV2T, WORK, LWORK, RWORK, LRWORK,
     $                             IWORK, INFO )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     June 2016
*
*     .. Scalar Arguments ..
      CHARACTER          JOBU1, JOBU2, JOBV1T, JOBV2T, SIGNS, TRANS
      INTEGER            INFO, LDU1, LDU2, LDV1T, LDV2T, LDX11, LDX12,
     $                   LDX21, LDX22, LRWORK, LWORK, M, P, Q
*     ..
*     .. Array Arguments ..
      INTEGER            IWORK( * )
      REAL               THETA( * )
      REAL               RWORK( * )
      COMPLEX            U1( LDU1, * ), U2( LDU2, * ), V1T( LDV1T, * ),
     $                   V2T( LDV2T, * ), WORK( * ), X11( LDX11, * ),
     $                   X12( LDX12, * ), X21( LDX21, * ), X22( LDX22,
     $                   * )
*     ..
*
*  ===================================================================
*
*     .. Parameters ..
      COMPLEX            ONE, ZERO
      PARAMETER          ( ONE = (1.0E0,0.0E0),
     $                     ZERO = (0.0E0,0.0E0) )
*     ..
*     .. Local Scalars ..
      CHARACTER          TRANST, SIGNST
      INTEGER            CHILDINFO, I, IB11D, IB11E, IB12D, IB12E,
     $                   IB21D, IB21E, IB22D, IB22E, IBBCSD, IORBDB,
     $                   IORGLQ, IORGQR, IPHI, ITAUP1, ITAUP2, ITAUQ1,
     $                   ITAUQ2, J, LBBCSDWORK, LBBCSDWORKMIN,
     $                   LBBCSDWORKOPT, LORBDBWORK, LORBDBWORKMIN,
     $                   LORBDBWORKOPT, LORGLQWORK, LORGLQWORKMIN,
     $                   LORGLQWORKOPT, LORGQRWORK, LORGQRWORKMIN,
     $                   LORGQRWORKOPT, LWORKMIN, LWORKOPT, P1, Q1
      LOGICAL            COLMAJOR, DEFAULTSIGNS, LQUERY, WANTU1, WANTU2,
     $                   WANTV1T, WANTV2T
      INTEGER            LRWORKMIN, LRWORKOPT
      LOGICAL            LRQUERY
*     ..
*     .. External Subroutines ..
      EXTERNAL           XERBLA, CBBCSD, CLACPY, CLAPMR, CLAPMT,
     $                   CUNBDB, CUNGLQ, CUNGQR
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. Intrinsic Functions
      INTRINSIC          INT, MAX, MIN
*     ..
*     .. Executable Statements ..
*
*     Test input arguments
*
      INFO = 0
      WANTU1 = LSAME( JOBU1, 'Y' )
      WANTU2 = LSAME( JOBU2, 'Y' )
      WANTV1T = LSAME( JOBV1T, 'Y' )
      WANTV2T = LSAME( JOBV2T, 'Y' )
      COLMAJOR = .NOT. LSAME( TRANS, 'T' )
      DEFAULTSIGNS = .NOT. LSAME( SIGNS, 'O' )
      LQUERY = LWORK .EQ. -1
      LRQUERY = LRWORK .EQ. -1
      IF( M .LT. 0 ) THEN
         INFO = -7
      ELSE IF( P .LT. 0 .OR. P .GT. M ) THEN
         INFO = -8
      ELSE IF( Q .LT. 0 .OR. Q .GT. M ) THEN
         INFO = -9
      ELSE IF ( COLMAJOR .AND.  LDX11 .LT. MAX( 1, P ) ) THEN
        INFO = -11
      ELSE IF (.NOT. COLMAJOR .AND. LDX11 .LT. MAX( 1, Q ) ) THEN
        INFO = -11
      ELSE IF (COLMAJOR .AND. LDX12 .LT. MAX( 1, P ) ) THEN
        INFO = -13
      ELSE IF (.NOT. COLMAJOR .AND. LDX12 .LT. MAX( 1, M-Q ) ) THEN
        INFO = -13
      ELSE IF (COLMAJOR .AND. LDX21 .LT. MAX( 1, M-P ) ) THEN
        INFO = -15
      ELSE IF (.NOT. COLMAJOR .AND. LDX21 .LT. MAX( 1, Q ) ) THEN
        INFO = -15
      ELSE IF (COLMAJOR .AND. LDX22 .LT. MAX( 1, M-P ) ) THEN
        INFO = -17
      ELSE IF (.NOT. COLMAJOR .AND. LDX22 .LT. MAX( 1, M-Q ) ) THEN
        INFO = -17
      ELSE IF( WANTU1 .AND. LDU1 .LT. P ) THEN
         INFO = -20
      ELSE IF( WANTU2 .AND. LDU2 .LT. M-P ) THEN
         INFO = -22
      ELSE IF( WANTV1T .AND. LDV1T .LT. Q ) THEN
         INFO = -24
      ELSE IF( WANTV2T .AND. LDV2T .LT. M-Q ) THEN
         INFO = -26
      END IF
*
*     Work with transpose if convenient
*
      IF( INFO .EQ. 0 .AND. MIN( P, M-P ) .LT. MIN( Q, M-Q ) ) THEN
         IF( COLMAJOR ) THEN
            TRANST = 'T'
         ELSE
            TRANST = 'N'
         END IF
         IF( DEFAULTSIGNS ) THEN
            SIGNST = 'O'
         ELSE
            SIGNST = 'D'
         END IF
         CALL CUNCSD( JOBV1T, JOBV2T, JOBU1, JOBU2, TRANST, SIGNST, M,
     $                Q, P, X11, LDX11, X21, LDX21, X12, LDX12, X22,
     $                LDX22, THETA, V1T, LDV1T, V2T, LDV2T, U1, LDU1,
     $                U2, LDU2, WORK, LWORK, RWORK, LRWORK, IWORK,
     $                INFO )
         RETURN
      END IF
*
*     Work with permutation [ 0 I; I 0 ] * X * [ 0 I; I 0 ] if
*     convenient
*
      IF( INFO .EQ. 0 .AND. M-Q .LT. Q ) THEN
         IF( DEFAULTSIGNS ) THEN
            SIGNST = 'O'
         ELSE
            SIGNST = 'D'
         END IF
         CALL CUNCSD( JOBU2, JOBU1, JOBV2T, JOBV1T, TRANS, SIGNST, M,
     $                M-P, M-Q, X22, LDX22, X21, LDX21, X12, LDX12, X11,
     $                LDX11, THETA, U2, LDU2, U1, LDU1, V2T, LDV2T, V1T,
     $                LDV1T, WORK, LWORK, RWORK, LRWORK, IWORK, INFO )
         RETURN
      END IF
*
*     Compute workspace
*
      IF( INFO .EQ. 0 ) THEN
*
*        Real workspace
*
         IPHI = 2
         IB11D = IPHI + MAX( 1, Q - 1 )
         IB11E = IB11D + MAX( 1, Q )
         IB12D = IB11E + MAX( 1, Q - 1 )
         IB12E = IB12D + MAX( 1, Q )
         IB21D = IB12E + MAX( 1, Q - 1 )
         IB21E = IB21D + MAX( 1, Q )
         IB22D = IB21E + MAX( 1, Q - 1 )
         IB22E = IB22D + MAX( 1, Q )
         IBBCSD = IB22E + MAX( 1, Q - 1 )
         CALL CBBCSD( JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS, M, P, Q,
     $                THETA, THETA, U1, LDU1, U2, LDU2, V1T, LDV1T,
     $                V2T, LDV2T, THETA, THETA, THETA, THETA, THETA,
     $                THETA, THETA, THETA, RWORK, -1, CHILDINFO )
         LBBCSDWORKOPT = INT( RWORK(1) )
         LBBCSDWORKMIN = LBBCSDWORKOPT
         LRWORKOPT = IBBCSD + LBBCSDWORKOPT - 1
         LRWORKMIN = IBBCSD + LBBCSDWORKMIN - 1
         RWORK(1) = LRWORKOPT
*
*        Complex workspace
*
         ITAUP1 = 2
         ITAUP2 = ITAUP1 + MAX( 1, P )
         ITAUQ1 = ITAUP2 + MAX( 1, M - P )
         ITAUQ2 = ITAUQ1 + MAX( 1, Q )
         IORGQR = ITAUQ2 + MAX( 1, M - Q )
         CALL CUNGQR( M-Q, M-Q, M-Q, U1, MAX(1,M-Q), U1, WORK, -1,
     $                CHILDINFO )
         LORGQRWORKOPT = INT( WORK(1) )
         LORGQRWORKMIN = MAX( 1, M - Q )
         IORGLQ = ITAUQ2 + MAX( 1, M - Q )
         CALL CUNGLQ( M-Q, M-Q, M-Q, U1, MAX(1,M-Q), U1, WORK, -1,
     $                CHILDINFO )
         LORGLQWORKOPT = INT( WORK(1) )
         LORGLQWORKMIN = MAX( 1, M - Q )
         IORBDB = ITAUQ2 + MAX( 1, M - Q )
         CALL CUNBDB( TRANS, SIGNS, M, P, Q, X11, LDX11, X12, LDX12,
     $                X21, LDX21, X22, LDX22, THETA, THETA, U1, U2,
     $                V1T, V2T, WORK, -1, CHILDINFO )
         LORBDBWORKOPT = INT( WORK(1) )
         LORBDBWORKMIN = LORBDBWORKOPT
         LWORKOPT = MAX( IORGQR + LORGQRWORKOPT, IORGLQ + LORGLQWORKOPT,
     $              IORBDB + LORBDBWORKOPT ) - 1
         LWORKMIN = MAX( IORGQR + LORGQRWORKMIN, IORGLQ + LORGLQWORKMIN,
     $              IORBDB + LORBDBWORKMIN ) - 1
         WORK(1) = MAX(LWORKOPT,LWORKMIN)
*
         IF( LWORK .LT. LWORKMIN
     $       .AND. .NOT. ( LQUERY .OR. LRQUERY ) ) THEN
            INFO = -22
         ELSE IF( LRWORK .LT. LRWORKMIN
     $            .AND. .NOT. ( LQUERY .OR. LRQUERY ) ) THEN
            INFO = -24
         ELSE
            LORGQRWORK = LWORK - IORGQR + 1
            LORGLQWORK = LWORK - IORGLQ + 1
            LORBDBWORK = LWORK - IORBDB + 1
            LBBCSDWORK = LRWORK - IBBCSD + 1
         END IF
      END IF
*
*     Abort if any illegal arguments
*
      IF( INFO .NE. 0 ) THEN
         CALL XERBLA( 'CUNCSD', -INFO )
         RETURN
      ELSE IF( LQUERY .OR. LRQUERY ) THEN
         RETURN
      END IF
*
*     Transform to bidiagonal block form
*
      CALL CUNBDB( TRANS, SIGNS, M, P, Q, X11, LDX11, X12, LDX12, X21,
     $             LDX21, X22, LDX22, THETA, RWORK(IPHI), WORK(ITAUP1),
     $             WORK(ITAUP2), WORK(ITAUQ1), WORK(ITAUQ2),
     $             WORK(IORBDB), LORBDBWORK, CHILDINFO )
*
*     Accumulate Householder reflectors
*
      IF( COLMAJOR ) THEN
         IF( WANTU1 .AND. P .GT. 0 ) THEN
            CALL CLACPY( 'L', P, Q, X11, LDX11, U1, LDU1 )
            CALL CUNGQR( P, P, Q, U1, LDU1, WORK(ITAUP1), WORK(IORGQR),
     $                   LORGQRWORK, INFO)
         END IF
         IF( WANTU2 .AND. M-P .GT. 0 ) THEN
            CALL CLACPY( 'L', M-P, Q, X21, LDX21, U2, LDU2 )
            CALL CUNGQR( M-P, M-P, Q, U2, LDU2, WORK(ITAUP2),
     $                   WORK(IORGQR), LORGQRWORK, INFO )
         END IF
         IF( WANTV1T .AND. Q .GT. 0 ) THEN
            CALL CLACPY( 'U', Q-1, Q-1, X11(1,2), LDX11, V1T(2,2),
     $                   LDV1T )
            V1T(1, 1) = ONE
            DO J = 2, Q
               V1T(1,J) = ZERO
               V1T(J,1) = ZERO
            END DO
            CALL CUNGLQ( Q-1, Q-1, Q-1, V1T(2,2), LDV1T, WORK(ITAUQ1),
     $                   WORK(IORGLQ), LORGLQWORK, INFO )
         END IF
         IF( WANTV2T .AND. M-Q .GT. 0 ) THEN
            CALL CLACPY( 'U', P, M-Q, X12, LDX12, V2T, LDV2T )
            IF( M-P .GT. Q ) THEN
               CALL CLACPY( 'U', M-P-Q, M-P-Q, X22(Q+1,P+1), LDX22,
     $                      V2T(P+1,P+1), LDV2T )
            END IF
            IF( M .GT. Q ) THEN
               CALL CUNGLQ( M-Q, M-Q, M-Q, V2T, LDV2T, WORK(ITAUQ2),
     $                      WORK(IORGLQ), LORGLQWORK, INFO )
            END IF
         END IF
      ELSE
         IF( WANTU1 .AND. P .GT. 0 ) THEN
            CALL CLACPY( 'U', Q, P, X11, LDX11, U1, LDU1 )
            CALL CUNGLQ( P, P, Q, U1, LDU1, WORK(ITAUP1), WORK(IORGLQ),
     $                   LORGLQWORK, INFO)
         END IF
         IF( WANTU2 .AND. M-P .GT. 0 ) THEN
            CALL CLACPY( 'U', Q, M-P, X21, LDX21, U2, LDU2 )
            CALL CUNGLQ( M-P, M-P, Q, U2, LDU2, WORK(ITAUP2),
     $                   WORK(IORGLQ), LORGLQWORK, INFO )
         END IF
         IF( WANTV1T .AND. Q .GT. 0 ) THEN
            CALL CLACPY( 'L', Q-1, Q-1, X11(2,1), LDX11, V1T(2,2),
     $                   LDV1T )
            V1T(1, 1) = ONE
            DO J = 2, Q
               V1T(1,J) = ZERO
               V1T(J,1) = ZERO
            END DO
            CALL CUNGQR( Q-1, Q-1, Q-1, V1T(2,2), LDV1T, WORK(ITAUQ1),
     $                   WORK(IORGQR), LORGQRWORK, INFO )
         END IF
         IF( WANTV2T .AND. M-Q .GT. 0 ) THEN
            P1 = MIN( P+1, M )
            Q1 = MIN( Q+1, M )
            CALL CLACPY( 'L', M-Q, P, X12, LDX12, V2T, LDV2T )
            IF ( M .GT. P+Q ) THEN
               CALL CLACPY( 'L', M-P-Q, M-P-Q, X22(P1,Q1), LDX22,
     $                      V2T(P+1,P+1), LDV2T )
            END IF
            CALL CUNGQR( M-Q, M-Q, M-Q, V2T, LDV2T, WORK(ITAUQ2),
     $                   WORK(IORGQR), LORGQRWORK, INFO )
         END IF
      END IF
*
*     Compute the CSD of the matrix in bidiagonal-block form
*
      CALL CBBCSD( JOBU1, JOBU2, JOBV1T, JOBV2T, TRANS, M, P, Q, THETA,
     $             RWORK(IPHI), U1, LDU1, U2, LDU2, V1T, LDV1T, V2T,
     $             LDV2T, RWORK(IB11D), RWORK(IB11E), RWORK(IB12D),
     $             RWORK(IB12E), RWORK(IB21D), RWORK(IB21E),
     $             RWORK(IB22D), RWORK(IB22E), RWORK(IBBCSD),
     $             LBBCSDWORK, INFO )
*
*     Permute rows and columns to place identity submatrices in top-
*     left corner of (1,1)-block and/or bottom-right corner of (1,2)-
*     block and/or bottom-right corner of (2,1)-block and/or top-left
*     corner of (2,2)-block
*
      IF( Q .GT. 0 .AND. WANTU2 ) THEN
         DO I = 1, Q
            IWORK(I) = M - P - Q + I
         END DO
         DO I = Q + 1, M - P
            IWORK(I) = I - Q
         END DO
         IF( COLMAJOR ) THEN
            CALL CLAPMT( .FALSE., M-P, M-P, U2, LDU2, IWORK )
         ELSE
            CALL CLAPMR( .FALSE., M-P, M-P, U2, LDU2, IWORK )
         END IF
      END IF
      IF( M .GT. 0 .AND. WANTV2T ) THEN
         DO I = 1, P
            IWORK(I) = M - P - Q + I
         END DO
         DO I = P + 1, M - Q
            IWORK(I) = I - P
         END DO
         IF( .NOT. COLMAJOR ) THEN
            CALL CLAPMT( .FALSE., M-Q, M-Q, V2T, LDV2T, IWORK )
         ELSE
            CALL CLAPMR( .FALSE., M-Q, M-Q, V2T, LDV2T, IWORK )
         END IF
      END IF
*
      RETURN
*
*     End CUNCSD
*
      END

*> \brief \b CUNG2R
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CUNG2R + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cung2r.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cung2r.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cung2r.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CUNG2R( M, N, K, A, LDA, TAU, WORK, INFO )
*
*       .. Scalar Arguments ..
*       INTEGER            INFO, K, LDA, M, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CUNG2R generates an m by n complex matrix Q with orthonormal columns,
*> which is defined as the first n columns of a product of k elementary
*> reflectors of order m
*>
*>       Q  =  H(1) H(2) . . . H(k)
*>
*> as returned by CGEQRF.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix Q. M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix Q. M >= N >= 0.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The number of elementary reflectors whose product defines the
*>          matrix Q. N >= K >= 0.
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          On entry, the i-th column must contain the vector which
*>          defines the elementary reflector H(i), for i = 1,2,...,k, as
*>          returned by CGEQRF in the first k columns of its array
*>          argument A.
*>          On exit, the m by n matrix Q.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The first dimension of the array A. LDA >= max(1,M).
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX array, dimension (K)
*>          TAU(i) must contain the scalar factor of the elementary
*>          reflector H(i), as returned by CGEQRF.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (N)
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0: successful exit
*>          < 0: if INFO = -i, the i-th argument has an illegal value
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERcomputational
*
*  =====================================================================
      SUBROUTINE CUNG2R( M, N, K, A, LDA, TAU, WORK, INFO )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            INFO, K, LDA, M, N
*     ..
*     .. Array Arguments ..
      COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ONE, ZERO
      PARAMETER          ( ONE = ( 1.0E+0, 0.0E+0 ),
     $                   ZERO = ( 0.0E+0, 0.0E+0 ) )
*     ..
*     .. Local Scalars ..
      INTEGER            I, J, L
*     ..
*     .. External Subroutines ..
      EXTERNAL           CLARF, CSCAL, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX
*     ..
*     .. Executable Statements ..
*
*     Test the input arguments
*
      INFO = 0
      IF( M.LT.0 ) THEN
         INFO = -1
      ELSE IF( N.LT.0 .OR. N.GT.M ) THEN
         INFO = -2
      ELSE IF( K.LT.0 .OR. K.GT.N ) THEN
         INFO = -3
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = -5
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'CUNG2R', -INFO )
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( N.LE.0 )
     $   RETURN
*
*     Initialise columns k+1:n to columns of the unit matrix
*
      DO 20 J = K + 1, N
         DO 10 L = 1, M
            A( L, J ) = ZERO
   10    CONTINUE
         A( J, J ) = ONE
   20 CONTINUE
*
      DO 40 I = K, 1, -1
*
*        Apply H(i) to A(i:m,i:n) from the left
*
         IF( I.LT.N ) THEN
            A( I, I ) = ONE
            CALL CLARF( 'Left', M-I+1, N-I, A( I, I ), 1, TAU( I ),
     $                  A( I, I+1 ), LDA, WORK )
         END IF
         IF( I.LT.M )
     $      CALL CSCAL( M-I, -TAU( I ), A( I+1, I ), 1 )
         A( I, I ) = ONE - TAU( I )
*
*        Set A(1:i-1,i) to zero
*
         DO 30 L = 1, I - 1
            A( L, I ) = ZERO
   30    CONTINUE
   40 CONTINUE
      RETURN
*
*     End of CUNG2R
*
      END
*> \brief \b CUNGL2 generates all or part of the unitary matrix Q from an LQ factorization determined by cgelqf (unblocked algorithm).
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CUNGL2 + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cungl2.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cungl2.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cungl2.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CUNGL2( M, N, K, A, LDA, TAU, WORK, INFO )
*
*       .. Scalar Arguments ..
*       INTEGER            INFO, K, LDA, M, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CUNGL2 generates an m-by-n complex matrix Q with orthonormal rows,
*> which is defined as the first m rows of a product of k elementary
*> reflectors of order n
*>
*>       Q  =  H(k)**H . . . H(2)**H H(1)**H
*>
*> as returned by CGELQF.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix Q. M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix Q. N >= M.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The number of elementary reflectors whose product defines the
*>          matrix Q. M >= K >= 0.
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          On entry, the i-th row must contain the vector which defines
*>          the elementary reflector H(i), for i = 1,2,...,k, as returned
*>          by CGELQF in the first k rows of its array argument A.
*>          On exit, the m by n matrix Q.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The first dimension of the array A. LDA >= max(1,M).
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX array, dimension (K)
*>          TAU(i) must contain the scalar factor of the elementary
*>          reflector H(i), as returned by CGELQF.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (M)
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0: successful exit
*>          < 0: if INFO = -i, the i-th argument has an illegal value
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERcomputational
*
*  =====================================================================
      SUBROUTINE CUNGL2( M, N, K, A, LDA, TAU, WORK, INFO )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            INFO, K, LDA, M, N
*     ..
*     .. Array Arguments ..
      COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ONE, ZERO
      PARAMETER          ( ONE = ( 1.0E+0, 0.0E+0 ),
     $                   ZERO = ( 0.0E+0, 0.0E+0 ) )
*     ..
*     .. Local Scalars ..
      INTEGER            I, J, L
*     ..
*     .. External Subroutines ..
      EXTERNAL           CLACGV, CLARF, CSCAL, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CONJG, MAX
*     ..
*     .. Executable Statements ..
*
*     Test the input arguments
*
      INFO = 0
      IF( M.LT.0 ) THEN
         INFO = -1
      ELSE IF( N.LT.M ) THEN
         INFO = -2
      ELSE IF( K.LT.0 .OR. K.GT.M ) THEN
         INFO = -3
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = -5
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'CUNGL2', -INFO )
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( M.LE.0 )
     $   RETURN
*
      IF( K.LT.M ) THEN
*
*        Initialise rows k+1:m to rows of the unit matrix
*
         DO 20 J = 1, N
            DO 10 L = K + 1, M
               A( L, J ) = ZERO
   10       CONTINUE
            IF( J.GT.K .AND. J.LE.M )
     $         A( J, J ) = ONE
   20    CONTINUE
      END IF
*
      DO 40 I = K, 1, -1
*
*        Apply H(i)**H to A(i:m,i:n) from the right
*
         IF( I.LT.N ) THEN
            CALL CLACGV( N-I, A( I, I+1 ), LDA )
            IF( I.LT.M ) THEN
               A( I, I ) = ONE
               CALL CLARF( 'Right', M-I, N-I+1, A( I, I ), LDA,
     $                     CONJG( TAU( I ) ), A( I+1, I ), LDA, WORK )
            END IF
            CALL CSCAL( N-I, -TAU( I ), A( I, I+1 ), LDA )
            CALL CLACGV( N-I, A( I, I+1 ), LDA )
         END IF
         A( I, I ) = ONE - CONJG( TAU( I ) )
*
*        Set A(i,1:i-1,i) to zero
*
         DO 30 L = 1, I - 1
            A( I, L ) = ZERO
   30    CONTINUE
   40 CONTINUE
      RETURN
*
*     End of CUNGL2
*
      END
*> \brief \b CUNGLQ
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CUNGLQ + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cunglq.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cunglq.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cunglq.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CUNGLQ( M, N, K, A, LDA, TAU, WORK, LWORK, INFO )
*
*       .. Scalar Arguments ..
*       INTEGER            INFO, K, LDA, LWORK, M, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CUNGLQ generates an M-by-N complex matrix Q with orthonormal rows,
*> which is defined as the first M rows of a product of K elementary
*> reflectors of order N
*>
*>       Q  =  H(k)**H . . . H(2)**H H(1)**H
*>
*> as returned by CGELQF.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix Q. M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix Q. N >= M.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The number of elementary reflectors whose product defines the
*>          matrix Q. M >= K >= 0.
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          On entry, the i-th row must contain the vector which defines
*>          the elementary reflector H(i), for i = 1,2,...,k, as returned
*>          by CGELQF in the first k rows of its array argument A.
*>          On exit, the M-by-N matrix Q.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The first dimension of the array A. LDA >= max(1,M).
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX array, dimension (K)
*>          TAU(i) must contain the scalar factor of the elementary
*>          reflector H(i), as returned by CGELQF.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (MAX(1,LWORK))
*>          On exit, if INFO = 0, WORK(1) returns the optimal LWORK.
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          LWORK is INTEGER
*>          The dimension of the array WORK. LWORK >= max(1,M).
*>          For optimum performance LWORK >= M*NB, where NB is
*>          the optimal blocksize.
*>
*>          If LWORK = -1, then a workspace query is assumed; the routine
*>          only calculates the optimal size of the WORK array, returns
*>          this value as the first entry of the WORK array, and no error
*>          message related to LWORK is issued by XERBLA.
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit;
*>          < 0:  if INFO = -i, the i-th argument has an illegal value
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERcomputational
*
*  =====================================================================
      SUBROUTINE CUNGLQ( M, N, K, A, LDA, TAU, WORK, LWORK, INFO )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            INFO, K, LDA, LWORK, M, N
*     ..
*     .. Array Arguments ..
      COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ZERO
      PARAMETER          ( ZERO = ( 0.0E+0, 0.0E+0 ) )
*     ..
*     .. Local Scalars ..
      LOGICAL            LQUERY
      INTEGER            I, IB, IINFO, IWS, J, KI, KK, L, LDWORK,
     $                   LWKOPT, NB, NBMIN, NX
*     ..
*     .. External Subroutines ..
      EXTERNAL           CLARFB, CLARFT, CUNGL2, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX, MIN
*     ..
*     .. External Functions ..
      INTEGER            ILAENV
      EXTERNAL           ILAENV
*     ..
*     .. Executable Statements ..
*
*     Test the input arguments
*
      INFO = 0
      NB = ILAENV( 1, 'CUNGLQ', ' ', M, N, K, -1 )
      LWKOPT = MAX( 1, M )*NB
      WORK( 1 ) = LWKOPT
      LQUERY = ( LWORK.EQ.-1 )
      IF( M.LT.0 ) THEN
         INFO = -1
      ELSE IF( N.LT.M ) THEN
         INFO = -2
      ELSE IF( K.LT.0 .OR. K.GT.M ) THEN
         INFO = -3
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = -5
      ELSE IF( LWORK.LT.MAX( 1, M ) .AND. .NOT.LQUERY ) THEN
         INFO = -8
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'CUNGLQ', -INFO )
         RETURN
      ELSE IF( LQUERY ) THEN
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( M.LE.0 ) THEN
         WORK( 1 ) = 1
         RETURN
      END IF
*
      NBMIN = 2
      NX = 0
      IWS = M
      IF( NB.GT.1 .AND. NB.LT.K ) THEN
*
*        Determine when to cross over from blocked to unblocked code.
*
         NX = MAX( 0, ILAENV( 3, 'CUNGLQ', ' ', M, N, K, -1 ) )
         IF( NX.LT.K ) THEN
*
*           Determine if workspace is large enough for blocked code.
*
            LDWORK = M
            IWS = LDWORK*NB
            IF( LWORK.LT.IWS ) THEN
*
*              Not enough workspace to use optimal NB:  reduce NB and
*              determine the minimum value of NB.
*
               NB = LWORK / LDWORK
               NBMIN = MAX( 2, ILAENV( 2, 'CUNGLQ', ' ', M, N, K, -1 ) )
            END IF
         END IF
      END IF
*
      IF( NB.GE.NBMIN .AND. NB.LT.K .AND. NX.LT.K ) THEN
*
*        Use blocked code after the last block.
*        The first kk rows are handled by the block method.
*
         KI = ( ( K-NX-1 ) / NB )*NB
         KK = MIN( K, KI+NB )
*
*        Set A(kk+1:m,1:kk) to zero.
*
         DO 20 J = 1, KK
            DO 10 I = KK + 1, M
               A( I, J ) = ZERO
   10       CONTINUE
   20    CONTINUE
      ELSE
         KK = 0
      END IF
*
*     Use unblocked code for the last or only block.
*
      IF( KK.LT.M )
     $   CALL CUNGL2( M-KK, N-KK, K-KK, A( KK+1, KK+1 ), LDA,
     $                TAU( KK+1 ), WORK, IINFO )
*
      IF( KK.GT.0 ) THEN
*
*        Use blocked code
*
         DO 50 I = KI + 1, 1, -NB
            IB = MIN( NB, K-I+1 )
            IF( I+IB.LE.M ) THEN
*
*              Form the triangular factor of the block reflector
*              H = H(i) H(i+1) . . . H(i+ib-1)
*
               CALL CLARFT( 'Forward', 'Rowwise', N-I+1, IB, A( I, I ),
     $                      LDA, TAU( I ), WORK, LDWORK )
*
*              Apply H**H to A(i+ib:m,i:n) from the right
*
               CALL CLARFB( 'Right', 'Conjugate transpose', 'Forward',
     $                      'Rowwise', M-I-IB+1, N-I+1, IB, A( I, I ),
     $                      LDA, WORK, LDWORK, A( I+IB, I ), LDA,
     $                      WORK( IB+1 ), LDWORK )
            END IF
*
*           Apply H**H to columns i:n of current block
*
            CALL CUNGL2( IB, N-I+1, IB, A( I, I ), LDA, TAU( I ), WORK,
     $                   IINFO )
*
*           Set columns 1:i-1 of current block to zero
*
            DO 40 J = 1, I - 1
               DO 30 L = I, I + IB - 1
                  A( L, J ) = ZERO
   30          CONTINUE
   40       CONTINUE
   50    CONTINUE
      END IF
*
      WORK( 1 ) = IWS
      RETURN
*
*     End of CUNGLQ
*
      END
*> \brief \b CUNGQR
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CUNGQR + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/cungqr.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/cungqr.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/cungqr.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CUNGQR( M, N, K, A, LDA, TAU, WORK, LWORK, INFO )
*
*       .. Scalar Arguments ..
*       INTEGER            INFO, K, LDA, LWORK, M, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CUNGQR generates an M-by-N complex matrix Q with orthonormal columns,
*> which is defined as the first N columns of a product of K elementary
*> reflectors of order M
*>
*>       Q  =  H(1) H(2) . . . H(k)
*>
*> as returned by CGEQRF.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix Q. M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix Q. M >= N >= 0.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The number of elementary reflectors whose product defines the
*>          matrix Q. N >= K >= 0.
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          On entry, the i-th column must contain the vector which
*>          defines the elementary reflector H(i), for i = 1,2,...,k, as
*>          returned by CGEQRF in the first k columns of its array
*>          argument A.
*>          On exit, the M-by-N matrix Q.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The first dimension of the array A. LDA >= max(1,M).
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX array, dimension (K)
*>          TAU(i) must contain the scalar factor of the elementary
*>          reflector H(i), as returned by CGEQRF.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (MAX(1,LWORK))
*>          On exit, if INFO = 0, WORK(1) returns the optimal LWORK.
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          LWORK is INTEGER
*>          The dimension of the array WORK. LWORK >= max(1,N).
*>          For optimum performance LWORK >= N*NB, where NB is the
*>          optimal blocksize.
*>
*>          If LWORK = -1, then a workspace query is assumed; the routine
*>          only calculates the optimal size of the WORK array, returns
*>          this value as the first entry of the WORK array, and no error
*>          message related to LWORK is issued by XERBLA.
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit
*>          < 0:  if INFO = -i, the i-th argument has an illegal value
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERcomputational
*
*  =====================================================================
      SUBROUTINE CUNGQR( M, N, K, A, LDA, TAU, WORK, LWORK, INFO )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            INFO, K, LDA, LWORK, M, N
*     ..
*     .. Array Arguments ..
      COMPLEX            A( LDA, * ), TAU( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ZERO
      PARAMETER          ( ZERO = ( 0.0E+0, 0.0E+0 ) )
*     ..
*     .. Local Scalars ..
      LOGICAL            LQUERY
      INTEGER            I, IB, IINFO, IWS, J, KI, KK, L, LDWORK,
     $                   LWKOPT, NB, NBMIN, NX
*     ..
*     .. External Subroutines ..
      EXTERNAL           CLARFB, CLARFT, CUNG2R, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX, MIN
*     ..
*     .. External Functions ..
      INTEGER            ILAENV
      EXTERNAL           ILAENV
*     ..
*     .. Executable Statements ..
*
*     Test the input arguments
*
      INFO = 0
      NB = ILAENV( 1, 'CUNGQR', ' ', M, N, K, -1 )
      LWKOPT = MAX( 1, N )*NB
      WORK( 1 ) = LWKOPT
      LQUERY = ( LWORK.EQ.-1 )
      IF( M.LT.0 ) THEN
         INFO = -1
      ELSE IF( N.LT.0 .OR. N.GT.M ) THEN
         INFO = -2
      ELSE IF( K.LT.0 .OR. K.GT.N ) THEN
         INFO = -3
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = -5
      ELSE IF( LWORK.LT.MAX( 1, N ) .AND. .NOT.LQUERY ) THEN
         INFO = -8
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'CUNGQR', -INFO )
         RETURN
      ELSE IF( LQUERY ) THEN
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( N.LE.0 ) THEN
         WORK( 1 ) = 1
         RETURN
      END IF
*
      NBMIN = 2
      NX = 0
      IWS = N
      IF( NB.GT.1 .AND. NB.LT.K ) THEN
*
*        Determine when to cross over from blocked to unblocked code.
*
         NX = MAX( 0, ILAENV( 3, 'CUNGQR', ' ', M, N, K, -1 ) )
         IF( NX.LT.K ) THEN
*
*           Determine if workspace is large enough for blocked code.
*
            LDWORK = N
            IWS = LDWORK*NB
            IF( LWORK.LT.IWS ) THEN
*
*              Not enough workspace to use optimal NB:  reduce NB and
*              determine the minimum value of NB.
*
               NB = LWORK / LDWORK
               NBMIN = MAX( 2, ILAENV( 2, 'CUNGQR', ' ', M, N, K, -1 ) )
            END IF
         END IF
      END IF
*
      IF( NB.GE.NBMIN .AND. NB.LT.K .AND. NX.LT.K ) THEN
*
*        Use blocked code after the last block.
*        The first kk columns are handled by the block method.
*
         KI = ( ( K-NX-1 ) / NB )*NB
         KK = MIN( K, KI+NB )
*
*        Set A(1:kk,kk+1:n) to zero.
*
         DO 20 J = KK + 1, N
            DO 10 I = 1, KK
               A( I, J ) = ZERO
   10       CONTINUE
   20    CONTINUE
      ELSE
         KK = 0
      END IF
*
*     Use unblocked code for the last or only block.
*
      IF( KK.LT.N )
     $   CALL CUNG2R( M-KK, N-KK, K-KK, A( KK+1, KK+1 ), LDA,
     $                TAU( KK+1 ), WORK, IINFO )
*
      IF( KK.GT.0 ) THEN
*
*        Use blocked code
*
         DO 50 I = KI + 1, 1, -NB
            IB = MIN( NB, K-I+1 )
            IF( I+IB.LE.N ) THEN
*
*              Form the triangular factor of the block reflector
*              H = H(i) H(i+1) . . . H(i+ib-1)
*
               CALL CLARFT( 'Forward', 'Columnwise', M-I+1, IB,
     $                      A( I, I ), LDA, TAU( I ), WORK, LDWORK )
*
*              Apply H to A(i:m,i+ib:n) from the left
*
               CALL CLARFB( 'Left', 'No transpose', 'Forward',
     $                      'Columnwise', M-I+1, N-I-IB+1, IB,
     $                      A( I, I ), LDA, WORK, LDWORK, A( I, I+IB ),
     $                      LDA, WORK( IB+1 ), LDWORK )
            END IF
*
*           Apply H to rows i:m of current block
*
            CALL CUNG2R( M-I+1, IB, IB, A( I, I ), LDA, TAU( I ), WORK,
     $                   IINFO )
*
*           Set rows 1:i-1 of current block to zero
*
            DO 40 J = I, I + IB - 1
               DO 30 L = 1, I - 1
                  A( L, J ) = ZERO
   30          CONTINUE
   40       CONTINUE
   50    CONTINUE
      END IF
*
      WORK( 1 ) = IWS
      RETURN
*
*     End of CUNGQR
*
      END
*> \brief \b IEEECK
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download IEEECK + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/ieeeck.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/ieeeck.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/ieeeck.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       INTEGER          FUNCTION IEEECK( ISPEC, ZERO, ONE )
*
*       .. Scalar Arguments ..
*       INTEGER            ISPEC
*       REAL               ONE, ZERO
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> IEEECK is called from the ILAENV to verify that Infinity and
*> possibly NaN arithmetic is safe (i.e. will not trap).
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] ISPEC
*> \verbatim
*>          ISPEC is INTEGER
*>          Specifies whether to test just for inifinity arithmetic
*>          or whether to test for infinity and NaN arithmetic.
*>          = 0: Verify infinity arithmetic only.
*>          = 1: Verify infinity and NaN arithmetic.
*> \endverbatim
*>
*> \param[in] ZERO
*> \verbatim
*>          ZERO is REAL
*>          Must contain the value 0.0
*>          This is passed to prevent the compiler from optimizing
*>          away this code.
*> \endverbatim
*>
*> \param[in] ONE
*> \verbatim
*>          ONE is REAL
*>          Must contain the value 1.0
*>          This is passed to prevent the compiler from optimizing
*>          away this code.
*>
*>  RETURN VALUE:  INTEGER
*>          = 0:  Arithmetic failed to produce the correct answers
*>          = 1:  Arithmetic produced the correct answers
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*  =====================================================================
      INTEGER          FUNCTION IEEECK( ISPEC, ZERO, ONE )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            ISPEC
      REAL               ONE, ZERO
*     ..
*
*  =====================================================================
*
*     .. Local Scalars ..
      REAL               NAN1, NAN2, NAN3, NAN4, NAN5, NAN6, NEGINF,
     $                   NEGZRO, NEWZRO, POSINF
*     ..
*     .. Executable Statements ..
      IEEECK = 1
*
      POSINF = ONE / ZERO
      IF( POSINF.LE.ONE ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      NEGINF = -ONE / ZERO
      IF( NEGINF.GE.ZERO ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      NEGZRO = ONE / ( NEGINF+ONE )
      IF( NEGZRO.NE.ZERO ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      NEGINF = ONE / NEGZRO
      IF( NEGINF.GE.ZERO ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      NEWZRO = NEGZRO + ZERO
      IF( NEWZRO.NE.ZERO ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      POSINF = ONE / NEWZRO
      IF( POSINF.LE.ONE ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      NEGINF = NEGINF*POSINF
      IF( NEGINF.GE.ZERO ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      POSINF = POSINF*POSINF
      IF( POSINF.LE.ONE ) THEN
         IEEECK = 0
         RETURN
      END IF
*
*
*
*
*     Return if we were only asked to check infinity arithmetic
*
      IF( ISPEC.EQ.0 )
     $   RETURN
*
      NAN1 = POSINF + NEGINF
*
      NAN2 = POSINF / NEGINF
*
      NAN3 = POSINF / POSINF
*
      NAN4 = POSINF*ZERO
*
      NAN5 = NEGINF*NEGZRO
*
      NAN6 = NAN5*ZERO
*
      IF( NAN1.EQ.NAN1 ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      IF( NAN2.EQ.NAN2 ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      IF( NAN3.EQ.NAN3 ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      IF( NAN4.EQ.NAN4 ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      IF( NAN5.EQ.NAN5 ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      IF( NAN6.EQ.NAN6 ) THEN
         IEEECK = 0
         RETURN
      END IF
*
      RETURN
      END
*> \brief \b ILACLC scans a matrix for its last non-zero column.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download ILACLC + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/ilaclc.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/ilaclc.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/ilaclc.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       INTEGER FUNCTION ILACLC( M, N, A, LDA )
*
*       .. Scalar Arguments ..
*       INTEGER            M, N, LDA
*       ..
*       .. Array Arguments ..
*       COMPLEX            A( LDA, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> ILACLC scans A for its last non-zero column.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix A.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix A.
*> \endverbatim
*>
*> \param[in] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>          The m by n matrix A.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A. LDA >= max(1,M).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      INTEGER FUNCTION ILACLC( M, N, A, LDA )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            M, N, LDA
*     ..
*     .. Array Arguments ..
      COMPLEX            A( LDA, * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX          ZERO
      PARAMETER ( ZERO = (0.0E+0, 0.0E+0) )
*     ..
*     .. Local Scalars ..
      INTEGER I
*     ..
*     .. Executable Statements ..
*
*     Quick test for the common case where one corner is non-zero.
      IF( N.EQ.0 ) THEN
         ILACLC = N
      ELSE IF( A(1, N).NE.ZERO .OR. A(M, N).NE.ZERO ) THEN
         ILACLC = N
      ELSE
*     Now scan each column from the end, returning with the first non-zero.
         DO ILACLC = N, 1, -1
            DO I = 1, M
               IF( A(I, ILACLC).NE.ZERO ) RETURN
            END DO
         END DO
      END IF
      RETURN
      END
*> \brief \b ILACLR scans a matrix for its last non-zero row.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download ILACLR + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/ilaclr.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/ilaclr.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/ilaclr.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       INTEGER FUNCTION ILACLR( M, N, A, LDA )
*
*       .. Scalar Arguments ..
*       INTEGER            M, N, LDA
*       ..
*       .. Array Arguments ..
*       COMPLEX            A( LDA, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> ILACLR scans A for its last non-zero row.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix A.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix A.
*> \endverbatim
*>
*> \param[in] A
*> \verbatim
*>          A is array, dimension (LDA,N)
*>          The m by n matrix A.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A. LDA >= max(1,M).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      INTEGER FUNCTION ILACLR( M, N, A, LDA )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            M, N, LDA
*     ..
*     .. Array Arguments ..
      COMPLEX            A( LDA, * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX          ZERO
      PARAMETER ( ZERO = (0.0E+0, 0.0E+0) )
*     ..
*     .. Local Scalars ..
      INTEGER I, J
*     ..
*     .. Executable Statements ..
*
*     Quick test for the common case where one corner is non-zero.
      IF( M.EQ.0 ) THEN
         ILACLR = M
      ELSE IF( A(M, 1).NE.ZERO .OR. A(M, N).NE.ZERO ) THEN
         ILACLR = M
      ELSE
*     Scan up each column tracking the last zero row seen.
         ILACLR = 0
         DO J = 1, N
            I=M
            DO WHILE((A(MAX(I,1),J).EQ.ZERO).AND.(I.GE.1))
               I=I-1
            ENDDO
            ILACLR = MAX( ILACLR, I )
         END DO
      END IF
      RETURN
      END
*> \brief \b ILAENV
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download ILAENV + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/ilaenv.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/ilaenv.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/ilaenv.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       INTEGER FUNCTION ILAENV( ISPEC, NAME, OPTS, N1, N2, N3, N4 )
*
*       .. Scalar Arguments ..
*       CHARACTER*( * )    NAME, OPTS
*       INTEGER            ISPEC, N1, N2, N3, N4
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> ILAENV is called from the LAPACK routines to choose problem-dependent
*> parameters for the local environment.  See ISPEC for a description of
*> the parameters.
*>
*> ILAENV returns an INTEGER
*> if ILAENV >= 0: ILAENV returns the value of the parameter specified by ISPEC
*> if ILAENV < 0:  if ILAENV = -k, the k-th argument had an illegal value.
*>
*> This version provides a set of parameters which should give good,
*> but not optimal, performance on many of the currently available
*> computers.  Users are encouraged to modify this subroutine to set
*> the tuning parameters for their particular machine using the option
*> and problem size information in the arguments.
*>
*> This routine will not function correctly if it is converted to all
*> lower case.  Converting it to all upper case is allowed.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] ISPEC
*> \verbatim
*>          ISPEC is INTEGER
*>          Specifies the parameter to be returned as the value of
*>          ILAENV.
*>          = 1: the optimal blocksize; if this value is 1, an unblocked
*>               algorithm will give the best performance.
*>          = 2: the minimum block size for which the block routine
*>               should be used; if the usable block size is less than
*>               this value, an unblocked routine should be used.
*>          = 3: the crossover point (in a block routine, for N less
*>               than this value, an unblocked routine should be used)
*>          = 4: the number of shifts, used in the nonsymmetric
*>               eigenvalue routines (DEPRECATED)
*>          = 5: the minimum column dimension for blocking to be used;
*>               rectangular blocks must have dimension at least k by m,
*>               where k is given by ILAENV(2,...) and m by ILAENV(5,...)
*>          = 6: the crossover point for the SVD (when reducing an m by n
*>               matrix to bidiagonal form, if max(m,n)/min(m,n) exceeds
*>               this value, a QR factorization is used first to reduce
*>               the matrix to a triangular form.)
*>          = 7: the number of processors
*>          = 8: the crossover point for the multishift QR method
*>               for nonsymmetric eigenvalue problems (DEPRECATED)
*>          = 9: maximum size of the subproblems at the bottom of the
*>               computation tree in the divide-and-conquer algorithm
*>               (used by xGELSD and xGESDD)
*>          =10: ieee NaN arithmetic can be trusted not to trap
*>          =11: infinity arithmetic can be trusted not to trap
*>          12 <= ISPEC <= 16:
*>               xHSEQR or related subroutines,
*>               see IPARMQ for detailed explanation
*> \endverbatim
*>
*> \param[in] NAME
*> \verbatim
*>          NAME is CHARACTER*(*)
*>          The name of the calling subroutine, in either upper case or
*>          lower case.
*> \endverbatim
*>
*> \param[in] OPTS
*> \verbatim
*>          OPTS is CHARACTER*(*)
*>          The character options to the subroutine NAME, concatenated
*>          into a single character string.  For example, UPLO = 'U',
*>          TRANS = 'T', and DIAG = 'N' for a triangular routine would
*>          be specified as OPTS = 'UTN'.
*> \endverbatim
*>
*> \param[in] N1
*> \verbatim
*>          N1 is INTEGER
*> \endverbatim
*>
*> \param[in] N2
*> \verbatim
*>          N2 is INTEGER
*> \endverbatim
*>
*> \param[in] N3
*> \verbatim
*>          N3 is INTEGER
*> \endverbatim
*>
*> \param[in] N4
*> \verbatim
*>          N4 is INTEGER
*>          Problem dimensions for the subroutine NAME; these may not all
*>          be required.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  The following conventions have been used when calling ILAENV from the
*>  LAPACK routines:
*>  1)  OPTS is a concatenation of all of the character options to
*>      subroutine NAME, in the same order that they appear in the
*>      argument list for NAME, even if they are not used in determining
*>      the value of the parameter specified by ISPEC.
*>  2)  The problem dimensions N1, N2, N3, N4 are specified in the order
*>      that they appear in the argument list for NAME.  N1 is used
*>      first, N2 second, and so on, and unused problem dimensions are
*>      passed a value of -1.
*>  3)  The parameter value returned by ILAENV is checked for validity in
*>      the calling subroutine.  For example, ILAENV is used to retrieve
*>      the optimal blocksize for STRTRI as follows:
*>
*>      NB = ILAENV( 1, 'STRTRI', UPLO // DIAG, N, -1, -1, -1 )
*>      IF( NB.LE.1 ) NB = MAX( 1, N )
*> \endverbatim
*>
*  =====================================================================
      INTEGER FUNCTION ILAENV( ISPEC, NAME, OPTS, N1, N2, N3, N4 )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER*( * )    NAME, OPTS
      INTEGER            ISPEC, N1, N2, N3, N4
*     ..
*
*  =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, IC, IZ, NB, NBMIN, NX
      LOGICAL            CNAME, SNAME
      CHARACTER          C1*1, C2*2, C4*2, C3*3, SUBNAM*6
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CHAR, ICHAR, INT, MIN, REAL
*     ..
*     .. External Functions ..
      INTEGER            IEEECK, IPARMQ, IPARAM2STAGE
      EXTERNAL           IEEECK, IPARMQ, IPARAM2STAGE
*     ..
*     .. Executable Statements ..
*
      GO TO ( 10, 10, 10, 80, 90, 100, 110, 120,
     $        130, 140, 150, 160, 160, 160, 160, 160,
     $        170, 170, 170, 170, 170 )ISPEC
*
*     Invalid value for ISPEC
*
      ILAENV = -1
      RETURN
*
   10 CONTINUE
*
*     Convert NAME to upper case if the first character is lower case.
*
      ILAENV = 1
      SUBNAM = NAME
      IC = ICHAR( SUBNAM( 1: 1 ) )
      IZ = ICHAR( 'Z' )
      IF( IZ.EQ.90 .OR. IZ.EQ.122 ) THEN
*
*        ASCII character set
*
         IF( IC.GE.97 .AND. IC.LE.122 ) THEN
            SUBNAM( 1: 1 ) = CHAR( IC-32 )
            DO 20 I = 2, 6
               IC = ICHAR( SUBNAM( I: I ) )
               IF( IC.GE.97 .AND. IC.LE.122 )
     $            SUBNAM( I: I ) = CHAR( IC-32 )
   20       CONTINUE
         END IF
*
      ELSE IF( IZ.EQ.233 .OR. IZ.EQ.169 ) THEN
*
*        EBCDIC character set
*
         IF( ( IC.GE.129 .AND. IC.LE.137 ) .OR.
     $       ( IC.GE.145 .AND. IC.LE.153 ) .OR.
     $       ( IC.GE.162 .AND. IC.LE.169 ) ) THEN
            SUBNAM( 1: 1 ) = CHAR( IC+64 )
            DO 30 I = 2, 6
               IC = ICHAR( SUBNAM( I: I ) )
               IF( ( IC.GE.129 .AND. IC.LE.137 ) .OR.
     $             ( IC.GE.145 .AND. IC.LE.153 ) .OR.
     $             ( IC.GE.162 .AND. IC.LE.169 ) )SUBNAM( I:
     $             I ) = CHAR( IC+64 )
   30       CONTINUE
         END IF
*
      ELSE IF( IZ.EQ.218 .OR. IZ.EQ.250 ) THEN
*
*        Prime machines:  ASCII+128
*
         IF( IC.GE.225 .AND. IC.LE.250 ) THEN
            SUBNAM( 1: 1 ) = CHAR( IC-32 )
            DO 40 I = 2, 6
               IC = ICHAR( SUBNAM( I: I ) )
               IF( IC.GE.225 .AND. IC.LE.250 )
     $            SUBNAM( I: I ) = CHAR( IC-32 )
   40       CONTINUE
         END IF
      END IF
*
      C1 = SUBNAM( 1: 1 )
      SNAME = C1.EQ.'S' .OR. C1.EQ.'D'
      CNAME = C1.EQ.'C' .OR. C1.EQ.'Z'
      IF( .NOT.( CNAME .OR. SNAME ) )
     $   RETURN
      C2 = SUBNAM( 2: 3 )
      C3 = SUBNAM( 4: 6 )
      C4 = C3( 2: 3 )
*
      GO TO ( 50, 60, 70 )ISPEC
*
   50 CONTINUE
*
*     ISPEC = 1:  block size
*
*     In these examples, separate code is provided for setting NB for
*     real and complex.  We assume that NB will take the same value in
*     single or double precision.
*
      NB = 1
*
      IF( C2.EQ.'GE' ) THEN
         IF( C3.EQ.'TRF' ) THEN
            IF( SNAME ) THEN
               NB = 64
            ELSE
               NB = 64
            END IF
         ELSE IF( C3.EQ.'QRF' .OR. C3.EQ.'RQF' .OR. C3.EQ.'LQF' .OR.
     $            C3.EQ.'QLF' ) THEN
            IF( SNAME ) THEN
               NB = 32
            ELSE
               NB = 32
            END IF
         ELSE IF( C3.EQ.'QR ') THEN
            IF( N3 .EQ. 1) THEN
               IF( SNAME ) THEN
*     M*N
                  IF ((N1*N2.LE.131072).OR.(N1.LE.8192)) THEN
                     NB = N1
                  ELSE
                     NB = 32768/N2
                  END IF
               ELSE
                  IF ((N1*N2.LE.131072).OR.(N1.LE.8192)) THEN
                     NB = N1
                  ELSE
                     NB = 32768/N2
                  END IF
               END IF
            ELSE
               IF( SNAME ) THEN
                  NB = 1
               ELSE
                  NB = 1
               END IF
            END IF
         ELSE IF( C3.EQ.'LQ ') THEN
            IF( N3 .EQ. 2) THEN
               IF( SNAME ) THEN
*     M*N
                  IF ((N1*N2.LE.131072).OR.(N1.LE.8192)) THEN
                     NB = N1
                  ELSE
                     NB = 32768/N2
                  END IF
               ELSE
                  IF ((N1*N2.LE.131072).OR.(N1.LE.8192)) THEN
                     NB = N1
                  ELSE
                     NB = 32768/N2
                  END IF
               END IF
            ELSE
               IF( SNAME ) THEN
                  NB = 1
               ELSE
                  NB = 1
               END IF
            END IF
         ELSE IF( C3.EQ.'HRD' ) THEN
            IF( SNAME ) THEN
               NB = 32
            ELSE
               NB = 32
            END IF
         ELSE IF( C3.EQ.'BRD' ) THEN
            IF( SNAME ) THEN
               NB = 32
            ELSE
               NB = 32
            END IF
         ELSE IF( C3.EQ.'TRI' ) THEN
            IF( SNAME ) THEN
               NB = 64
            ELSE
               NB = 64
            END IF
         END IF
      ELSE IF( C2.EQ.'PO' ) THEN
         IF( C3.EQ.'TRF' ) THEN
            IF( SNAME ) THEN
               NB = 64
            ELSE
               NB = 64
            END IF
         END IF
      ELSE IF( C2.EQ.'SY' ) THEN
         IF( C3.EQ.'TRF' ) THEN
            IF( SNAME ) THEN
               NB = 64
            ELSE
               NB = 64
            END IF
         ELSE IF( SNAME .AND. C3.EQ.'TRD' ) THEN
            NB = 32
         ELSE IF( SNAME .AND. C3.EQ.'GST' ) THEN
            NB = 64
         END IF
      ELSE IF( CNAME .AND. C2.EQ.'HE' ) THEN
         IF( C3.EQ.'TRF' ) THEN
            NB = 64
         ELSE IF( C3.EQ.'TRD' ) THEN
            NB = 32
         ELSE IF( C3.EQ.'GST' ) THEN
            NB = 64
         END IF
      ELSE IF( SNAME .AND. C2.EQ.'OR' ) THEN
         IF( C3( 1: 1 ).EQ.'G' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NB = 32
            END IF
         ELSE IF( C3( 1: 1 ).EQ.'M' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NB = 32
            END IF
         END IF
      ELSE IF( CNAME .AND. C2.EQ.'UN' ) THEN
         IF( C3( 1: 1 ).EQ.'G' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NB = 32
            END IF
         ELSE IF( C3( 1: 1 ).EQ.'M' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NB = 32
            END IF
         END IF
      ELSE IF( C2.EQ.'GB' ) THEN
         IF( C3.EQ.'TRF' ) THEN
            IF( SNAME ) THEN
               IF( N4.LE.64 ) THEN
                  NB = 1
               ELSE
                  NB = 32
               END IF
            ELSE
               IF( N4.LE.64 ) THEN
                  NB = 1
               ELSE
                  NB = 32
               END IF
            END IF
         END IF
      ELSE IF( C2.EQ.'PB' ) THEN
         IF( C3.EQ.'TRF' ) THEN
            IF( SNAME ) THEN
               IF( N2.LE.64 ) THEN
                  NB = 1
               ELSE
                  NB = 32
               END IF
            ELSE
               IF( N2.LE.64 ) THEN
                  NB = 1
               ELSE
                  NB = 32
               END IF
            END IF
         END IF
      ELSE IF( C2.EQ.'TR' ) THEN
         IF( C3.EQ.'TRI' ) THEN
            IF( SNAME ) THEN
               NB = 64
            ELSE
               NB = 64
            END IF
         ELSE IF ( C3.EQ.'EVC' ) THEN
            IF( SNAME ) THEN
               NB = 64
            ELSE
               NB = 64
            END IF
         END IF
      ELSE IF( C2.EQ.'LA' ) THEN
         IF( C3.EQ.'UUM' ) THEN
            IF( SNAME ) THEN
               NB = 64
            ELSE
               NB = 64
            END IF
         END IF
      ELSE IF( SNAME .AND. C2.EQ.'ST' ) THEN
         IF( C3.EQ.'EBZ' ) THEN
            NB = 1
         END IF
      ELSE IF( C2.EQ.'GG' ) THEN
         NB = 32
         IF( C3.EQ.'HD3' ) THEN
            IF( SNAME ) THEN
               NB = 32
            ELSE
               NB = 32
            END IF
         END IF
      END IF
      ILAENV = NB
      RETURN
*
   60 CONTINUE
*
*     ISPEC = 2:  minimum block size
*
      NBMIN = 2
      IF( C2.EQ.'GE' ) THEN
         IF( C3.EQ.'QRF' .OR. C3.EQ.'RQF' .OR. C3.EQ.'LQF' .OR. C3.EQ.
     $       'QLF' ) THEN
            IF( SNAME ) THEN
               NBMIN = 2
            ELSE
               NBMIN = 2
            END IF
         ELSE IF( C3.EQ.'HRD' ) THEN
            IF( SNAME ) THEN
               NBMIN = 2
            ELSE
               NBMIN = 2
            END IF
         ELSE IF( C3.EQ.'BRD' ) THEN
            IF( SNAME ) THEN
               NBMIN = 2
            ELSE
               NBMIN = 2
            END IF
         ELSE IF( C3.EQ.'TRI' ) THEN
            IF( SNAME ) THEN
               NBMIN = 2
            ELSE
               NBMIN = 2
            END IF
         END IF
      ELSE IF( C2.EQ.'SY' ) THEN
         IF( C3.EQ.'TRF' ) THEN
            IF( SNAME ) THEN
               NBMIN = 8
            ELSE
               NBMIN = 8
            END IF
         ELSE IF( SNAME .AND. C3.EQ.'TRD' ) THEN
            NBMIN = 2
         END IF
      ELSE IF( CNAME .AND. C2.EQ.'HE' ) THEN
         IF( C3.EQ.'TRD' ) THEN
            NBMIN = 2
         END IF
      ELSE IF( SNAME .AND. C2.EQ.'OR' ) THEN
         IF( C3( 1: 1 ).EQ.'G' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NBMIN = 2
            END IF
         ELSE IF( C3( 1: 1 ).EQ.'M' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NBMIN = 2
            END IF
         END IF
      ELSE IF( CNAME .AND. C2.EQ.'UN' ) THEN
         IF( C3( 1: 1 ).EQ.'G' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NBMIN = 2
            END IF
         ELSE IF( C3( 1: 1 ).EQ.'M' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NBMIN = 2
            END IF
         END IF
      ELSE IF( C2.EQ.'GG' ) THEN
         NBMIN = 2
         IF( C3.EQ.'HD3' ) THEN
            NBMIN = 2
         END IF
      END IF
      ILAENV = NBMIN
      RETURN
*
   70 CONTINUE
*
*     ISPEC = 3:  crossover point
*
      NX = 0
      IF( C2.EQ.'GE' ) THEN
         IF( C3.EQ.'QRF' .OR. C3.EQ.'RQF' .OR. C3.EQ.'LQF' .OR. C3.EQ.
     $       'QLF' ) THEN
            IF( SNAME ) THEN
               NX = 128
            ELSE
               NX = 128
            END IF
         ELSE IF( C3.EQ.'HRD' ) THEN
            IF( SNAME ) THEN
               NX = 128
            ELSE
               NX = 128
            END IF
         ELSE IF( C3.EQ.'BRD' ) THEN
            IF( SNAME ) THEN
               NX = 128
            ELSE
               NX = 128
            END IF
         END IF
      ELSE IF( C2.EQ.'SY' ) THEN
         IF( SNAME .AND. C3.EQ.'TRD' ) THEN
            NX = 32
         END IF
      ELSE IF( CNAME .AND. C2.EQ.'HE' ) THEN
         IF( C3.EQ.'TRD' ) THEN
            NX = 32
         END IF
      ELSE IF( SNAME .AND. C2.EQ.'OR' ) THEN
         IF( C3( 1: 1 ).EQ.'G' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NX = 128
            END IF
         END IF
      ELSE IF( CNAME .AND. C2.EQ.'UN' ) THEN
         IF( C3( 1: 1 ).EQ.'G' ) THEN
            IF( C4.EQ.'QR' .OR. C4.EQ.'RQ' .OR. C4.EQ.'LQ' .OR. C4.EQ.
     $          'QL' .OR. C4.EQ.'HR' .OR. C4.EQ.'TR' .OR. C4.EQ.'BR' )
     $           THEN
               NX = 128
            END IF
         END IF
      ELSE IF( C2.EQ.'GG' ) THEN
         NX = 128
         IF( C3.EQ.'HD3' ) THEN
            NX = 128
         END IF
      END IF
      ILAENV = NX
      RETURN
*
   80 CONTINUE
*
*     ISPEC = 4:  number of shifts (used by xHSEQR)
*
      ILAENV = 6
      RETURN
*
   90 CONTINUE
*
*     ISPEC = 5:  minimum column dimension (not used)
*
      ILAENV = 2
      RETURN
*
  100 CONTINUE
*
*     ISPEC = 6:  crossover point for SVD (used by xGELSS and xGESVD)
*
      ILAENV = INT( REAL( MIN( N1, N2 ) )*1.6E0 )
      RETURN
*
  110 CONTINUE
*
*     ISPEC = 7:  number of processors (not used)
*
      ILAENV = 1
      RETURN
*
  120 CONTINUE
*
*     ISPEC = 8:  crossover point for multishift (used by xHSEQR)
*
      ILAENV = 50
      RETURN
*
  130 CONTINUE
*
*     ISPEC = 9:  maximum size of the subproblems at the bottom of the
*                 computation tree in the divide-and-conquer algorithm
*                 (used by xGELSD and xGESDD)
*
      ILAENV = 25
      RETURN
*
  140 CONTINUE
*
*     ISPEC = 10: ieee NaN arithmetic can be trusted not to trap
*
*     ILAENV = 0
      ILAENV = 1
      IF( ILAENV.EQ.1 ) THEN
         ILAENV = IEEECK( 1, 0.0, 1.0 )
      END IF
      RETURN
*
  150 CONTINUE
*
*     ISPEC = 11: infinity arithmetic can be trusted not to trap
*
*     ILAENV = 0
      ILAENV = 1
      IF( ILAENV.EQ.1 ) THEN
         ILAENV = IEEECK( 0, 0.0, 1.0 )
      END IF
      RETURN
*
  160 CONTINUE
*
*     12 <= ISPEC <= 16: xHSEQR or related subroutines.
*
      ILAENV = IPARMQ( ISPEC, NAME, OPTS, N1, N2, N3, N4 )
      RETURN
*
  170 CONTINUE
*
*     17 <= ISPEC <= 21: 2stage eigenvalues and SVD or related subroutines.
*
      ILAENV = IPARAM2STAGE( ISPEC, NAME, OPTS, N1, N2, N3, N4 )
      RETURN
*
*     End of ILAENV
*
      END
*> \brief \b IPARMQ
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download IPARMQ + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/iparmq.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/iparmq.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/iparmq.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       INTEGER FUNCTION IPARMQ( ISPEC, NAME, OPTS, N, ILO, IHI, LWORK )
*
*       .. Scalar Arguments ..
*       INTEGER            IHI, ILO, ISPEC, LWORK, N
*       CHARACTER          NAME*( * ), OPTS*( * )
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*>      This program sets problem and machine dependent parameters
*>      useful for xHSEQR and related subroutines for eigenvalue
*>      problems. It is called whenever
*>      IPARMQ is called with 12 <= ISPEC <= 16
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] ISPEC
*> \verbatim
*>          ISPEC is integer scalar
*>              ISPEC specifies which tunable parameter IPARMQ should
*>              return.
*>
*>              ISPEC=12: (INMIN)  Matrices of order nmin or less
*>                        are sent directly to xLAHQR, the implicit
*>                        double shift QR algorithm.  NMIN must be
*>                        at least 11.
*>
*>              ISPEC=13: (INWIN)  Size of the deflation window.
*>                        This is best set greater than or equal to
*>                        the number of simultaneous shifts NS.
*>                        Larger matrices benefit from larger deflation
*>                        windows.
*>
*>              ISPEC=14: (INIBL) Determines when to stop nibbling and
*>                        invest in an (expensive) multi-shift QR sweep.
*>                        If the aggressive early deflation subroutine
*>                        finds LD converged eigenvalues from an order
*>                        NW deflation window and LD.GT.(NW*NIBBLE)/100,
*>                        then the next QR sweep is skipped and early
*>                        deflation is applied immediately to the
*>                        remaining active diagonal block.  Setting
*>                        IPARMQ(ISPEC=14) = 0 causes TTQRE to skip a
*>                        multi-shift QR sweep whenever early deflation
*>                        finds a converged eigenvalue.  Setting
*>                        IPARMQ(ISPEC=14) greater than or equal to 100
*>                        prevents TTQRE from skipping a multi-shift
*>                        QR sweep.
*>
*>              ISPEC=15: (NSHFTS) The number of simultaneous shifts in
*>                        a multi-shift QR iteration.
*>
*>              ISPEC=16: (IACC22) IPARMQ is set to 0, 1 or 2 with the
*>                        following meanings.
*>                        0:  During the multi-shift QR/QZ sweep,
*>                            blocked eigenvalue reordering, blocked
*>                            Hessenberg-triangular reduction,
*>                            reflections and/or rotations are not
*>                            accumulated when updating the
*>                            far-from-diagonal matrix entries.
*>                        1:  During the multi-shift QR/QZ sweep,
*>                            blocked eigenvalue reordering, blocked
*>                            Hessenberg-triangular reduction,
*>                            reflections and/or rotations are
*>                            accumulated, and matrix-matrix
*>                            multiplication is used to update the
*>                            far-from-diagonal matrix entries.
*>                        2:  During the multi-shift QR/QZ sweep,
*>                            blocked eigenvalue reordering, blocked
*>                            Hessenberg-triangular reduction,
*>                            reflections and/or rotations are
*>                            accumulated, and 2-by-2 block structure
*>                            is exploited during matrix-matrix
*>                            multiplies.
*>                        (If xTRMM is slower than xGEMM, then
*>                        IPARMQ(ISPEC=16)=1 may be more efficient than
*>                        IPARMQ(ISPEC=16)=2 despite the greater level of
*>                        arithmetic work implied by the latter choice.)
*> \endverbatim
*>
*> \param[in] NAME
*> \verbatim
*>          NAME is character string
*>               Name of the calling subroutine
*> \endverbatim
*>
*> \param[in] OPTS
*> \verbatim
*>          OPTS is character string
*>               This is a concatenation of the string arguments to
*>               TTQRE.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is integer scalar
*>               N is the order of the Hessenberg matrix H.
*> \endverbatim
*>
*> \param[in] ILO
*> \verbatim
*>          ILO is INTEGER
*> \endverbatim
*>
*> \param[in] IHI
*> \verbatim
*>          IHI is INTEGER
*>               It is assumed that H is already upper triangular
*>               in rows and columns 1:ILO-1 and IHI+1:N.
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          LWORK is integer scalar
*>               The amount of workspace available.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>       Little is known about how best to choose these parameters.
*>       It is possible to use different values of the parameters
*>       for each of CHSEQR, DHSEQR, SHSEQR and ZHSEQR.
*>
*>       It is probably best to choose different parameters for
*>       different matrices and different parameters at different
*>       times during the iteration, but this has not been
*>       implemented --- yet.
*>
*>
*>       The best choices of most of the parameters depend
*>       in an ill-understood way on the relative execution
*>       rate of xLAQR3 and xLAQR5 and on the nature of each
*>       particular eigenvalue problem.  Experiment may be the
*>       only practical way to determine which choices are most
*>       effective.
*>
*>       Following is a list of default values supplied by IPARMQ.
*>       These defaults may be adjusted in order to attain better
*>       performance in any particular computational environment.
*>
*>       IPARMQ(ISPEC=12) The xLAHQR vs xLAQR0 crossover point.
*>                        Default: 75. (Must be at least 11.)
*>
*>       IPARMQ(ISPEC=13) Recommended deflation window size.
*>                        This depends on ILO, IHI and NS, the
*>                        number of simultaneous shifts returned
*>                        by IPARMQ(ISPEC=15).  The default for
*>                        (IHI-ILO+1).LE.500 is NS.  The default
*>                        for (IHI-ILO+1).GT.500 is 3*NS/2.
*>
*>       IPARMQ(ISPEC=14) Nibble crossover point.  Default: 14.
*>
*>       IPARMQ(ISPEC=15) Number of simultaneous shifts, NS.
*>                        a multi-shift QR iteration.
*>
*>                        If IHI-ILO+1 is ...
*>
*>                        greater than      ...but less    ... the
*>                        or equal to ...      than        default is
*>
*>                                0               30       NS =   2+
*>                               30               60       NS =   4+
*>                               60              150       NS =  10
*>                              150              590       NS =  **
*>                              590             3000       NS =  64
*>                             3000             6000       NS = 128
*>                             6000             infinity   NS = 256
*>
*>                    (+)  By default matrices of this order are
*>                         passed to the implicit double shift routine
*>                         xLAHQR.  See IPARMQ(ISPEC=12) above.   These
*>                         values of NS are used only in case of a rare
*>                         xLAHQR failure.
*>
*>                    (**) The asterisks (**) indicate an ad-hoc
*>                         function increasing from 10 to 64.
*>
*>       IPARMQ(ISPEC=16) Select structured matrix multiply.
*>                        (See ISPEC=16 above for details.)
*>                        Default: 3.
*> \endverbatim
*>
*  =====================================================================
      INTEGER FUNCTION IPARMQ( ISPEC, NAME, OPTS, N, ILO, IHI, LWORK )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            IHI, ILO, ISPEC, LWORK, N
      CHARACTER          NAME*( * ), OPTS*( * )
*
*  ================================================================
*     .. Parameters ..
      INTEGER            INMIN, INWIN, INIBL, ISHFTS, IACC22
      PARAMETER          ( INMIN = 12, INWIN = 13, INIBL = 14,
     $                   ISHFTS = 15, IACC22 = 16 )
      INTEGER            NMIN, K22MIN, KACMIN, NIBBLE, KNWSWP
      PARAMETER          ( NMIN = 75, K22MIN = 14, KACMIN = 14,
     $                   NIBBLE = 14, KNWSWP = 500 )
      REAL               TWO
      PARAMETER          ( TWO = 2.0 )
*     ..
*     .. Local Scalars ..
      INTEGER            NH, NS
      INTEGER            I, IC, IZ
      CHARACTER          SUBNAM*6
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          LOG, MAX, MOD, NINT, REAL
*     ..
*     .. Executable Statements ..
      IF( ( ISPEC.EQ.ISHFTS ) .OR. ( ISPEC.EQ.INWIN ) .OR.
     $    ( ISPEC.EQ.IACC22 ) ) THEN
*
*        ==== Set the number simultaneous shifts ====
*
         NH = IHI - ILO + 1
         NS = 2
         IF( NH.GE.30 )
     $      NS = 4
         IF( NH.GE.60 )
     $      NS = 10
         IF( NH.GE.150 )
     $      NS = MAX( 10, NH / NINT( LOG( REAL( NH ) ) / LOG( TWO ) ) )
         IF( NH.GE.590 )
     $      NS = 64
         IF( NH.GE.3000 )
     $      NS = 128
         IF( NH.GE.6000 )
     $      NS = 256
         NS = MAX( 2, NS-MOD( NS, 2 ) )
      END IF
*
      IF( ISPEC.EQ.INMIN ) THEN
*
*
*        ===== Matrices of order smaller than NMIN get sent
*        .     to xLAHQR, the classic double shift algorithm.
*        .     This must be at least 11. ====
*
         IPARMQ = NMIN
*
      ELSE IF( ISPEC.EQ.INIBL ) THEN
*
*        ==== INIBL: skip a multi-shift qr iteration and
*        .    whenever aggressive early deflation finds
*        .    at least (NIBBLE*(window size)/100) deflations. ====
*
         IPARMQ = NIBBLE
*
      ELSE IF( ISPEC.EQ.ISHFTS ) THEN
*
*        ==== NSHFTS: The number of simultaneous shifts =====
*
         IPARMQ = NS
*
      ELSE IF( ISPEC.EQ.INWIN ) THEN
*
*        ==== NW: deflation window size.  ====
*
         IF( NH.LE.KNWSWP ) THEN
            IPARMQ = NS
         ELSE
            IPARMQ = 3*NS / 2
         END IF
*
      ELSE IF( ISPEC.EQ.IACC22 ) THEN
*
*        ==== IACC22: Whether to accumulate reflections
*        .     before updating the far-from-diagonal elements
*        .     and whether to use 2-by-2 block structure while
*        .     doing it.  A small amount of work could be saved
*        .     by making this choice dependent also upon the
*        .     NH=IHI-ILO+1.
*
*
*        Convert NAME to upper case if the first character is lower case.
*
         IPARMQ = 0
         SUBNAM = NAME
         IC = ICHAR( SUBNAM( 1: 1 ) )
         IZ = ICHAR( 'Z' )
         IF( IZ.EQ.90 .OR. IZ.EQ.122 ) THEN
*
*           ASCII character set
*
            IF( IC.GE.97 .AND. IC.LE.122 ) THEN
               SUBNAM( 1: 1 ) = CHAR( IC-32 )
               DO I = 2, 6
                  IC = ICHAR( SUBNAM( I: I ) )
                  IF( IC.GE.97 .AND. IC.LE.122 )
     $               SUBNAM( I: I ) = CHAR( IC-32 )
               END DO
            END IF
*
         ELSE IF( IZ.EQ.233 .OR. IZ.EQ.169 ) THEN
*
*           EBCDIC character set
*
            IF( ( IC.GE.129 .AND. IC.LE.137 ) .OR.
     $          ( IC.GE.145 .AND. IC.LE.153 ) .OR.
     $          ( IC.GE.162 .AND. IC.LE.169 ) ) THEN
               SUBNAM( 1: 1 ) = CHAR( IC+64 )
               DO I = 2, 6
                  IC = ICHAR( SUBNAM( I: I ) )
                  IF( ( IC.GE.129 .AND. IC.LE.137 ) .OR.
     $                ( IC.GE.145 .AND. IC.LE.153 ) .OR.
     $                ( IC.GE.162 .AND. IC.LE.169 ) )SUBNAM( I:
     $                I ) = CHAR( IC+64 )
               END DO
            END IF
*
         ELSE IF( IZ.EQ.218 .OR. IZ.EQ.250 ) THEN
*
*           Prime machines:  ASCII+128
*
            IF( IC.GE.225 .AND. IC.LE.250 ) THEN
               SUBNAM( 1: 1 ) = CHAR( IC-32 )
               DO I = 2, 6
                  IC = ICHAR( SUBNAM( I: I ) )
                  IF( IC.GE.225 .AND. IC.LE.250 )
     $               SUBNAM( I: I ) = CHAR( IC-32 )
               END DO
            END IF
         END IF
*
         IF( SUBNAM( 2:6 ).EQ.'GGHRD' .OR.
     $       SUBNAM( 2:6 ).EQ.'GGHD3' ) THEN
            IPARMQ = 1
            IF( NH.GE.K22MIN )
     $         IPARMQ = 2
         ELSE IF ( SUBNAM( 4:6 ).EQ.'EXC' ) THEN
            IF( NH.GE.KACMIN )
     $         IPARMQ = 1
            IF( NH.GE.K22MIN )
     $         IPARMQ = 2
         ELSE IF ( SUBNAM( 2:6 ).EQ.'HSEQR' .OR.
     $             SUBNAM( 2:5 ).EQ.'LAQR' ) THEN
            IF( NS.GE.KACMIN )
     $         IPARMQ = 1
            IF( NS.GE.K22MIN )
     $         IPARMQ = 2
         END IF
*
      ELSE
*        ===== invalid value of ispec =====
         IPARMQ = -1
*
      END IF
*
*     ==== End of IPARMQ ====
*
      END
*> \brief \b LSAME
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*  Definition:
*  ===========
*
*      LOGICAL FUNCTION LSAME( CA, CB )
*
*     .. Scalar Arguments ..
*      CHARACTER          CA, CB
*     ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> LSAME returns .TRUE. if CA is the same letter as CB regardless of
*> case.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] CA
*> \verbatim
*> \endverbatim
*>
*> \param[in] CB
*> \verbatim
*>          CA and CB specify the single characters to be compared.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup auxOTHERauxiliary
*
*  =====================================================================
      LOGICAL FUNCTION LSAME( CA, CB )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          CA, CB
*     ..
*
* =====================================================================
*
*     .. Intrinsic Functions ..
      INTRINSIC          ICHAR
*     ..
*     .. Local Scalars ..
      INTEGER            INTA, INTB, ZCODE
*     ..
*     .. Executable Statements ..
*
*     Test if the characters are equal
*
      LSAME = CA.EQ.CB
      IF( LSAME )
     $   RETURN
*
*     Now test for equivalence if both characters are alphabetic.
*
      ZCODE = ICHAR( 'Z' )
*
*     Use 'Z' rather than 'A' so that ASCII can be detected on Prime
*     machines, on which ICHAR returns a value with bit 8 set.
*     ICHAR('A') on Prime machines returns 193 which is the same as
*     ICHAR('A') on an EBCDIC machine.
*
      INTA = ICHAR( CA )
      INTB = ICHAR( CB )
*
      IF( ZCODE.EQ.90 .OR. ZCODE.EQ.122 ) THEN
*
*        ASCII is assumed - ZCODE is the ASCII code of either lower or
*        upper case 'Z'.
*
         IF( INTA.GE.97 .AND. INTA.LE.122 ) INTA = INTA - 32
         IF( INTB.GE.97 .AND. INTB.LE.122 ) INTB = INTB - 32
*
      ELSE IF( ZCODE.EQ.233 .OR. ZCODE.EQ.169 ) THEN
*
*        EBCDIC is assumed - ZCODE is the EBCDIC code of either lower or
*        upper case 'Z'.
*
         IF( INTA.GE.129 .AND. INTA.LE.137 .OR.
     $       INTA.GE.145 .AND. INTA.LE.153 .OR.
     $       INTA.GE.162 .AND. INTA.LE.169 ) INTA = INTA + 64
         IF( INTB.GE.129 .AND. INTB.LE.137 .OR.
     $       INTB.GE.145 .AND. INTB.LE.153 .OR.
     $       INTB.GE.162 .AND. INTB.LE.169 ) INTB = INTB + 64
*
      ELSE IF( ZCODE.EQ.218 .OR. ZCODE.EQ.250 ) THEN
*
*        ASCII is assumed, on Prime machines - ZCODE is the ASCII code
*        plus 128 of either lower or upper case 'Z'.
*
         IF( INTA.GE.225 .AND. INTA.LE.250 ) INTA = INTA - 32
         IF( INTB.GE.225 .AND. INTB.LE.250 ) INTB = INTB - 32
      END IF
      LSAME = INTA.EQ.INTB
*
*     RETURN
*
*     End of LSAME
*
      END
*> \brief \b SLADIV performs complex division in real arithmetic, avoiding unnecessary overflow.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download SLADIV + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/sladiv.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/sladiv.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/sladiv.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE SLADIV( A, B, C, D, P, Q )
*
*       .. Scalar Arguments ..
*       REAL               A, B, C, D, P, Q
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLADIV performs complex division in  real arithmetic
*>
*>                       a + i*b
*>            p + i*q = ---------
*>                       c + i*d
*>
*> The algorithm is due to Michael Baudin and Robert L. Smith
*> and can be found in the paper
*> "A Robust Complex Division in Scilab"
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] A
*> \verbatim
*>          A is REAL
*> \endverbatim
*>
*> \param[in] B
*> \verbatim
*>          B is REAL
*> \endverbatim
*>
*> \param[in] C
*> \verbatim
*>          C is REAL
*> \endverbatim
*>
*> \param[in] D
*> \verbatim
*>          D is REAL
*>          The scalars a, b, c, and d in the above expression.
*> \endverbatim
*>
*> \param[out] P
*> \verbatim
*>          P is REAL
*> \endverbatim
*>
*> \param[out] Q
*> \verbatim
*>          Q is REAL
*>          The scalars p and q in the above expression.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date January 2013
*
*> \ingroup realOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE SLADIV( A, B, C, D, P, Q )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     January 2013
*
*     .. Scalar Arguments ..
      REAL               A, B, C, D, P, Q
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               BS
      PARAMETER          ( BS = 2.0E0 )
      REAL               HALF
      PARAMETER          ( HALF = 0.5E0 )
      REAL               TWO
      PARAMETER          ( TWO = 2.0E0 )
*
*     .. Local Scalars ..
      REAL               AA, BB, CC, DD, AB, CD, S, OV, UN, BE, EPS
*     ..
*     .. External Functions ..
      REAL               SLAMCH
      EXTERNAL           SLAMCH
*     ..
*     .. External Subroutines ..
      EXTERNAL           SLADIV1
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, MAX
*     ..
*     .. Executable Statements ..
*
      AA = A
      BB = B
      CC = C
      DD = D
      AB = MAX( ABS(A), ABS(B) )
      CD = MAX( ABS(C), ABS(D) )
      S = 1.0E0

      OV = SLAMCH( 'Overflow threshold' )
      UN = SLAMCH( 'Safe minimum' )
      EPS = SLAMCH( 'Epsilon' )
      BE = BS / (EPS*EPS)

      IF( AB >= HALF*OV ) THEN
         AA = HALF * AA
         BB = HALF * BB
         S  = TWO * S
      END IF
      IF( CD >= HALF*OV ) THEN
         CC = HALF * CC
         DD = HALF * DD
         S  = HALF * S
      END IF
      IF( AB <= UN*BS/EPS ) THEN
         AA = AA * BE
         BB = BB * BE
         S  = S / BE
      END IF
      IF( CD <= UN*BS/EPS ) THEN
         CC = CC * BE
         DD = DD * BE
         S  = S * BE
      END IF
      IF( ABS( D ).LE.ABS( C ) ) THEN
         CALL SLADIV1(AA, BB, CC, DD, P, Q)
      ELSE
         CALL SLADIV1(BB, AA, DD, CC, P, Q)
         Q = -Q
      END IF
      P = P * S
      Q = Q * S
*
      RETURN
*
*     End of SLADIV
*
      END

*> \ingroup realOTHERauxiliary


      SUBROUTINE SLADIV1( A, B, C, D, P, Q )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     January 2013
*
*     .. Scalar Arguments ..
      REAL               A, B, C, D, P, Q
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ONE
      PARAMETER          ( ONE = 1.0E0 )
*
*     .. Local Scalars ..
      REAL               R, T
*     ..
*     .. External Functions ..
      REAL               SLADIV2
      EXTERNAL           SLADIV2
*     ..
*     .. Executable Statements ..
*
      R = D / C
      T = ONE / (C + D * R)
      P = SLADIV2(A, B, C, D, R, T)
      A = -A
      Q = SLADIV2(B, A, C, D, R, T)
*
      RETURN
*
*     End of SLADIV1
*
      END

*> \ingroup realOTHERauxiliary

      REAL FUNCTION SLADIV2( A, B, C, D, R, T )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     January 2013
*
*     .. Scalar Arguments ..
      REAL               A, B, C, D, R, T
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ZERO
      PARAMETER          ( ZERO = 0.0E0 )
*
*     .. Local Scalars ..
      REAL               BR
*     ..
*     .. Executable Statements ..
*
      IF( R.NE.ZERO ) THEN
         BR = B * R
         if( BR.NE.ZERO ) THEN
            SLADIV2 = (A + BR) * T
         ELSE
            SLADIV2 = A * T + (B * T) * R
         END IF
      ELSE
         SLADIV2 = (A + D * (B / C)) * T
      END IF
*
      RETURN
*
*     End of SLADIV
*
      END
*> \brief \b SLAMCH
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*  Definition:
*  ===========
*
*      REAL             FUNCTION SLAMCH( CMACH )
*
*     .. Scalar Arguments ..
*      CHARACTER          CMACH
*     ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLAMCH determines single precision machine parameters.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] CMACH
*> \verbatim
*>          Specifies the value to be returned by SLAMCH:
*>          = 'E' or 'e',   SLAMCH := eps
*>          = 'S' or 's ,   SLAMCH := sfmin
*>          = 'B' or 'b',   SLAMCH := base
*>          = 'P' or 'p',   SLAMCH := eps*base
*>          = 'N' or 'n',   SLAMCH := t
*>          = 'R' or 'r',   SLAMCH := rnd
*>          = 'M' or 'm',   SLAMCH := emin
*>          = 'U' or 'u',   SLAMCH := rmin
*>          = 'L' or 'l',   SLAMCH := emax
*>          = 'O' or 'o',   SLAMCH := rmax
*>          where
*>          eps   = relative machine precision
*>          sfmin = safe minimum, such that 1/sfmin does not overflow
*>          base  = base of the machine
*>          prec  = eps*base
*>          t     = number of (base) digits in the mantissa
*>          rnd   = 1.0 when rounding occurs in addition, 0.0 otherwise
*>          emin  = minimum exponent before (gradual) underflow
*>          rmin  = underflow threshold - base**(emin-1)
*>          emax  = largest exponent before overflow
*>          rmax  = overflow threshold  - (base**emax)*(1-eps)
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup auxOTHERauxiliary
*
*  =====================================================================
      REAL             FUNCTION SLAMCH( CMACH )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          CMACH
*     ..
*
* =====================================================================
*
*     .. Parameters ..
      REAL               ONE, ZERO
      PARAMETER          ( ONE = 1.0E+0, ZERO = 0.0E+0 )
*     ..
*     .. Local Scalars ..
      REAL               RND, EPS, SFMIN, SMALL, RMACH
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          DIGITS, EPSILON, HUGE, MAXEXPONENT,
     $                   MINEXPONENT, RADIX, TINY
*     ..
*     .. Executable Statements ..
*
*
*     Assume rounding, not chopping. Always.
*
      RND = ONE
*
      IF( ONE.EQ.RND ) THEN
         EPS = EPSILON(ZERO) * 0.5
      ELSE
         EPS = EPSILON(ZERO)
      END IF
*
      IF( LSAME( CMACH, 'E' ) ) THEN
         RMACH = EPS
      ELSE IF( LSAME( CMACH, 'S' ) ) THEN
         SFMIN = TINY(ZERO)
         SMALL = ONE / HUGE(ZERO)
         IF( SMALL.GE.SFMIN ) THEN
*
*           Use SMALL plus a bit, to avoid the possibility of rounding
*           causing overflow when computing  1/sfmin.
*
            SFMIN = SMALL*( ONE+EPS )
         END IF
         RMACH = SFMIN
      ELSE IF( LSAME( CMACH, 'B' ) ) THEN
         RMACH = RADIX(ZERO)
      ELSE IF( LSAME( CMACH, 'P' ) ) THEN
         RMACH = EPS * RADIX(ZERO)
      ELSE IF( LSAME( CMACH, 'N' ) ) THEN
         RMACH = DIGITS(ZERO)
      ELSE IF( LSAME( CMACH, 'R' ) ) THEN
         RMACH = RND
      ELSE IF( LSAME( CMACH, 'M' ) ) THEN
         RMACH = MINEXPONENT(ZERO)
      ELSE IF( LSAME( CMACH, 'U' ) ) THEN
         RMACH = tiny(zero)
      ELSE IF( LSAME( CMACH, 'L' ) ) THEN
         RMACH = MAXEXPONENT(ZERO)
      ELSE IF( LSAME( CMACH, 'O' ) ) THEN
         RMACH = HUGE(ZERO)
      ELSE
         RMACH = ZERO
      END IF
*
      SLAMCH = RMACH
      RETURN
*
*     End of SLAMCH
*
      END
************************************************************************
*> \brief \b SLAMC3
*> \details
*> \b Purpose:
*> \verbatim
*> SLAMC3  is intended to force  A  and  B  to be stored prior to doing
*> the addition of  A  and  B ,  for use in situations where optimizers
*> might hold one of these in a register.
*> \endverbatim
*> \author LAPACK is a software package provided by Univ. of Tennessee, Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..
*> \date December 2016
*> \ingroup auxOTHERauxiliary
*>
*> \param[in] A
*> \verbatim
*> \endverbatim
*>
*> \param[in] B
*> \verbatim
*>          The values A and B.
*> \endverbatim
*>
*
      REAL             FUNCTION SLAMC3( A, B )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*     Univ. of Tennessee, Univ. of California Berkeley and NAG Ltd..
*     November 2010
*
*     .. Scalar Arguments ..
      REAL               A, B
*     ..
* =====================================================================
*
*     .. Executable Statements ..
*
      SLAMC3 = A + B
*
      RETURN
*
*     End of SLAMC3
*
      END
*
************************************************************************
*> \brief \b SLAPY2 returns sqrt(x2+y2).
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download SLAPY2 + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/slapy2.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/slapy2.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/slapy2.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       REAL             FUNCTION SLAPY2( X, Y )
*
*       .. Scalar Arguments ..
*       REAL               X, Y
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLAPY2 returns sqrt(x**2+y**2), taking care not to cause unnecessary
*> overflow.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] X
*> \verbatim
*>          X is REAL
*> \endverbatim
*>
*> \param[in] Y
*> \verbatim
*>          Y is REAL
*>          X and Y specify the values x and y.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*  =====================================================================
      REAL             FUNCTION SLAPY2( X, Y )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      REAL               X, Y
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ZERO
      PARAMETER          ( ZERO = 0.0E0 )
      REAL               ONE
      PARAMETER          ( ONE = 1.0E0 )
*     ..
*     .. Local Scalars ..
      REAL               W, XABS, YABS, Z
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, MAX, MIN, SQRT
*     ..
*     .. Executable Statements ..
*
      XABS = ABS( X )
      YABS = ABS( Y )
      W = MAX( XABS, YABS )
      Z = MIN( XABS, YABS )
      IF( Z.EQ.ZERO ) THEN
         SLAPY2 = W
      ELSE
         SLAPY2 = W*SQRT( ONE+( Z / W )**2 )
      END IF
      RETURN
*
*     End of SLAPY2
*
      END
*> \brief \b SLAPY3 returns sqrt(x2+y2+z2).
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download SLAPY3 + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/slapy3.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/slapy3.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/slapy3.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       REAL             FUNCTION SLAPY3( X, Y, Z )
*
*       .. Scalar Arguments ..
*       REAL               X, Y, Z
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLAPY3 returns sqrt(x**2+y**2+z**2), taking care not to cause
*> unnecessary overflow.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] X
*> \verbatim
*>          X is REAL
*> \endverbatim
*>
*> \param[in] Y
*> \verbatim
*>          Y is REAL
*> \endverbatim
*>
*> \param[in] Z
*> \verbatim
*>          Z is REAL
*>          X, Y and Z specify the values x, y and z.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*  =====================================================================
      REAL             FUNCTION SLAPY3( X, Y, Z )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      REAL               X, Y, Z
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ZERO
      PARAMETER          ( ZERO = 0.0E0 )
*     ..
*     .. Local Scalars ..
      REAL               W, XABS, YABS, ZABS
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, MAX, SQRT
*     ..
*     .. Executable Statements ..
*
      XABS = ABS( X )
      YABS = ABS( Y )
      ZABS = ABS( Z )
      W = MAX( XABS, YABS, ZABS )
      IF( W.EQ.ZERO ) THEN
*     W can be zero for max(0,nan,0)
*     adding all three entries together will make sure
*     NaN will not disappear.
         SLAPY3 =  XABS + YABS + ZABS
      ELSE
         SLAPY3 = W*SQRT( ( XABS / W )**2+( YABS / W )**2+
     $            ( ZABS / W )**2 )
      END IF
      RETURN
*
*     End of SLAPY3
*
      END
*> \brief \b SLARTGP generates a plane rotation so that the diagonal is nonnegative.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download SLARTGP + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/slartgp.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/slartgp.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/slartgp.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE SLARTGP( F, G, CS, SN, R )
*
*       .. Scalar Arguments ..
*       REAL               CS, F, G, R, SN
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLARTGP generates a plane rotation so that
*>
*>    [  CS  SN  ]  .  [ F ]  =  [ R ]   where CS**2 + SN**2 = 1.
*>    [ -SN  CS  ]     [ G ]     [ 0 ]
*>
*> This is a slower, more accurate version of the Level 1 BLAS routine SROTG,
*> with the following other differences:
*>    F and G are unchanged on return.
*>    If G=0, then CS=(+/-)1 and SN=0.
*>    If F=0 and (G .ne. 0), then CS=0 and SN=(+/-)1.
*>
*> The sign is chosen so that R >= 0.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] F
*> \verbatim
*>          F is REAL
*>          The first component of vector to be rotated.
*> \endverbatim
*>
*> \param[in] G
*> \verbatim
*>          G is REAL
*>          The second component of vector to be rotated.
*> \endverbatim
*>
*> \param[out] CS
*> \verbatim
*>          CS is REAL
*>          The cosine of the rotation.
*> \endverbatim
*>
*> \param[out] SN
*> \verbatim
*>          SN is REAL
*>          The sine of the rotation.
*> \endverbatim
*>
*> \param[out] R
*> \verbatim
*>          R is REAL
*>          The nonzero component of the rotated vector.
*>
*>  This version has a few statements commented out for thread safety
*>  (machine parameters are computed on each entry). 10 feb 03, SJH.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*  =====================================================================
      SUBROUTINE SLARTGP( F, G, CS, SN, R )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      REAL               CS, F, G, R, SN
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ZERO
      PARAMETER          ( ZERO = 0.0E0 )
      REAL               ONE
      PARAMETER          ( ONE = 1.0E0 )
      REAL               TWO
      PARAMETER          ( TWO = 2.0E0 )
*     ..
*     .. Local Scalars ..
*     LOGICAL            FIRST
      INTEGER            COUNT, I
      REAL               EPS, F1, G1, SAFMIN, SAFMN2, SAFMX2, SCALE
*     ..
*     .. External Functions ..
      REAL               SLAMCH
      EXTERNAL           SLAMCH
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, INT, LOG, MAX, SIGN, SQRT
*     ..
*     .. Save statement ..
*     SAVE               FIRST, SAFMX2, SAFMIN, SAFMN2
*     ..
*     .. Data statements ..
*     DATA               FIRST / .TRUE. /
*     ..
*     .. Executable Statements ..
*
*     IF( FIRST ) THEN
         SAFMIN = SLAMCH( 'S' )
         EPS = SLAMCH( 'E' )
         SAFMN2 = SLAMCH( 'B' )**INT( LOG( SAFMIN / EPS ) /
     $            LOG( SLAMCH( 'B' ) ) / TWO )
         SAFMX2 = ONE / SAFMN2
*        FIRST = .FALSE.
*     END IF
      IF( G.EQ.ZERO ) THEN
         CS = SIGN( ONE, F )
         SN = ZERO
         R = ABS( F )
      ELSE IF( F.EQ.ZERO ) THEN
         CS = ZERO
         SN = SIGN( ONE, G )
         R = ABS( G )
      ELSE
         F1 = F
         G1 = G
         SCALE = MAX( ABS( F1 ), ABS( G1 ) )
         IF( SCALE.GE.SAFMX2 ) THEN
            COUNT = 0
   10       CONTINUE
            COUNT = COUNT + 1
            F1 = F1*SAFMN2
            G1 = G1*SAFMN2
            SCALE = MAX( ABS( F1 ), ABS( G1 ) )
            IF( SCALE.GE.SAFMX2 )
     $         GO TO 10
            R = SQRT( F1**2+G1**2 )
            CS = F1 / R
            SN = G1 / R
            DO 20 I = 1, COUNT
               R = R*SAFMX2
   20       CONTINUE
         ELSE IF( SCALE.LE.SAFMN2 ) THEN
            COUNT = 0
   30       CONTINUE
            COUNT = COUNT + 1
            F1 = F1*SAFMX2
            G1 = G1*SAFMX2
            SCALE = MAX( ABS( F1 ), ABS( G1 ) )
            IF( SCALE.LE.SAFMN2 )
     $         GO TO 30
            R = SQRT( F1**2+G1**2 )
            CS = F1 / R
            SN = G1 / R
            DO 40 I = 1, COUNT
               R = R*SAFMN2
   40       CONTINUE
         ELSE
            R = SQRT( F1**2+G1**2 )
            CS = F1 / R
            SN = G1 / R
         END IF
         IF( R.LT.ZERO ) THEN
            CS = -CS
            SN = -SN
            R = -R
         END IF
      END IF
      RETURN
*
*     End of SLARTG
*
      END
*> \brief \b SLARTGS generates a plane rotation designed to introduce a bulge in implicit QR iteration for the bidiagonal SVD problem.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download SLARTGS + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/slartgs.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/slartgs.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/slartgs.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE SLARTGS( X, Y, SIGMA, CS, SN )
*
*       .. Scalar Arguments ..
*       REAL                    CS, SIGMA, SN, X, Y
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLARTGS generates a plane rotation designed to introduce a bulge in
*> Golub-Reinsch-style implicit QR iteration for the bidiagonal SVD
*> problem. X and Y are the top-row entries, and SIGMA is the shift.
*> The computed CS and SN define a plane rotation satisfying
*>
*>    [  CS  SN  ]  .  [ X^2 - SIGMA ]  =  [ R ],
*>    [ -SN  CS  ]     [    X * Y    ]     [ 0 ]
*>
*> with R nonnegative.  If X^2 - SIGMA and X * Y are 0, then the
*> rotation is by PI/2.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] X
*> \verbatim
*>          X is REAL
*>          The (1,1) entry of an upper bidiagonal matrix.
*> \endverbatim
*>
*> \param[in] Y
*> \verbatim
*>          Y is REAL
*>          The (1,2) entry of an upper bidiagonal matrix.
*> \endverbatim
*>
*> \param[in] SIGMA
*> \verbatim
*>          SIGMA is REAL
*>          The shift.
*> \endverbatim
*>
*> \param[out] CS
*> \verbatim
*>          CS is REAL
*>          The cosine of the rotation.
*> \endverbatim
*>
*> \param[out] SN
*> \verbatim
*>          SN is REAL
*>          The sine of the rotation.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup auxOTHERcomputational
*
*  =====================================================================
      SUBROUTINE SLARTGS( X, Y, SIGMA, CS, SN )
*
*  -- LAPACK computational routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      REAL                    CS, SIGMA, SN, X, Y
*     ..
*
*  ===================================================================
*
*     .. Parameters ..
      REAL                    NEGONE, ONE, ZERO
      PARAMETER          ( NEGONE = -1.0E0, ONE = 1.0E0, ZERO = 0.0E0 )
*     ..
*     .. Local Scalars ..
      REAL                    R, S, THRESH, W, Z
*     ..
*     .. External Functions ..
      REAL                    SLAMCH
      EXTERNAL           SLAMCH
*     .. Executable Statements ..
*
      THRESH = SLAMCH('E')
*
*     Compute the first column of B**T*B - SIGMA^2*I, up to a scale
*     factor.
*
      IF( (SIGMA .EQ. ZERO .AND. ABS(X) .LT. THRESH) .OR.
     $          (ABS(X) .EQ. SIGMA .AND. Y .EQ. ZERO) ) THEN
         Z = ZERO
         W = ZERO
      ELSE IF( SIGMA .EQ. ZERO ) THEN
         IF( X .GE. ZERO ) THEN
            Z = X
            W = Y
         ELSE
            Z = -X
            W = -Y
         END IF
      ELSE IF( ABS(X) .LT. THRESH ) THEN
         Z = -SIGMA*SIGMA
         W = ZERO
      ELSE
         IF( X .GE. ZERO ) THEN
            S = ONE
         ELSE
            S = NEGONE
         END IF
         Z = S * (ABS(X)-SIGMA) * (S+SIGMA/X)
         W = S * Y
      END IF
*
*     Generate the rotation.
*     CALL SLARTGP( Z, W, CS, SN, R ) might seem more natural;
*     reordering the arguments ensures that if Z = 0 then the rotation
*     is by PI/2.
*
      CALL SLARTGP( W, Z, SN, CS, R )
*
      RETURN
*
*     End SLARTGS
*
      END

*> \brief \b SLAS2 computes singular values of a 2-by-2 triangular matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download SLAS2 + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/slas2.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/slas2.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/slas2.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE SLAS2( F, G, H, SSMIN, SSMAX )
*
*       .. Scalar Arguments ..
*       REAL               F, G, H, SSMAX, SSMIN
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLAS2  computes the singular values of the 2-by-2 matrix
*>    [  F   G  ]
*>    [  0   H  ].
*> On return, SSMIN is the smaller singular value and SSMAX is the
*> larger singular value.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] F
*> \verbatim
*>          F is REAL
*>          The (1,1) element of the 2-by-2 matrix.
*> \endverbatim
*>
*> \param[in] G
*> \verbatim
*>          G is REAL
*>          The (1,2) element of the 2-by-2 matrix.
*> \endverbatim
*>
*> \param[in] H
*> \verbatim
*>          H is REAL
*>          The (2,2) element of the 2-by-2 matrix.
*> \endverbatim
*>
*> \param[out] SSMIN
*> \verbatim
*>          SSMIN is REAL
*>          The smaller singular value.
*> \endverbatim
*>
*> \param[out] SSMAX
*> \verbatim
*>          SSMAX is REAL
*>          The larger singular value.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  Barring over/underflow, all output quantities are correct to within
*>  a few units in the last place (ulps), even in the absence of a guard
*>  digit in addition/subtraction.
*>
*>  In IEEE arithmetic, the code works correctly if one matrix element is
*>  infinite.
*>
*>  Overflow will not occur unless the largest singular value itself
*>  overflows, or is within a few ulps of overflow. (On machines with
*>  partial overflow, like the Cray, overflow may occur if the largest
*>  singular value is within a factor of 2 of overflow.)
*>
*>  Underflow is harmless if underflow is gradual. Otherwise, results
*>  may correspond to a matrix modified by perturbations of size near
*>  the underflow threshold.
*> \endverbatim
*>
*  =====================================================================
      SUBROUTINE SLAS2( F, G, H, SSMIN, SSMAX )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      REAL               F, G, H, SSMAX, SSMIN
*     ..
*
*  ====================================================================
*
*     .. Parameters ..
      REAL               ZERO
      PARAMETER          ( ZERO = 0.0E0 )
      REAL               ONE
      PARAMETER          ( ONE = 1.0E0 )
      REAL               TWO
      PARAMETER          ( TWO = 2.0E0 )
*     ..
*     .. Local Scalars ..
      REAL               AS, AT, AU, C, FA, FHMN, FHMX, GA, HA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, MAX, MIN, SQRT
*     ..
*     .. Executable Statements ..
*
      FA = ABS( F )
      GA = ABS( G )
      HA = ABS( H )
      FHMN = MIN( FA, HA )
      FHMX = MAX( FA, HA )
      IF( FHMN.EQ.ZERO ) THEN
         SSMIN = ZERO
         IF( FHMX.EQ.ZERO ) THEN
            SSMAX = GA
         ELSE
            SSMAX = MAX( FHMX, GA )*SQRT( ONE+
     $              ( MIN( FHMX, GA ) / MAX( FHMX, GA ) )**2 )
         END IF
      ELSE
         IF( GA.LT.FHMX ) THEN
            AS = ONE + FHMN / FHMX
            AT = ( FHMX-FHMN ) / FHMX
            AU = ( GA / FHMX )**2
            C = TWO / ( SQRT( AS*AS+AU )+SQRT( AT*AT+AU ) )
            SSMIN = FHMN*C
            SSMAX = FHMX / C
         ELSE
            AU = FHMX / GA
            IF( AU.EQ.ZERO ) THEN
*
*              Avoid possible harmful underflow if exponent range
*              asymmetric (true SSMIN may not underflow even if
*              AU underflows)
*
               SSMIN = ( FHMN*FHMX ) / GA
               SSMAX = GA
            ELSE
               AS = ONE + FHMN / FHMX
               AT = ( FHMX-FHMN ) / FHMX
               C = ONE / ( SQRT( ONE+( AS*AU )**2 )+
     $             SQRT( ONE+( AT*AU )**2 ) )
               SSMIN = ( FHMN*C )*AU
               SSMIN = SSMIN + SSMIN
               SSMAX = GA / ( C+C )
            END IF
         END IF
      END IF
      RETURN
*
*     End of SLAS2
*
      END
*> \brief \b XERBLA
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download XERBLA + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/xerbla.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/xerbla.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/xerbla.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE XERBLA( SRNAME, INFO )
*
*       .. Scalar Arguments ..
*       CHARACTER*(*)      SRNAME
*       INTEGER            INFO
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> XERBLA  is an error handler for the LAPACK routines.
*> It is called by an LAPACK routine if an input parameter has an
*> invalid value.  A message is printed and execution stops.
*>
*> Installers may consider modifying the STOP statement in order to
*> call system-specific exception-handling facilities.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] SRNAME
*> \verbatim
*>          SRNAME is CHARACTER*(*)
*>          The name of the routine which called XERBLA.
*> \endverbatim
*>
*> \param[in] INFO
*> \verbatim
*>          INFO is INTEGER
*>          The position of the invalid parameter in the parameter list
*>          of the calling routine.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*  =====================================================================
      SUBROUTINE XERBLA( SRNAME, INFO )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER*(*)      SRNAME
      INTEGER            INFO
*     ..
*
* =====================================================================
*
*     .. Intrinsic Functions ..
      INTRINSIC          LEN_TRIM
*     ..
*     .. Executable Statements ..
*
      WRITE( *, FMT = 9999 )SRNAME( 1:LEN_TRIM( SRNAME ) ), INFO
*
      STOP
*
 9999 FORMAT( ' ** On entry to ', A, ' parameter number ', I2, ' had ',
     $      'an illegal value' )
*
*     End of XERBLA
*
      END
