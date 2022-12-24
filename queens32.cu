#include "generator.cuh"

__device__ __host__ BOARD getBit(MBOARD32 B, BOARD b) {
  BOARD d = b/64;
  BOARD r  = b % 64;
  return ((1ULL << r) & B.board[d]);
}

__device__ __host__ MBOARD32 bishopDiagonal1() {
  BOARD B1 = 1ULL | 1ULL << 33;
  BOARD B2 = B1 << 2;
  BOARD B3 = B2 << 2;
  BOARD B4 = B3 << 2;
  BOARD B5 = B4 << 2;
  BOARD B6 = B5 << 2;
  BOARD B7 = B6 << 2;
  BOARD B8 = B7 << 2;
  BOARD B9 = B8 << 2;
  BOARD B10 = B9 << 2;
  BOARD B11 = B10 << 2;
  BOARD B12 = B11 << 2;
  BOARD B13 = B12 << 2;
  BOARD B14 = B13 << 2;
  BOARD B15 = B14 << 2;
  BOARD B16 = B15 << 2;

  return (MBOARD32){.board = {B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16}};
}

__device__ __host__ MBOARD32 bishopDiagonal2() {
  BOARD B1 = 1ULL << 31 | 1ULL << 62;
  BOARD B2 = B1 >> 2;
  BOARD B3 = B2 >> 2;
  BOARD B4 = B3 >> 2;
  BOARD B5 = B4 >> 2;
  BOARD B6 = B5 >> 2;
  BOARD B7 = B6 >> 2;
  BOARD B8 = B7 >> 2;
  BOARD B9 = B8 >> 2;
  BOARD B10 = B9 >> 2;
  BOARD B11 = B10 >> 2;
  BOARD B12 = B11 >> 2;
  BOARD B13 = B12 >> 2;
  BOARD B14 = B13 >> 2;
  BOARD B15 = B14 >> 2;
  BOARD B16 = B15 >> 2;

  return (MBOARD32){.board = {B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16}};
}

__device__ __host__ MBOARD32 compliment(MBOARD32 B) {
  MBOARD32 C = B;
  for(int i = 0; i < 16; ++i) {
    C.board[i] = ~B.board[i];
  }
  return C;
}

__device__ __host__ MBOARD32 LShift(MBOARD32 B,int k) {
  BOARD t = 0; //(B.board[0] & (((1ULL << (k)) - 1) << 64-k));
  for(int i = 0; i < 16; ++i) {
    BOARD T = B.board[i];
    B.board[i] = ((B.board[i] << k) | t);
    t = (T & (((1ULL << (k)) - 1) << 64-k)) >> 64-k;	
  }
  return B;
}

__device__ __host__ MBOARD32 RShift(MBOARD32 B,int k) {
  BOARD t = 0ULL; //B.board[0] & (((1ULL << k) - 1) << 64-k);
  for(int i = 16-1; i >= 0; --i) {
    BOARD T = B.board[i];
    B.board[i] = ((B.board[i] >> k) | t);
    t = (T & ((1ULL << (k)) - 1)) << 64-k;	
  }
  return B;
}

__device__ __host__ MBOARD32 RShiftBishop1(MBOARD32 mb, int k) {
  MBOARD32 r = mb;
  for(int i = 0; i < k; ++i) {
    r = RShift(r,1);
    int p = 31; 
    r.board[0] = ~(1ULL << p | 1ULL << (p+32)) & r.board[0];
    r.board[1] = ~(1ULL << p | 1ULL << (p+32)) & r.board[1];
    r.board[2] = ~(1ULL << p | 1ULL << (p+32)) & r.board[2];
    r.board[3] = ~(1ULL << p | 1ULL << (p+32)) & r.board[3];
    r.board[4] = ~(1ULL << p | 1ULL << (p+32)) & r.board[4];
    r.board[5] = ~(1ULL << p | 1ULL << (p+32)) & r.board[5];
    r.board[6] = ~(1ULL << p | 1ULL << (p+32)) & r.board[6];
    r.board[7] = ~(1ULL << p | 1ULL << (p+32)) & r.board[7];
    r.board[8] = ~(1ULL << p | 1ULL << (p+32)) & r.board[8];
    r.board[9] = ~(1ULL << p | 1ULL << (p+32)) & r.board[9];
    r.board[10] = ~(1ULL << p | 1ULL << (p+32)) & r.board[10];
    r.board[11] = ~(1ULL << p | 1ULL << (p+32)) & r.board[11];
    r.board[12] = ~(1ULL << p | 1ULL << (p+32)) & r.board[12];
    r.board[13] = ~(1ULL << p | 1ULL << (p+32)) & r.board[13];
    r.board[14] = ~(1ULL << p | 1ULL << (p+32)) & r.board[14];
    r.board[15] = ~(1ULL << p | 1ULL << (p+32)) & r.board[15];

  }
  return r;
}

__device__ __host__ MBOARD32 LShiftBishop1(MBOARD32 mb, int k) {
  MBOARD32 l = mb;
  for(int i = 0; i < k; ++i) {
    l = LShift(l,1);
    int p = 0;
    l.board[0] = ~(1ULL << p | 1ULL << (p+32)) & l.board[0];
    l.board[1] = ~(1ULL << p | 1ULL << (p+32)) & l.board[1];
    l.board[2] = ~(1ULL << p | 1ULL << (p+32)) & l.board[2];
    l.board[3] = ~(1ULL << p | 1ULL << (p+32)) & l.board[3];
    l.board[4] = ~(1ULL << p | 1ULL << (p+32)) & l.board[4];
    l.board[5] = ~(1ULL << p | 1ULL << (p+32)) & l.board[5];
    l.board[6] = ~(1ULL << p | 1ULL << (p+32)) & l.board[6];
    l.board[7] = ~(1ULL << p | 1ULL << (p+32)) & l.board[7];
    l.board[8] = ~(1ULL << p | 1ULL << (p+32)) & l.board[8];
    l.board[9] = ~(1ULL << p | 1ULL << (p+32)) & l.board[9];
    l.board[10] = ~(1ULL << p | 1ULL << (p+32)) & l.board[10];
    l.board[11] = ~(1ULL << p | 1ULL << (p+32)) & l.board[11];
    l.board[12] = ~(1ULL << p | 1ULL << (p+32)) & l.board[12];
    l.board[13] = ~(1ULL << p | 1ULL << (p+32)) & l.board[13];
    l.board[14] = ~(1ULL << p | 1ULL << (p+32)) & l.board[14];
    l.board[15] = ~(1ULL << p | 1ULL << (p+32)) & l.board[15];

  }
  return l;
}

__device__ __host__ MBOARD32 LShiftRook(MBOARD32 mb, int k) {
  MBOARD32 d = mb;
  for(int i = 0; i < k; ++i) {
    d = LShift(d,32);
  }
  return d;
}

__device__ __host__ MBOARD32 RShiftRook(MBOARD32 mb, int k) {
  MBOARD32 d = mb;
  for(int i = 0; i < k; ++i) {
    d = RShift(d,32);
  }
  return d;
}

__device__ __host__ MBOARD32 UShiftRook(MBOARD32 mb, int k) {
  MBOARD32 d = mb;
  for(int i = 0; i < k; ++i) {
    d = LShift(d,1);
  }
  return d;
}

__device__ __host__ MBOARD32 DShiftRook(MBOARD32 mb, int k) {
  MBOARD32 d = mb;
  for(int i = 0; i < k; ++i) {
    d = RShift(d,1);
  }
  return d;
}

__device__ __host__ void drawBoard(MBOARD32 white, MBOARD32 black) {
  for(int r = 0; r < 32; ++r) {
    for(int c = 0; c < 32; ++c) {
      if(getBit(white, r*32 + c)) 
	printf(" %s ", "\u2655");
      else if(getBit(black,r*32 + c)) 
	printf(" %s ", "\u265B");
      else{  
	printf(" %s ", "\u25A0");
      }
    }
    printf("\n");
  }
  printf("\n");  
}

__device__ __host__ BOARD Positive(MBOARD32 B) {
  return (BOARD)(B.board[0] + B.board[1] + B.board[2] + B.board[3] + B.board[4] + B.board[5] + B.board[6] + B.board[7]
		 + B.board[8] + B.board[9] + B.board[10] + B.board[11] + B.board[12] + B.board[13] + B.board[14] + B.board[15]);
  }

__device__ __host__ MBOARD32 And(MBOARD32 A, MBOARD32 B) {
  return (MBOARD32){.board = {(A.board[0] & B.board[0]),(A.board[1] & B.board[1]),
      (A.board[2] & B.board[2]), (A.board[3] & B.board[3]),
      (A.board[4] & B.board[4]),(A.board[5] & B.board[5]),
      (A.board[6] & B.board[6]), (A.board[7] & B.board[7]),
      (A.board[8] & B.board[8]),(A.board[9] & B.board[9]),
      (A.board[10] & B.board[10]), (A.board[11] & B.board[11]),
      (A.board[12] & B.board[12]),(A.board[13] & B.board[13]),
      (A.board[14] & B.board[14]), (A.board[15] & B.board[15])}};
}
__device__ __host__ const MBOARD32 Or(const MBOARD32 A, const MBOARD32 B) {
  return (MBOARD32){.board = {
      A.board[0] | B.board[0],
      A.board[1] | B.board[1],
      A.board[2] | B.board[2],
      A.board[3] | B.board[3],
      A.board[4] | B.board[4],
      A.board[5] | B.board[5],
      A.board[6] | B.board[6],
      A.board[7] | B.board[7],
      A.board[8] | B.board[8],
      A.board[9] | B.board[9],
      A.board[10] | B.board[10],
      A.board[11] | B.board[11],
      A.board[12] | B.board[12],
      A.board[13] | B.board[13],
      A.board[14] | B.board[14],
      A.board[15] | B.board[15]}};
}

__device__ __host__ MBOARD32 Not(MBOARD32 B){
  return (MBOARD32){.board = {~(B.board[0]),~(B.board[1]),~(B.board[2]),~(B.board[3]),~(B.board[4]),~(B.board[5]),~(B.board[6]),~(B.board[7]),
    ~(B.board[8]),~(B.board[9]),~(B.board[10]),~(B.board[11]),~(B.board[12]),~(B.board[13]),~(B.board[14]),~(B.board[15])}};
}

__device__ __host__ MBOARD32 rookRowMask(){
  return {.board = {0xFFFFFFFFULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL,0ULL}};
}

__device__ __host__ MBOARD32 rookColMask(){
  BOARD pattern = 1ULL | (1ULL << 32);
  return {.board = {pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern,pattern}};
}


__device__ __host__ MBOARD32 getRookMask(MBOARD32 queens) {
  MBOARD32 r1 = {0},r2 = {0},r3 = {0},r4 = {0},r5 = {0},r6 = {0},r7 = {0},r8 = {0},l1 = {0},l2 = {0},l3= {0},l4 = {0},l5 = {0},
    l6 = {0},l7 = {0},l8 = {0};
  MBOARD32 u1 = {0},u2 = {0},u3 = {0},u4 = {0},u5 = {0},u6 = {0},u7 = {0},u8 = {0},d1 = {0},d2 = {0},d3 = {0},d4 = {0},d5 = {0}
    ,d6 = {0},d7 = {0},d8 = {0};
  MBOARD32 r9 = {0},r10 = {0},r11 = {0},r12 = {0},r13 = {0},r14 = {0},r15 = {0},r16 = {0},l9 = {0},l10 = {0},l11= {0},l12 = {0},l13 = {0},
    l14 = {0},l15 = {0},l16 = {0};
  MBOARD32 u9 = {0},u10 = {0},u11 = {0},u12 = {0},u13 = {0},u14 = {0},u15 = {0},u16 = {0},d9 = {0},d10 = {0},d11 = {0},d12 = {0},d13 = {0},d14 = {0},d15 = {0},d16 = {0};

  MBOARD32 r17 = {0},r18 = {0},r19 = {0},r20 = {0},r21 = {0},r22 = {0},r23 = {0},r24 = {0},l17 = {0},l18 = {0},l19= {0},l20 = {0},l21 = {0},
    l22 = {0},l23 = {0},l24 = {0};
  MBOARD32 u17 = {0},u18 = {0},u19 = {0},u20 = {0},u21 = {0},u22 = {0},u23 = {0},u24 = {0},d17 = {0},d18 = {0},d19 = {0},d20 = {0},d21 = {0}
    ,d22 = {0},d23 = {0},d24 = {0};
  MBOARD32 r25 = {0},r26 = {0},r27 = {0},r28 = {0},r29 = {0},r30 = {0}, r31 = {0}, r32 = {0},l25 = {0},l26 = {0},l27= {0},l28 = {0},l29 = {0},
    l30 = {0},l31 = {0},l32 = {0};
  MBOARD32 u25 = {0},u26 = {0},u27 = {0},u28 = {0},u29 = {0},u30 = {0},u31 = {0},u32 = {0},d25 = {0},d26 = {0},d27 = {0},d28 = {0},d29 = {0},d30 = {0},d31 = {0},d32 = {0};

  MBOARD32 pos = queens;
  for(MBOARD32 mask = rookRowMask(); Positive(mask); mask = LShiftRook(mask,1)) {
    if(Positive(And(queens, mask))) {
      r1 = Or(r1, And(LShift(queens,1), And(Not(pos),mask)));
      r2 = Or(r2, And(LShift(r1,1), And(Not(pos),mask)));
      r3 = Or(r3, And(LShift(r2,1), And(Not(pos),mask)));
      r4 = Or(r4, And(LShift(r3,1), And(Not(pos),mask)));
      r5 = Or(r5, And(LShift(r4,1), And(Not(pos),mask)));
      r6 = Or(r6, And(LShift(r5,1), And(Not(pos),mask)));
      r7 = Or(r7, And(LShift(r6,1), And(Not(pos),mask)));
      r8 = Or(r8, And(LShift(r7,1), And(Not(pos),mask)));
      r9 = Or(r9, And(LShift(r8,1), And(Not(pos),mask)));
      r10 = Or(r10, And(LShift(r9,1), And(Not(pos),mask)));
      r11 = Or(r11, And(LShift(r10,1), And(Not(pos),mask)));
      r12 = Or(r12, And(LShift(r11,1), And(Not(pos),mask)));
      r13 = Or(r13, And(LShift(r12,1), And(Not(pos),mask)));
      r14 = Or(r14, And(LShift(r13,1), And(Not(pos),mask)));
      r15 = Or(r15, And(LShift(r14,1), And(Not(pos),mask)));
      r16 = Or(r15, And(LShift(r15,1), And(Not(pos),mask)));
      r17 = Or(r17, And(LShift(r16,1), And(Not(pos),mask)));
      r18 = Or(r18, And(LShift(r17,1), And(Not(pos),mask)));
      r19 = Or(r19, And(LShift(r18,1), And(Not(pos),mask)));
      r20 = Or(r20, And(LShift(r19,1), And(Not(pos),mask)));
      r21 = Or(r21, And(LShift(r20,1), And(Not(pos),mask)));
      r22 = Or(r22, And(LShift(r21,1), And(Not(pos),mask)));
      r23 = Or(r23, And(LShift(r22,1), And(Not(pos),mask)));
      r24 = Or(r24, And(LShift(r23,1), And(Not(pos),mask)));
      r25 = Or(r25, And(LShift(r24,1), And(Not(pos),mask)));
      r26 = Or(r26, And(LShift(r25,1), And(Not(pos),mask)));
      r27 = Or(r27, And(LShift(r26,1), And(Not(pos),mask)));
      r28 = Or(r28, And(LShift(r27,1), And(Not(pos),mask)));
      r29 = Or(r29, And(LShift(r28,1), And(Not(pos),mask)));
      r30 = Or(r30, And(LShift(r29,1), And(Not(pos),mask)));
      r31 = Or(r31, And(LShift(r30,1), And(Not(pos),mask)));
      r32 = Or(r32, And(LShift(r31,1), And(Not(pos),mask)));
      
      l1 = Or(l1, And(RShift(queens,1), And(Not(pos),mask)));
      l2 = Or(l2, And(RShift(l1,1), And(Not(pos),mask)));
      l3 = Or(l3, And(RShift(l2,1), And(Not(pos),mask)));
      l4 = Or(l4, And(RShift(l3,1), And(Not(pos),mask)));
      l5 = Or(l5, And(RShift(l4,1), And(Not(pos),mask)));
      l6 = Or(l6, And(RShift(l5,1), And(Not(pos),mask)));
      l7 = Or(l7, And(RShift(l6,1), And(Not(pos),mask)));
      l8 = Or(l8, And(RShift(l7,1), And(Not(pos),mask)));
      l9 = Or(l9, And(RShift(l8,1), And(Not(pos),mask)));
      l10 = Or(l10, And(RShift(l9,1), And(Not(pos),mask)));
      l11 = Or(l11, And(RShift(l10,1), And(Not(pos),mask)));
      l12 = Or(l12, And(RShift(l11,1), And(Not(pos),mask)));
      l13 = Or(l13, And(RShift(l12,1), And(Not(pos),mask)));
      l14 = Or(l14, And(RShift(l13,1), And(Not(pos),mask)));
      l15 = Or(l15, And(RShift(l14,1), And(Not(pos),mask)));
      l16 = Or(l15, And(RShift(l15,1), And(Not(pos),mask)));
      l17 = Or(l17, And(RShift(l16,1), And(Not(pos),mask)));
      l18 = Or(l18, And(RShift(l17,1), And(Not(pos),mask)));
      l19 = Or(l19, And(RShift(l18,1), And(Not(pos),mask)));
      l20 = Or(l20, And(RShift(l19,1), And(Not(pos),mask)));
      l21 = Or(l21, And(RShift(l20,1), And(Not(pos),mask)));
      l22 = Or(l22, And(RShift(l21,1), And(Not(pos),mask)));
      l23 = Or(l23, And(RShift(l22,1), And(Not(pos),mask)));
      l24 = Or(l24, And(RShift(l23,1), And(Not(pos),mask)));
      l25 = Or(l25, And(RShift(l24,1), And(Not(pos),mask)));
      l26 = Or(l26, And(RShift(l25,1), And(Not(pos),mask)));
      l27 = Or(l27, And(RShift(l26,1), And(Not(pos),mask)));
      l28 = Or(l28, And(RShift(l27,1), And(Not(pos),mask)));
      l29 = Or(l29, And(RShift(l28,1), And(Not(pos),mask)));
      l30 = Or(l30, And(RShift(l29,1), And(Not(pos),mask)));
      l31 = Or(l31, And(RShift(l30,1), And(Not(pos),mask)));
      l32 = Or(l32, And(RShift(l31,1), And(Not(pos),mask)));    
    }
  } 
  // BOARD pattern = 1ULL | (1ULL << 8) | (1ULL << 16) | (1ULL << 24)
  //| (1ULL << 32ULL) | (1ULL << 40ULL) | (1ULL << 48ULL) | (1ULL << 56ULL);
  for(MBOARD32 mask = rookColMask(); Positive(mask); mask = LShift(mask,1)) {
      if(Positive(And(queens,mask))) {
      u1 = Or(u1, And(LShift(queens,32), And(Not(pos),mask))); //u1 |= (queens << 8) & ~pos & mask;
      u2 = Or(u2, And(LShift(u1,32), And(Not(pos),mask)));
      u3 = Or(u3, And(LShift(u2,32), And(Not(pos),mask)));
      u4 = Or(u4, And(LShift(u3,32), And(Not(pos),mask)));
      u5 = Or(u5, And(LShift(u4,32), And(Not(pos),mask)));
      u6 = Or(u6, And(LShift(u5,32), And(Not(pos),mask)));
      u7 = Or(u7, And(LShift(u6,32), And(Not(pos),mask)));
      u8 = Or(u8, And(LShift(u7,32), And(Not(pos),mask)));
      u9 = Or(u9, And(LShift(u8,32), And(Not(pos),mask)));
      u10 = Or(u10, And(LShift(u9,32), And(Not(pos),mask)));
      u11 = Or(u11, And(LShift(u10,32), And(Not(pos),mask)));
      u12 = Or(u12, And(LShift(u11,32), And(Not(pos),mask)));
      u13 = Or(u13, And(LShift(u12,32), And(Not(pos),mask)));
      u14 = Or(u14, And(LShift(u13,32), And(Not(pos),mask)));
      u15 = Or(u15, And(LShift(u14,32), And(Not(pos),mask)));
      u16 = Or(u15, And(LShift(u15,32), And(Not(pos),mask)));
      u17 = Or(u17, And(LShift(u16,32), And(Not(pos),mask))); //u1 |= (queens << 8) & ~pos & mask;
      u18 = Or(u18, And(LShift(u17,32), And(Not(pos),mask)));
      u19 = Or(u19, And(LShift(u18,32), And(Not(pos),mask)));
      u20 = Or(u20, And(LShift(u19,32), And(Not(pos),mask)));
      u21 = Or(u21, And(LShift(u20,32), And(Not(pos),mask)));
      u22 = Or(u22, And(LShift(u21,32), And(Not(pos),mask)));
      u23 = Or(u23, And(LShift(u22,32), And(Not(pos),mask)));
      u24 = Or(u24, And(LShift(u23,32), And(Not(pos),mask)));
      u25 = Or(u25, And(LShift(u24,32), And(Not(pos),mask)));
      u26 = Or(u26, And(LShift(u25,32), And(Not(pos),mask)));
      u27 = Or(u27, And(LShift(u26,32), And(Not(pos),mask)));
      u28 = Or(u28, And(LShift(u27,32), And(Not(pos),mask)));
      u29 = Or(u29, And(LShift(u28,32), And(Not(pos),mask)));
      u30 = Or(u30, And(LShift(u29,32), And(Not(pos),mask)));
      u31 = Or(u31, And(LShift(u30,32), And(Not(pos),mask)));
      u32 = Or(u32, And(LShift(u31,32), And(Not(pos),mask)));
      
      d1 = Or(d1, And(RShift(queens,32), And(Not(pos),mask)));
      d2 = Or(d2, And(RShift(d1,32), And(Not(pos),mask)));
      d3 = Or(d3, And(RShift(d2,32), And(Not(pos),mask)));
      d4 = Or(d4, And(RShift(d3,32), And(Not(pos),mask)));
      d5 = Or(d5, And(RShift(d4,32), And(Not(pos),mask)));
      d6 = Or(d6, And(RShift(d5,32), And(Not(pos),mask)));
      d7 = Or(d7, And(RShift(d6,32), And(Not(pos),mask)));
      d8 = Or(d8, And(RShift(d7,32), And(Not(pos),mask)));
      d9 = Or(d9, And(RShift(d8,32), And(Not(pos),mask)));
      d10 = Or(d10, And(RShift(d9,32), And(Not(pos),mask)));
      d11 = Or(d11, And(RShift(d10,32), And(Not(pos),mask)));
      d12 = Or(d12, And(RShift(d11,32), And(Not(pos),mask)));
      d13 = Or(d13, And(RShift(d12,32), And(Not(pos),mask)));
      d14 = Or(d14, And(RShift(d13,32), And(Not(pos),mask)));
      d15 = Or(d15, And(RShift(d14,32), And(Not(pos),mask)));
      d16 = Or(d15, And(RShift(d15,32), And(Not(pos),mask)));
      d17 = Or(d17, And(RShift(d16,32), And(Not(pos),mask)));
      d18 = Or(d18, And(RShift(d17,32), And(Not(pos),mask)));
      d19 = Or(d19, And(RShift(d18,32), And(Not(pos),mask)));
      d20 = Or(d20, And(RShift(d19,32), And(Not(pos),mask)));
      d21 = Or(d21, And(RShift(d20,32), And(Not(pos),mask)));
      d22 = Or(d22, And(RShift(d21,32), And(Not(pos),mask)));
      d23 = Or(d23, And(RShift(d22,32), And(Not(pos),mask)));
      d24 = Or(d24, And(RShift(d23,32), And(Not(pos),mask)));
      d25 = Or(d25, And(RShift(d24,32), And(Not(pos),mask)));
      d26 = Or(d26, And(RShift(d25,32), And(Not(pos),mask)));
      d27 = Or(d27, And(RShift(d26,32), And(Not(pos),mask)));
      d28 = Or(d27, And(RShift(d27,32), And(Not(pos),mask)));
      d29 = Or(d28, And(RShift(d28,32), And(Not(pos),mask)));
      d30 = Or(d30, And(RShift(d29,32), And(Not(pos),mask)));
      d31 = Or(d31, And(RShift(d30,32), And(Not(pos),mask)));
      d32 = Or(d32, And(RShift(d31,32), And(Not(pos),mask)));

    } 
  }
  MBOARD32 rookMask1 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r1, r2),r3),r4),r5),r6),r7),r8),l1),
											     l2),l3),l4),l5), l6), l7), l8),
									u1), u2), u3), u4), u5), u6), u7), u8),d1), d2), d3), d4), d5), d6), d7), d8);


  MBOARD32 rookMask2 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r9, r10),r11),r12),r13),r14),r15),r16),l9),
											     l10),l11),l12),l13), l14), l15), l16),
									u9), u10), u11), u12), u13), u14), u15), u16),d9), d10), d11), d12), d13), d14), d15), d16);

  MBOARD32 rookMask3 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r17, r18),r19),r20),r21),r22),r23),r24),l17),
											     l18),l19),l20),l21), l22), l23), l24),
									u17), u18), u19), u20), u21), u22), u23), u24),d17), d18), d19), d20), d21), d22), d23), d24);

  MBOARD32 rookMask4 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r25, r26),r27),r28),r29),r30),r31),r32),l25),
											     l26),l27),l28),l29), l30), l31), l32),
									u25), u26), u27), u28), u29), u30), u31), u32),d25), d26), d27), d28), d29), d30), d31), d32);


  return Or(Or(queens,Or(rookMask1, rookMask2)),Or(queens,Or(rookMask3, rookMask4)));	

} 

__device__ __host__ MBOARD32 getBishopMask(MBOARD32 queens) {
  MBOARD32 BISHOP1 = bishopDiagonal1(); //0x8040201008040201;
  MBOARD32 BISHOP2 = bishopDiagonal2(); //0x0102040810204080;  
  MBOARD32 pos = queens;
  MBOARD32 r1 = {0},r2 = {0},r3 = {0},r4 = {0},r5 = {0},r6 = {0},r7 = {0},r8 = {0},l1 = {0},l2 = {0},l3= {0},l4 = {0},l5 = {0},
    l6 = {0},l7 = {0},l8 = {0};
  MBOARD32 u1 = {0},u2 = {0},u3 = {0},u4 = {0},u5 = {0},u6 = {0},u7 = {0},u8 = {0},d1 = {0},d2 = {0},d3 = {0},d4 = {0},d5 = {0}
    ,d6 = {0},d7 = {0},d8 = {0};
  MBOARD32 r9 = {0},r10 = {0},r11 = {0},r12 = {0},r13 = {0},r14 = {0},r15 = {0},r16 = {0},l9 = {0},l10 = {0},l11= {0},l12 = {0},l13 = {0},
    l14 = {0},l15 = {0},l16 = {0};
  MBOARD32 u9 = {0},u10 = {0},u11 = {0},u12 = {0},u13 = {0},u14 = {0},u15 = {0},u16 = {0},d9 = {0},d10 = {0},d11 = {0},d12 = {0},d13 = {0},d14 = {0},d15 = {0},d16 = {0};

  MBOARD32 r17 = {0},r18 = {0},r19 = {0},r20 = {0},r21 = {0},r22 = {0},r23 = {0},r24 = {0},l17 = {0},l18 = {0},l19= {0},l20 = {0},l21 = {0},
    l22 = {0},l23 = {0},l24 = {0};
  MBOARD32 u17 = {0},u18 = {0},u19 = {0},u20 = {0},u21 = {0},u22 = {0},u23 = {0},u24 = {0},d17 = {0},d18 = {0},d19 = {0},d20 = {0},d21 = {0}
    ,d22 = {0},d23 = {0},d24 = {0};
  MBOARD32 r25 = {0},r26 = {0},r27 = {0},r28 = {0},r29 = {0},r30 = {0},r31 = {0},r32 = {0},l25 = {0},l26 = {0},l27= {0},l28 = {0},l29 = {0},
    l30 = {0},l31 = {0},l32 = {0};
  MBOARD32 u25 = {0},u26 = {0},u27 = {0}, u28 = {0},u29 = {0},u30 = {0},u31 = {0},u32 = {0},d25 = {0},d26 = {0},d27 = {0},d28 = {0},d29 = {0},d30 = {0},d31 = {0},d32 = {0};

  for(MBOARD32 mask1 = BISHOP1, mask2 = BISHOP1; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1)) {   
    if(Positive(And(queens,mask2))) {
      //drawBoard(queens,mask2);
      //drawBoard(queens,r5);
      r1 = Or(r1, And(LShift(queens, 33), And(Not(pos),mask2)));
      r2 = Or(r2, And(LShift(r1, 33), And(Not(pos),mask2)));
      r3 = Or(r3, And(LShift(r2, 33), And(Not(pos),mask2)));
      r4 = Or(r4, And(LShift(r3, 33), And(Not(pos),mask2)));
      r5 = Or(r5, And(LShift(r4, 33), And(Not(pos),mask2)));
      r6 = Or(r6, And(LShift(r5, 33), And(Not(pos),mask2)));
      r7 = Or(r7, And(LShift(r6, 33), And(Not(pos),mask2)));
      r8 = Or(r8, And(LShift(r7, 33), And(Not(pos),mask2)));
      r9 = Or(r9, And(LShift(r8, 33), And(Not(pos),mask2)));
      r10 = Or(r10, And(LShift(r9, 33), And(Not(pos),mask2)));
      r11 = Or(r11, And(LShift(r10, 33), And(Not(pos),mask2)));
      r12 = Or(r12, And(LShift(r11, 33), And(Not(pos),mask2)));
      r13 = Or(r13, And(LShift(r12, 33), And(Not(pos),mask2)));
      r14 = Or(r14, And(LShift(r13, 33), And(Not(pos),mask2)));
      r15 = Or(r15, And(LShift(r14, 33), And(Not(pos),mask2)));
      r16 = Or(r16, And(LShift(r15, 33), And(Not(pos),mask2)));
      r17 = Or(r17, And(LShift(r16, 33), And(Not(pos),mask2)));
      r18 = Or(r18, And(LShift(r17, 33), And(Not(pos),mask2)));
      r19 = Or(r19, And(LShift(r18, 33), And(Not(pos),mask2)));
      r20 = Or(r20, And(LShift(r19, 33), And(Not(pos),mask2)));
      r21 = Or(r21, And(LShift(r20, 33), And(Not(pos),mask2)));
      r22 = Or(r22, And(LShift(r21, 33), And(Not(pos),mask2)));
      r23 = Or(r23, And(LShift(r22, 33), And(Not(pos),mask2)));
      r24 = Or(r24, And(LShift(r23, 33), And(Not(pos),mask2)));
      r25 = Or(r25, And(LShift(r24, 33), And(Not(pos),mask2)));
      r26 = Or(r26, And(LShift(r25, 33), And(Not(pos),mask2)));
      r27 = Or(r27, And(LShift(r26, 33), And(Not(pos),mask2)));
      r28 = Or(r28, And(LShift(r27, 33), And(Not(pos),mask2)));
      r29 = Or(r29, And(LShift(r28, 33), And(Not(pos),mask2)));
      r30 = Or(r30, And(LShift(r29, 33), And(Not(pos),mask2)));
      r31 = Or(r31, And(LShift(r30, 33), And(Not(pos),mask2)));
      r32 = Or(r32, And(LShift(r31, 33), And(Not(pos),mask2)));

      l1 = Or(l1, And(RShift(queens,33), And(Not(pos),mask2)));
      l2 = Or(l2, And(RShift(l1,33), And(Not(pos),mask2)));
      l3 = Or(l3, And(RShift(l2,33), And(Not(pos),mask2)));
      l4 = Or(l4, And(RShift(l3,33), And(Not(pos),mask2)));
      l5 = Or(l5, And(RShift(l4,33), And(Not(pos),mask2)));
      l6 = Or(l6, And(RShift(l5,33), And(Not(pos),mask2)));
      l7 = Or(l7, And(RShift(l6,33), And(Not(pos),mask2)));
      l8 = Or(l8, And(RShift(l7,33), And(Not(pos),mask2)));
      l9 = Or(l9, And(RShift(l8,33), And(Not(pos),mask2)));
      l10 = Or(l10, And(RShift(l9,33), And(Not(pos),mask2)));
      l11 = Or(l11, And(RShift(l10,33), And(Not(pos),mask2)));
      l12 = Or(l12, And(RShift(l11,33), And(Not(pos),mask2)));
      l13 = Or(l13, And(RShift(l12,33), And(Not(pos),mask2)));
      l14 = Or(l14, And(RShift(l13,33), And(Not(pos),mask2)));
      l15 = Or(l15, And(RShift(l14,33), And(Not(pos),mask2)));
      l16 = Or(l16, And(RShift(l15,33), And(Not(pos),mask2)));
      l17 = Or(l17, And(RShift(l16,33), And(Not(pos),mask2)));
      l18 = Or(l18, And(RShift(l17,33), And(Not(pos),mask2)));
      l19 = Or(l19, And(RShift(l18,33), And(Not(pos),mask2)));
      l20 = Or(l20, And(RShift(l19,33), And(Not(pos),mask2)));
      l21 = Or(l21, And(RShift(l20,33), And(Not(pos),mask2)));
      l22 = Or(l22, And(RShift(l21,33), And(Not(pos),mask2)));
      l23 = Or(l23, And(RShift(l22,33), And(Not(pos),mask2)));
      l24 = Or(l24, And(RShift(l23,33), And(Not(pos),mask2)));
      l25 = Or(l25, And(RShift(l24,33), And(Not(pos),mask2)));
      l26 = Or(l26, And(RShift(l25,33), And(Not(pos),mask2)));
      l27 = Or(l27, And(RShift(l26,33), And(Not(pos),mask2)));
      l28 = Or(l28, And(RShift(l27,33), And(Not(pos),mask2)));
      l29 = Or(l29, And(RShift(l28,33), And(Not(pos),mask2)));
      l30 = Or(l30, And(RShift(l29,33), And(Not(pos),mask2)));
      l31 = Or(l31, And(RShift(l30,33), And(Not(pos),mask2)));
      l32 = Or(l32, And(RShift(l31,33), And(Not(pos),mask2)));

    }
    
    if(Positive(And(queens, mask1))) {
      r1 = Or(r1, And(LShift(queens, 33), And(Not(pos),mask1)));
      r2 = Or(r2, And(LShift(r1, 33), And(Not(pos),mask1)));
      r3 = Or(r3, And(LShift(r2, 33), And(Not(pos),mask1)));
      r4 = Or(r4, And(LShift(r3, 33), And(Not(pos),mask1)));
      r5 = Or(r5, And(LShift(r4, 33), And(Not(pos),mask1)));
      r6 = Or(r6, And(LShift(r5, 33), And(Not(pos),mask1)));
      r7 = Or(r7, And(LShift(r6, 33), And(Not(pos),mask1)));
      r8 = Or(r8, And(LShift(r7, 33), And(Not(pos),mask1)));
      r9 = Or(r9, And(LShift(r8, 33), And(Not(pos),mask1)));
      r10 = Or(r10, And(LShift(r9, 33), And(Not(pos),mask1)));
      r11 = Or(r11, And(LShift(r10, 33), And(Not(pos),mask1)));
      r12 = Or(r12, And(LShift(r11, 33), And(Not(pos),mask1)));
      r13 = Or(r13, And(LShift(r12, 33), And(Not(pos),mask1)));
      r14 = Or(r14, And(LShift(r13, 33), And(Not(pos),mask1)));
      r15 = Or(r15, And(LShift(r14, 33), And(Not(pos),mask1)));
      r16 = Or(r16, And(LShift(r15, 33), And(Not(pos),mask1)));
      r17 = Or(r17, And(LShift(r16, 33), And(Not(pos),mask1)));
      r18 = Or(r18, And(LShift(r17, 33), And(Not(pos),mask1)));
      r19 = Or(r19, And(LShift(r18, 33), And(Not(pos),mask1)));
      r20 = Or(r20, And(LShift(r19, 33), And(Not(pos),mask1)));
      r21 = Or(r21, And(LShift(r20, 33), And(Not(pos),mask1)));
      r22 = Or(r22, And(LShift(r21, 33), And(Not(pos),mask1)));
      r23 = Or(r23, And(LShift(r22, 33), And(Not(pos),mask1)));
      r24 = Or(r24, And(LShift(r23, 33), And(Not(pos),mask1)));
      r25 = Or(r25, And(LShift(r24, 33), And(Not(pos),mask1)));
      r26 = Or(r26, And(LShift(r25, 33), And(Not(pos),mask1)));
      r27 = Or(r27, And(LShift(r26, 33), And(Not(pos),mask1)));
      r28 = Or(r28, And(LShift(r27, 33), And(Not(pos),mask1)));
      r29 = Or(r29, And(LShift(r28, 33), And(Not(pos),mask1)));
      r30 = Or(r30, And(LShift(r29, 33), And(Not(pos),mask1)));
      r31 = Or(r31, And(LShift(r30, 33), And(Not(pos),mask1)));
      r32 = Or(r32, And(LShift(r31, 33), And(Not(pos),mask1)));
  

      l1 = Or(l1, And(RShift(queens,33), And(Not(pos),mask1)));
      l2 = Or(l2, And(RShift(l1,33), And(Not(pos),mask1)));
      l3 = Or(l3, And(RShift(l2,33), And(Not(pos),mask1)));
      l4 = Or(l4, And(RShift(l3,33), And(Not(pos),mask1)));
      l5 = Or(l5, And(RShift(l4,33), And(Not(pos),mask1)));
      l6 = Or(l6, And(RShift(l5,33), And(Not(pos),mask1)));
      l7 = Or(l7, And(RShift(l6,33), And(Not(pos),mask1)));
      l8 = Or(l8, And(RShift(l7,33), And(Not(pos),mask1)));
      l9 = Or(l9, And(RShift(l8,33), And(Not(pos),mask1)));
      l10 = Or(l10, And(RShift(l9,33), And(Not(pos),mask1)));
      l11 = Or(l11, And(RShift(l10,33), And(Not(pos),mask1)));
      l12 = Or(l12, And(RShift(l11,33), And(Not(pos),mask1)));
      l13 = Or(l13, And(RShift(l12,33), And(Not(pos),mask1)));
      l14 = Or(l14, And(RShift(l13,33), And(Not(pos),mask1)));
      l15 = Or(l15, And(RShift(l14,33), And(Not(pos),mask1)));
      l16 = Or(l16, And(RShift(l15,33), And(Not(pos),mask1)));
      l17 = Or(l17, And(RShift(l16,33), And(Not(pos),mask1)));
      l18 = Or(l18, And(RShift(l17,33), And(Not(pos),mask1)));
      l19 = Or(l19, And(RShift(l18,33), And(Not(pos),mask1)));
      l20 = Or(l20, And(RShift(l19,33), And(Not(pos),mask1)));
      l21 = Or(l21, And(RShift(l20,33), And(Not(pos),mask1)));
      l22 = Or(l22, And(RShift(l21,33), And(Not(pos),mask1)));
      l23 = Or(l23, And(RShift(l22,33), And(Not(pos),mask1)));
      l24 = Or(l24, And(RShift(l23,33), And(Not(pos),mask1)));
      l25 = Or(l25, And(RShift(l24,33), And(Not(pos),mask1)));
      l26 = Or(l26, And(RShift(l25,33), And(Not(pos),mask1)));
      l27 = Or(l27, And(RShift(l26,33), And(Not(pos),mask1)));
      l28 = Or(l28, And(RShift(l27,33), And(Not(pos),mask1)));
      l29 = Or(l29, And(RShift(l28,33), And(Not(pos),mask1)));
      l30 = Or(l30, And(RShift(l29,33), And(Not(pos),mask1)));
      l31 = Or(l31, And(RShift(l30,33), And(Not(pos),mask1)));
      l32 = Or(l32, And(RShift(l31,33), And(Not(pos),mask1)));
    }
  } 
  
  for(MBOARD32 mask1 = BISHOP2, mask2 = BISHOP2; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1) ) {
     if(Positive(And(queens, mask1))) {
      u1 = Or(u1, And(LShift(queens,31), And(Not(pos),mask1)));
      u2 = Or(u2, And(LShift(u1,31), And(Not(pos),mask1)));
      u3 = Or(u3, And(LShift(u2,31), And(Not(pos),mask1)));
      u4 = Or(u4, And(LShift(u3,31), And(Not(pos),mask1)));
      u5 = Or(u5, And(LShift(u4,31), And(Not(pos),mask1)));
      u6 = Or(u6, And(LShift(u5,31), And(Not(pos),mask1)));
      u7 = Or(u7, And(LShift(u6,31), And(Not(pos),mask1)));
      u8 = Or(u8, And(LShift(u7,31), And(Not(pos),mask1)));
      u9 = Or(u9, And(LShift(u8,31), And(Not(pos),mask1)));
      u10 = Or(u10, And(LShift(u9,31), And(Not(pos),mask1)));
      u11 = Or(u11, And(LShift(u10,31), And(Not(pos),mask1)));
      u12 = Or(u12, And(LShift(u11,31), And(Not(pos),mask1)));
      u13 = Or(u13, And(LShift(u12,31), And(Not(pos),mask1)));
      u14 = Or(u14, And(LShift(u13,31), And(Not(pos),mask1)));
      u15 = Or(u15, And(LShift(u14,31), And(Not(pos),mask1)));
      u16 = Or(u16, And(LShift(u15,31), And(Not(pos),mask1)));
      u17 = Or(u17, And(LShift(u16,31), And(Not(pos),mask1)));
      u18 = Or(u18, And(LShift(u17,31), And(Not(pos),mask1)));
      u19 = Or(u19, And(LShift(u18,31), And(Not(pos),mask1)));
      u20 = Or(u20, And(LShift(u19,31), And(Not(pos),mask1)));
      u21 = Or(u21, And(LShift(u20,31), And(Not(pos),mask1)));
      u22 = Or(u22, And(LShift(u21,31), And(Not(pos),mask1)));
      u23 = Or(u23, And(LShift(u22,31), And(Not(pos),mask1)));
      u24 = Or(u24, And(LShift(u23,31), And(Not(pos),mask1)));
      u25 = Or(u25, And(LShift(u24,31), And(Not(pos),mask1)));
      u26 = Or(u26, And(LShift(u25,31), And(Not(pos),mask1)));
      u27 = Or(u27, And(LShift(u26,31), And(Not(pos),mask1)));
      u28 = Or(u28, And(LShift(u27,31), And(Not(pos),mask1)));
      u29 = Or(u29, And(LShift(u28,31), And(Not(pos),mask1)));
      u30 = Or(u30, And(LShift(u29,31), And(Not(pos),mask1)));
      u31 = Or(u31, And(LShift(u30,31), And(Not(pos),mask1)));
      u32 = Or(u32, And(LShift(u31,31), And(Not(pos),mask1)));

      
      d1 = Or(d1, And(RShift(queens,31), And(Not(pos),mask1)));
      d2 = Or(d2, And(RShift(d1,31), And(Not(pos),mask1)));
      d3 = Or(d3, And(RShift(d2,31), And(Not(pos),mask1)));
      d4 = Or(d4, And(RShift(d3,31), And(Not(pos),mask1)));
      d5 = Or(d5, And(RShift(d4,31), And(Not(pos),mask1)));
      d6 = Or(d6, And(RShift(d5,31), And(Not(pos),mask1)));
      d7 = Or(d7, And(RShift(d6,31), And(Not(pos),mask1)));
      d8 = Or(d8, And(RShift(d7,31), And(Not(pos),mask1)));
      d9 = Or(d9, And(RShift(d8,31), And(Not(pos),mask1)));
      d10 = Or(d10, And(RShift(d9,31), And(Not(pos),mask1)));
      d11 = Or(d11, And(RShift(d10,31), And(Not(pos),mask1)));
      d12 = Or(d12, And(RShift(d11,31), And(Not(pos),mask1)));
      d13 = Or(d13, And(RShift(d12,31), And(Not(pos),mask1)));
      d14 = Or(d14, And(RShift(d13,31), And(Not(pos),mask1)));
      d15 = Or(d15, And(RShift(d14,31), And(Not(pos),mask1)));
      d16 = Or(d16, And(RShift(d15,31), And(Not(pos),mask1)));
      d17 = Or(d17, And(RShift(d16,31), And(Not(pos),mask1)));
      d18 = Or(d18, And(RShift(d17,31), And(Not(pos),mask1)));
      d19 = Or(d19, And(RShift(d18,31), And(Not(pos),mask1)));
      d20 = Or(d20, And(RShift(d19,31), And(Not(pos),mask1)));
      d21 = Or(d21, And(RShift(d20,31), And(Not(pos),mask1)));
      d22 = Or(d22, And(RShift(d21,31), And(Not(pos),mask1)));
      d23 = Or(d23, And(RShift(d22,31), And(Not(pos),mask1)));
      d24 = Or(d24, And(RShift(d23,31), And(Not(pos),mask1)));
      d25 = Or(d25, And(RShift(d24,31), And(Not(pos),mask1)));
      d26 = Or(d26, And(RShift(d25,31), And(Not(pos),mask1)));
      d27 = Or(d27, And(RShift(d26,31), And(Not(pos),mask1)));
      d28 = Or(d28, And(RShift(d27,31), And(Not(pos),mask1)));
      d29 = Or(d29, And(RShift(d28,31), And(Not(pos),mask1)));
      d30 = Or(d30, And(RShift(d29,31), And(Not(pos),mask1)));
      d31 = Or(d31, And(RShift(d30,31), And(Not(pos),mask1)));
      d32 = Or(d32, And(RShift(d31,31), And(Not(pos),mask1)));
    }
    if(Positive(And(queens,mask2))) {
      u1 = Or(u1, And(LShift(queens,31), And(Not(pos),mask2)));
      u2 = Or(u2, And(LShift(u1,31), And(Not(pos),mask2)));
      u3 = Or(u3, And(LShift(u2,31), And(Not(pos),mask2)));
      u4 = Or(u4, And(LShift(u3,31), And(Not(pos),mask2)));
      u5 = Or(u5, And(LShift(u4,31), And(Not(pos),mask2)));
      u6 = Or(u6, And(LShift(u5,31), And(Not(pos),mask2)));
      u7 = Or(u7, And(LShift(u6,31), And(Not(pos),mask2)));
      u8 = Or(u8, And(LShift(u7,31), And(Not(pos),mask2)));
      u9 = Or(u9, And(LShift(u8,31), And(Not(pos),mask2)));
      u10 = Or(u10, And(LShift(u9,31), And(Not(pos),mask2)));
      u11 = Or(u11, And(LShift(u10,31), And(Not(pos),mask2)));
      u12 = Or(u12, And(LShift(u11,31), And(Not(pos),mask2)));
      u13 = Or(u13, And(LShift(u12,31), And(Not(pos),mask2)));
      u14 = Or(u14, And(LShift(u13,31), And(Not(pos),mask2)));
      u15 = Or(u15, And(LShift(u14,31), And(Not(pos),mask2)));
      u16 = Or(u16, And(LShift(u15,31), And(Not(pos),mask2)));
      u17 = Or(u17, And(LShift(u16,31), And(Not(pos),mask2)));
      u18 = Or(u18, And(LShift(u17,31), And(Not(pos),mask2)));
      u19 = Or(u19, And(LShift(u18,31), And(Not(pos),mask2)));
      u20 = Or(u20, And(LShift(u19,31), And(Not(pos),mask2)));
      u21 = Or(u21, And(LShift(u20,31), And(Not(pos),mask2)));
      u22 = Or(u22, And(LShift(u21,31), And(Not(pos),mask2)));
      u23 = Or(u23, And(LShift(u22,31), And(Not(pos),mask2)));
      u24 = Or(u24, And(LShift(u23,31), And(Not(pos),mask2)));
      u25 = Or(u25, And(LShift(u24,31), And(Not(pos),mask2)));
      u26 = Or(u26, And(LShift(u25,31), And(Not(pos),mask2)));
      u27 = Or(u27, And(LShift(u26,31), And(Not(pos),mask2)));
      u28 = Or(u28, And(LShift(u27,31), And(Not(pos),mask2)));
      u29 = Or(u29, And(LShift(u28,31), And(Not(pos),mask2)));
      u30 = Or(u30, And(LShift(u29,31), And(Not(pos),mask2)));
      u31 = Or(u31, And(LShift(u30,31), And(Not(pos),mask2)));
      u32 = Or(u32, And(LShift(u31,31), And(Not(pos),mask2)));

      
      d1 = Or(d1, And(RShift(queens,31), And(Not(pos),mask2)));
      d2 = Or(d2, And(RShift(d1,31), And(Not(pos),mask2)));
      d3 = Or(d3, And(RShift(d2,31), And(Not(pos),mask2)));
      d4 = Or(d4, And(RShift(d3,31), And(Not(pos),mask2)));
      d5 = Or(d5, And(RShift(d4,31), And(Not(pos),mask2)));
      d6 = Or(d6, And(RShift(d5,31), And(Not(pos),mask2)));
      d7 = Or(d7, And(RShift(d6,31), And(Not(pos),mask2)));
      d8 = Or(d8, And(RShift(d7,31), And(Not(pos),mask2)));
      d9 = Or(d9, And(RShift(d8,31), And(Not(pos),mask2)));
      d10 = Or(d10, And(RShift(d9,31), And(Not(pos),mask2)));
      d11 = Or(d11, And(RShift(d10,31), And(Not(pos),mask2)));
      d12 = Or(d12, And(RShift(d11,31), And(Not(pos),mask2)));
      d13 = Or(d13, And(RShift(d12,31), And(Not(pos),mask2)));
      d14 = Or(d14, And(RShift(d13,31), And(Not(pos),mask2)));
      d15 = Or(d15, And(RShift(d14,31), And(Not(pos),mask2)));
      d16 = Or(d16, And(RShift(d15,31), And(Not(pos),mask2)));
      d17 = Or(d17, And(RShift(d16,31), And(Not(pos),mask2)));
      d18 = Or(d18, And(RShift(d17,31), And(Not(pos),mask2)));
      d19 = Or(d19, And(RShift(d18,31), And(Not(pos),mask2)));
      d20 = Or(d20, And(RShift(d19,31), And(Not(pos),mask2)));
      d21 = Or(d21, And(RShift(d20,31), And(Not(pos),mask2)));
      d22 = Or(d22, And(RShift(d21,31), And(Not(pos),mask2)));
      d23 = Or(d23, And(RShift(d22,31), And(Not(pos),mask2)));
      d24 = Or(d24, And(RShift(d23,31), And(Not(pos),mask2)));
      d25 = Or(d25, And(RShift(d24,31), And(Not(pos),mask2)));
      d26 = Or(d26, And(RShift(d25,31), And(Not(pos),mask2)));
      d27 = Or(d27, And(RShift(d26,31), And(Not(pos),mask2)));
      d28 = Or(d28, And(RShift(d27,31), And(Not(pos),mask2)));
      d29 = Or(d29, And(RShift(d28,31), And(Not(pos),mask2)));
      d30 = Or(d30, And(RShift(d29,31), And(Not(pos),mask2)));
      d31 = Or(d31, And(RShift(d30,31), And(Not(pos),mask2)));
      d32 = Or(d32, And(RShift(d31,31), And(Not(pos),mask2)));
      }   
  }
  MBOARD32 bishopMask1 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r1, r2),r3),r4),r5),r6),r7),r8),l1),
											     l2),l3),l4),l5), l6), l7), l8),
									u1), u2), u3), u4), u5), u6), u7), u8),d1), d2), d3), d4), d5), d6), d7), d8);

  MBOARD32 bishopMask2 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r9, r10),r11),r12),r13),r14),r15),r16),l9),
											     l10),l11),l12),l13), l14), l15), l16),
									u9), u10), u11), u12), u13), u14), u15), u16),d9), d10), d11), d12), d13), d14), d15), d16);

  MBOARD32 bishopMask3 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r17, r18),r19),r20),r21),r22),r23),r24),l17),
											     l18),l19),l20),l21), l22), l23), l24),
									u17), u18), u19), u20), u21), u22), u23), u24),d17), d18), d19), d20), d21), d22), d23), d24);

  MBOARD32 bishopMask4 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r25, r26),r27),r28),r29),r30),r31),r32),l25),
											     l26),l27),l28),l29), l30), l31), l32),
									u25), u26), u27), u28), u29), u30), u31), u32),d25), d26), d27), d28), d29), d30), d31), d32);

  return Or(Or(bishopMask1, bishopMask2),Or(bishopMask3, bishopMask4));
  } 

__device__ __host__ MBOARD32 getQueenMask(MBOARD32 queens) {
  return Or(getRookMask(queens), getBishopMask(queens));
}

__host__ int countWhiteQueensH(MBOARD32 mb) {
 return  __builtin_popcountll(mb.board[0]) + __builtin_popcountll(mb.board[1]) + __builtin_popcountll(mb.board[2]) + __builtin_popcountll(mb.board[3])
   +  __builtin_popcountll(mb.board[4]) + __builtin_popcountll(mb.board[5]) + __builtin_popcountll(mb.board[6]) + __builtin_popcountll(mb.board[7]) +
     __builtin_popcountll(mb.board[8]) + __builtin_popcountll(mb.board[9]) + __builtin_popcountll(mb.board[10]) + __builtin_popcountll(mb.board[11])
   +  __builtin_popcountll(mb.board[12]) + __builtin_popcountll(mb.board[13]) + __builtin_popcountll(mb.board[14]) + __builtin_popcountll(mb.board[15]);
}

__device__ int countWhiteQueensD(MBOARD32 mb) {
  return __popcll(mb.board[0]) + __popcll(mb.board[1]) + __popcll(mb.board[2]) + __popcll(mb.board[3]) + __popcll(mb.board[4]) + __popcll(mb.board[5]) + __popcll(mb.board[6]) + __popcll(mb.board[7]) + __popcll(mb.board[8]) + __popcll(mb.board[9]) + __popcll(mb.board[10]) + __popcll(mb.board[11]) + __popcll(mb.board[12]) + __popcll(mb.board[13]) + __popcll(mb.board[14]) + __popcll(mb.board[15]);
}

__device__ int countBlackQueensD(MBOARD32 mb) {
  MBOARD32 black = Not(getQueenMask(mb));
  return __popcll(black.board[0]) + __popcll(black.board[1]) + __popcll(black.board[2]) + __popcll(black.board[3]) + __popcll(black.board[4]) + __popcll(black.board[5]) + __popcll(black.board[6]) + __popcll(black.board[7]) + __popcll(black.board[8]) + __popcll(black.board[9]) + __popcll(black.board[10]) + __popcll(black.board[11]) + __popcll(black.board[12]) + __popcll(black.board[13]) + __popcll(black.board[14]) + __popcll(black.board[15]);
}
__host__ int countBlackQueensH(MBOARD32 mb) {
  MBOARD32 black = Not(getQueenMask(mb));
  return __builtin_popcountll(black.board[0]) + __builtin_popcountll(black.board[1]) + __builtin_popcountll(black.board[2]) + __builtin_popcountll(black.board[3]) +
    __builtin_popcountll(black.board[4]) + __builtin_popcountll(black.board[5]) + __builtin_popcountll(black.board[6]) + __builtin_popcountll(black.board[7]) +
    __builtin_popcountll(black.board[8]) + __builtin_popcountll(black.board[9]) + __builtin_popcountll(black.board[10]) + __builtin_popcountll(black.board[11]) +
    __builtin_popcountll(black.board[12]) + __builtin_popcountll(black.board[13]) + __builtin_popcountll(black.board[14]) + __builtin_popcountll(black.board[15]);
}

__device__  MBOARD32 findSwap(MBOARD32 queens, int *mx) {
  MBOARD32 qmax = queens;
  int num = 0;
  for(MBOARD32 mask = rookRowMask(); Positive(mask); mask = LShiftRook(mask,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask,queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int min = WhiteQ > BlackQ ? BlackQ : WhiteQ;
    if(min > num){
      num = min;
      qmax = swapped;
    } 
  } 
  for(MBOARD32 mask = rookColMask(); Positive(mask); mask = LShift(mask,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask, queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int min = WhiteQ > BlackQ ? BlackQ : WhiteQ;
    if(min > num){
      num = min;
      qmax = swapped;
    }
  }
  MBOARD32 BISHOP1 = bishopDiagonal1(); //0x8040201008040201;
  MBOARD32 BISHOP2 = bishopDiagonal2(); //0x0102040810204080;  

  for(MBOARD32 mask1 = BISHOP1, mask2 = BISHOP1; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask1,queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int min = WhiteQ > BlackQ ? BlackQ : WhiteQ;
    if(min > num){
      num = min;
      qmax = swapped;
    }
    
    swapped = And(queens, Not(And(mask2,queens)));
    WhiteQ = countWhiteQueensD(swapped);
    BlackQ = countBlackQueensD(swapped);
    min = WhiteQ > BlackQ ? BlackQ : WhiteQ;
    if(min > num){
      num = min;
      qmax = swapped;
    }
  }

  for(MBOARD32 mask1 = BISHOP2, mask2 = BISHOP2; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask1, queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int min = WhiteQ > BlackQ ? BlackQ : WhiteQ;
    if(min > num){
      num = min;
      qmax = swapped;
    }
    
    swapped = And(queens, Not(And(mask2,queens)));
    WhiteQ = countWhiteQueensD(swapped);
    BlackQ = countBlackQueensD(swapped);
    min = WhiteQ > BlackQ ? BlackQ : WhiteQ;
    if(min > num){
      num = min;
      qmax = swapped;
    }
  }
  *mx = num;
  return qmax;	
} 

__device__  MBOARD32 findSwap2(MBOARD32 queens, int *mx) {
  MBOARD32 qmax = queens;
  int num = 0;
  for(MBOARD32 mask = rookRowMask(); Positive(mask); mask = LShiftRook(mask,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask,queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int ms = WhiteQ + BlackQ;
    if(ms > num){
      num = ms;
      qmax = swapped;
    } 
  } 
  for(MBOARD32 mask = rookColMask(); Positive(mask); mask = LShift(mask,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask, queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int ms = WhiteQ + BlackQ; 
    if(ms > num){
      num = ms;
      qmax = swapped;
    }
  }
  MBOARD32 BISHOP1 = bishopDiagonal1(); //0x8040201008040201;
  MBOARD32 BISHOP2 = bishopDiagonal2(); //0x0102040810204080;  

  for(MBOARD32 mask1 = BISHOP1, mask2 = BISHOP1; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask1,queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int ms = WhiteQ + BlackQ; 
    if(ms > num){
      num = ms;
      qmax = swapped;
    }
    
    swapped = And(queens, Not(And(mask2,queens)));
    WhiteQ = countWhiteQueensD(swapped);
    BlackQ = countBlackQueensD(swapped);
    ms = WhiteQ + BlackQ; 
    if(ms > num){
      num = ms;
      qmax = swapped;
    }
  }

  for(MBOARD32 mask1 = BISHOP2, mask2 = BISHOP2; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1)) {
    MBOARD32 swapped = And(queens, Not(And(mask1, queens)));
    int WhiteQ = countWhiteQueensD(swapped);
    int BlackQ = countBlackQueensD(swapped);
    int ms = WhiteQ + BlackQ; 
    if(ms > num){
      num = ms;
      qmax = swapped;
    }
    
    swapped = And(queens, Not(And(mask2,queens)));
    WhiteQ = countWhiteQueensD(swapped);
    BlackQ = countBlackQueensD(swapped);
    ms = WhiteQ + BlackQ; 
    if(ms > num){
      num = ms;
      qmax = swapped;
    }
  }
  *mx = num;
  return qmax;	
} 


__global__ void sample(int *mq, MBOARD32 *mxb) {
  //printf("pop %i %i \n", __popcll(0xFFULL), __popcll(~0xFFULL));
  //MBOARD b = {.board = {60753670ULL ,1147788ULL, 34352ULL, 36622ULL}};
  //MBOARD b = genMBOARD(.41,5, 0);
  //  printf("count GPU %i %i \n", countWhiteQueensD(b),countBlackQueensD(b));
  //*mxb = b;
  MBOARD32 mb = {0};
  int c = 0;
  int id = blockIdx.x * blockDim.x + threadIdx.x;
  while(*mq < 150) {
    // mb = genWordNV32((float)id/20000.0,((float)id/1000.0)+1,id);
    //mb = genWordNV32(.08,7,id);
    mb = genWordNV32(.05,5,id);
    //    mb = {.board = {60753670ULL ,1147788ULL, 34352ULL, 36622ULL}};
    int blackQ = countBlackQueensD(mb);
    int whiteQ = countWhiteQueensD(mb);
    //    printf("%i %i %i\n",blackQ, whiteQ, *mq);
   if((whiteQ <= blackQ)) {
    mb = Or(mb, Not(getQueenMask(Not(getQueenMask(mb)))));
    int newBlackQ = countBlackQueensD(mb);
    int newWhiteQ = countWhiteQueensD(mb);
    blackQ = newBlackQ;
    whiteQ = newWhiteQ;
   }
    if(whiteQ >= 130 && blackQ >= 130 ) {
      printf("%i %i %i it %i id %i\n",whiteQ, blackQ, *mq, c, id);
      //printf("%llu %llu %llu %llu\n",mb.board[0],mb.board[1],mb.board[2],mb.board[3]);
      drawBoard(Not(getQueenMask(mb)),mb);
    }
    
    if(*mq > 120 && (whiteQ >= 120 && blackQ >= *mq || whiteQ >= *mq && blackQ >= 120)) {
      int s = 0;
      int sm = 0;
      mb = whiteQ > blackQ ? mb : Not(getQueenMask(mb));
      int mn = whiteQ > blackQ ? blackQ : whiteQ;
      int mx = whiteQ > blackQ ? whiteQ : blackQ;
      MBOARD32 swapped = findSwap2(mb, &sm);
      swapped = findSwap2(swapped, &sm);
      //MBOARD32 swapped = findSwap(mb, &s);
      //if(s < *mq && s > mn && mx > *mq) {
      if(sm > whiteQ + blackQ){
	//mb = whiteQ > blackQ ? mb : Not(getQueenMask(mb));
	swapped = countWhiteQueensD(swapped) > countBlackQueensD(swapped) ? swapped : Not(getQueenMask(swapped));
	swapped = findSwap(swapped, &s);
      }
      if(s > *mq && s > mn){
	whiteQ = s;
	blackQ = s;
	
	printf("%i %i %i it %i id %i\n",whiteQ, blackQ, *mq, c, id);
	  //printf("%llu %llu %llu %llu\n",mb.board[0],mb.board[1],mb.board[2],mb.board[3]);
    
	printf("s = %i\n",s);
	drawBoard(Not(getQueenMask(mb)),mb);
	printf("swapped %i\n",s);
	drawBoard(Not(getQueenMask(swapped)),swapped);      
	
	mb = swapped;
      }
   }
   int mn = blackQ < whiteQ ? blackQ: whiteQ;
   if(mn  > *mq) {
     if(c > 0){
      printf("%i %i %i it %i id %i\n",whiteQ, blackQ, *mq, c, id);
      drawBoard(Not(getQueenMask(mb)),mb);
     }
      //*mq = mn;
     atomicMax(mq,mn);
      *mxb = mb;
    }
    ++c;
  } 
}

/*MBOARD32 sampleH() {
  MBOARD32 mb = {0}, mxb = {0};
  int c = 0;
  int mq = 0;
  while(mq < 38) {
    //  mb = genMBOARDH(.28,6);  36 36
    float p = .2;
    int m = 1;
    //mb = {.board = {(BOARD)rand(),(BOARD)rand(),(BOARD)rand(),(BOARD)rand()}};
    mb = genMBOARDH(p,m);
    // mb = genMBOARDH(.28,5);
    int blackQ = countBlackQueensH(mb);
    int whiteQ = countWhiteQueensH(mb);

    if(whiteQ + blackQ >= 74 && (whiteQ >= 28 && blackQ >= 28)) {
      printf("%i %i %i sum %i p = %f m = %i \n",whiteQ, blackQ,c,mq, p, m);
      drawBoard(Not(getQueenMask(mb)),mb);
    }
    if((whiteQ <= blackQ)) {
      if(whiteQ >= 24){ //28
	printf("max so far %i, %i %i inbalance found p = %f m = %i \n",mq, whiteQ,blackQ,p,m);
	drawBoard(Not(getQueenMask(mb)),mb);
	
	printf("fixing .. \n");
      }
      mb = Or(mb, Not(getQueenMask(Not(getQueenMask(mb)))));
      int newBlackQ = countBlackQueensH(mb);
      int newWhiteQ = countWhiteQueensH(mb);
      if(whiteQ >= 27){
	if(newBlackQ > newWhiteQ) {
	  printf("max so far %i, imbalance remains %i %i p = %f m = %i \n",mq,newWhiteQ, newBlackQ,p,m);
	}
	else printf("max so far %i, imbalance fixed %i %i p = %f m = %i \n", mq,newWhiteQ, newBlackQ,p,m);
	drawBoard(Not(getQueenMask(mb)),mb);
      }
      blackQ = newBlackQ;
      whiteQ = newWhiteQ;
    }
    
    if((whiteQ == blackQ) && whiteQ > mq) {
      mq = whiteQ;
      mxb = mb;
      if(whiteQ > 20){
	printf("%i %i %i hi %i p = %f m = %i \n",whiteQ, blackQ,c,mq, p, m);
	//	printf("%llu %llu %llu %llu \n", mb.board[0], mb.board[1], mb.board[2], mb.board[3]);
	drawBoard(Not(getQueenMask(mb)),mb);
      }
    }
    ++c;
  }
  printf("DONE \n");
  return mxb;
}
*/

int main() {
  int blockSize = 32;
  int blocks = 10000/blockSize;
  MBOARD32 *mxb;
  int * mq;
  cudaMallocManaged(&mxb, sizeof(MBOARD32));
  cudaMallocManaged(&mq, sizeof(int));
  *mq=0;
  sample<<<20000,blockSize>>>(mq,mxb);
  cudaDeviceSynchronize();
  drawBoard(Not(getQueenMask(*mxb)),*mxb); 

  MBOARD32 g = {.board = {0,0,0,1ULL << 22,0,0,0,0}};
  drawBoard(getQueenMask(g),bishopDiagonal1());

  //srand(time(0));
  //sampleH();

  /*
  MBOARD t = {.board = {60753670,1147788, 34352, 36622}};
  printf("count CPU %i %i \n", countWhiteQueensH(t),countBlackQueensH(t));
  //  MBOARD t = {.board = {0,0, 0,  1 << 10 | 1 << 15 }};
    //t = *mxb;
  drawBoard(getQueenMask(t),t);
  drawBoard(Not(getQueenMask(t)),t);
  //drawBoard(bishopDiagonal2(),bishopDiagonal1());
  //for(int i = 0; i < 16; ++i)
  // drawBoard(RShiftBishop1(bishopDiagonal1(),i),t);
  
  printf("%i %i \n", countBlackQueensH(t), countWhiteQueensH(t));
  MBOARD B;
  B.board[0] = 0xFFFFULL;
  B.board[1] = 0xFFFFULL;
  B.board[2] = 0xFFFFULL;
  B.board[3] = 0xFFFFULL;
  drawBoard(B,compliment(B));
  MBOARD C = {.board = {1,1,1,1}};
  drawBoard(C,compliment(C));
  getBit(compliment(B),34);
  printf("get bit %llu \n", (1ULL << 33) & compliment(B).board[0]);
  MBOARD MM = {.board = {1ULL << 60,1,1,1}};
  drawBoard(MM,MM);
  drawBoard(RShift(MM,8),MM);
  drawBoard(bishopDiagonal1(),RShiftBishop1(bishopDiagonal1(),3));
  MBOARD rook = {.board = {0xFFFF,0,0,0}};
  drawBoard(LShiftRook(rook,5),{0});
  drawBoard(getBishopMask(UShiftRook(C,5)),UShiftRook(C,5));
  */  
  
  return 0;
}
