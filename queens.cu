#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/reduce.h>
#include <thrust/functional.h>
#include <thrust/random.h>
#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#define N 4
#define R 64 / N
#define M R * R

typedef unsigned long long uint64;
typedef unsigned long long  BOARD;

typedef struct MBOARD {
  BOARD board[N] = {0};
} MBOARD;

BOARD getBit(MBOARD B, BOARD b) {
  BOARD d = b/64;
  BOARD r  = b % 64;
  //  printf("%llu %llu %llu\n", d, r, ((1ULL << r) & B.board[d]));
  return ((1ULL << r) & B.board[d]);
}

MBOARD bishopDiagonal1() {
  BOARD B1 = 1ULL | 1ULL << 17 | 1ULL << 34 | 1ULL << 51;
  BOARD B2 = B1 << 4;
  BOARD B3 = B2 << 4;
  BOARD B4 = B3 << 4;

  return (MBOARD){.board = {B1,B2,B3,B4}};
}

MBOARD bishopDiagonal2() {
  BOARD B1 = 1ULL << 15 | 1ULL << 30 | 1ULL << 45 | 1ULL << 60;
  BOARD B2 = B1 >> 4;
  BOARD B3 = B2 >> 4;
  BOARD B4 = B3 >> 4;

  return (MBOARD){.board = {B1,B2,B3,B4}};
}

MBOARD compliment(MBOARD B) {
  MBOARD C = B;
  for(int i = 0; i < N; ++i) {
    C.board[i] = ~B.board[i];
  }
  return C;
}

MBOARD LShift(MBOARD B,int k) {
  BOARD t = 0; //(B.board[0] & (((1ULL << (k)) - 1) << 64-k));
  for(int i = 0; i < N; ++i) {
    BOARD T = B.board[i];
    B.board[i] = ((B.board[i] << k) | t);
    t = (T & (((1ULL << (k)) - 1) << 64-k)) >> 64-k;	
  }
  return B;
}

MBOARD RShift(MBOARD B,int k) {
  BOARD t = 0; //B.board[0] & (((1ULL << k) - 1) << 64-k);
  for(int i = N-1; i >= 0; --i) {
    BOARD T = B.board[i];
    B.board[i] = ((B.board[i] >> k) | t);
    t = (T & ((1ULL << (k)) - 1)) << 64-k;	
  }
  return B;
}

MBOARD RShiftBishop1(MBOARD mb, int k) {
  MBOARD r = mb;
  for(int i = 0; i < k; ++i) {
    r = RShift(r,1);
    int p = 15; 
    r.board[0] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & r.board[0];
    r.board[1] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & r.board[1];
    r.board[2] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & r.board[2];
    r.board[3] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & r.board[3];

    /*r.board[1] = ~(1ULL << 15 | 1ULL << 31 | 1ULL << 47 | 1ULL << 63) & r.board[1];
    r.board[2] = ~(1ULL << 15 | 1ULL << 31 | 1ULL << 47 | 1ULL << 63)  & r.board[2];
    r.board[3] = ~(1ULL << 15 | 1ULL << 31 | 1ULL << 47 | 1ULL << 63) & r.board[3]; */
  }
  return r;
}

MBOARD LShiftBishop1(MBOARD mb, int k) {
  MBOARD l = mb;
  for(int i = 0; i < k; ++i) {
    l = LShift(l,1);
    int p = 16; 
    l.board[0] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & l.board[0];
    l.board[1] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & l.board[1];
    l.board[2] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & l.board[2];
    l.board[3] = ~(1ULL << p | 1ULL << (p+16) | 1ULL << (p+32) | 1ULL << (p+48)) & l.board[3];
  }
  return l;
}

MBOARD LShiftRook(MBOARD mb, int k) {
  MBOARD d = mb;
  for(int i = 0; i < k; ++i) {
    d = LShift(d,16);
  }
  return d;
}

MBOARD RShiftRook(MBOARD mb, int k) {
  MBOARD d = mb;
  for(int i = 0; i < k; ++i) {
    d = RShift(d,16);
  }
  return d;
}

MBOARD UShiftRook(MBOARD mb, int k) {
  MBOARD d = mb;
  for(int i = 0; i < k; ++i) {
    d = LShift(d,1);
  }
  return d;
}

MBOARD DShiftRook(MBOARD mb, int k) {
  MBOARD d = mb;
  for(int i = 0; i < k; ++i) {
    d = RShift(d,1);
  }
  return d;
}

void drawBoard(MBOARD white, MBOARD black) {
  for(int r = 0; r < R; ++r) {
    for(int c = 0; c < R; ++c) {
      if(getBit(white, r*R + c)) 
	printf(" %s ", "\u2655");
      else if(getBit(black,r*R + c)) 
	printf(" %s ", "\u265B");
      else{  
	printf(" %s ", "\u25A0");
      }
    }
    printf("\n");
  }
  printf("\n");  
}

BOARD Positive(MBOARD B) {
  return (B.board[0] || B.board[1] || B.board[2] || B.board[3]);
  }

MBOARD And(MBOARD A, MBOARD B) {
  return (MBOARD){.board = {(A.board[0] & B.board[0]),(A.board[1] & B.board[1]),
      (A.board[2] & B.board[2]), (A.board[3] & B.board[3])}};
}
MBOARD Or(MBOARD A, MBOARD B) {
  return (MBOARD){.board = {
      A.board[0] | B.board[0],
      A.board[1] | B.board[1],
      A.board[2] | B.board[2],
      A.board[3] | B.board[3]}};
}

MBOARD Not(MBOARD B){
  return (MBOARD){.board = {~(B.board[0]),~(B.board[1]),~(B.board[2]),~(B.board[3])}};
}

MBOARD getBishopMask(MBOARD queens) {
  MBOARD BISHOP1 = bishopDiagonal1(); //0x8040201008040201;
  MBOARD BISHOP2 = bishopDiagonal2(); //0x0102040810204080;
  
  MBOARD pos = queens;

  MBOARD r1 = {0},r2 = {0},r3 = {0},r4 = {0},r5 = {0},r6 = {0},r7 = {0},r8 = {0},l1 = {0},l2 = {0},l3= {0},l4 = {0},l5 = {0},
    l6 = {0},l7 = {0},l8 = {0};
  MBOARD u1 = {0},u2 = {0},u3 = {0},u4 = {0},u5 = {0},u6 = {0},u7 = {0},u8 = {0},d1 = {0},d2 = {0},d3 = {0},d4 = {0},d5 = {0}
    ,d6 = {0},d7 = {0},d8 = {0};
  MBOARD r9 = {0},r10 = {0},r11 = {0},r12 = {0},r13 = {0},r14 = {0},r15 = {0},r16 = {0},l9 = {0},l10 = {0},l11= {0},l12 = {0},l13 = {0},
    l14 = {0},l15 = {0},l16 = {0};
  MBOARD u9 = {0},u10 = {0},u11 = {0},u12 = {0},u13 = {0},u14 = {0},u15 = {0},u16 = {0},d9 = {0},d10 = {0},d11 = {0},d12 = {0},d13 = {0},d14 = {0},d15 = {0},d16 = {0};

  
  for(MBOARD mask1 = BISHOP1, mask2 = BISHOP1; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1)) {
     drawBoard(queens,r1);
    if(Positive(And(queens,mask2))) {
      //drawBoard(queens,mask2);
      //drawBoard(queens,r5);
      r1 = Or(r1, And(LShift(queens, 17), And(Not(pos),mask2)));
      r2 = Or(r1, And(LShift(r1, 17), And(Not(pos),mask2)));
      r3 = Or(r3, And(LShift(r2, 17), And(Not(pos),mask2)));
      r4 = Or(r4, And(LShift(r3, 17), And(Not(pos),mask2)));
      r5 = Or(r5, And(LShift(r4, 17), And(Not(pos),mask2)));
      r6 = Or(r6, And(LShift(r5, 17), And(Not(pos),mask2)));
      r7 = Or(r7, And(LShift(r6, 17), And(Not(pos),mask2)));
      r8 = Or(r8, And(LShift(r7, 17), And(Not(pos),mask2)));
      r9 = Or(r9, And(LShift(r8, 17), And(Not(pos),mask2)));
      r10 = Or(r10, And(LShift(r9, 17), And(Not(pos),mask2)));
      r11 = Or(r11, And(LShift(r10, 17), And(Not(pos),mask2)));
      r12 = Or(r12, And(LShift(r11, 17), And(Not(pos),mask2)));
      r13 = Or(r13, And(LShift(r12, 17), And(Not(pos),mask2)));
      r14 = Or(r14, And(LShift(r13, 17), And(Not(pos),mask2)));
      r15 = Or(r15, And(LShift(r14, 17), And(Not(pos),mask2)));
      r16 = Or(r16, And(LShift(r15, 17), And(Not(pos),mask2)));
  

      l1 = Or(l1, And(RShift(queens,17), And(Not(pos),mask2)));
      l2 = Or(l1, And(RShift(l1,17), And(Not(pos),mask2)));
      l3 = Or(l3, And(RShift(l2,17), And(Not(pos),mask2)));
      l4 = Or(l4, And(RShift(l3,17), And(Not(pos),mask2)));
      l5 = Or(l5, And(RShift(l4,17), And(Not(pos),mask2)));
      l6 = Or(l6, And(RShift(l5,17), And(Not(pos),mask2)));
      l7 = Or(l7, And(RShift(l6,17), And(Not(pos),mask2)));
      l8 = Or(l8, And(RShift(l7,17), And(Not(pos),mask2)));
      l9 = Or(l9, And(RShift(l8,17), And(Not(pos),mask2)));
      l10 = Or(l10, And(RShift(l9,17), And(Not(pos),mask2)));
      l11 = Or(l11, And(RShift(l10,17), And(Not(pos),mask2)));
      l12 = Or(l12, And(RShift(l11,17), And(Not(pos),mask2)));
      l13 = Or(l13, And(RShift(l12,17), And(Not(pos),mask2)));
      l14 = Or(l14, And(RShift(l13,17), And(Not(pos),mask2)));
      l15 = Or(l15, And(RShift(l14,17), And(Not(pos),mask2)));
      l16 = Or(l16, And(RShift(l15,17), And(Not(pos),mask2)));

    }
    
    if(Positive(And(queens, mask1))) {

      r1 = Or(r1, And(LShift(queens, 17), And(Not(pos),mask1)));
      r2 = Or(r2, And(LShift(r1, 17), And(Not(pos),mask1)));
      r3 = Or(r3, And(LShift(r2, 17), And(Not(pos),mask1)));
      r4 = Or(r4, And(LShift(r3, 17), And(Not(pos),mask1)));
      r5 = Or(r5, And(LShift(r4, 17), And(Not(pos),mask1)));
      r6 = Or(r6, And(LShift(r5, 17), And(Not(pos),mask1)));
      r7 = Or(r7, And(LShift(r6, 17), And(Not(pos),mask1)));
      r8 = Or(r8, And(LShift(r7, 17), And(Not(pos),mask1)));
      r9 = Or(r9, And(LShift(r8, 17), And(Not(pos),mask1)));
      r10 = Or(r10, And(LShift(r9, 17), And(Not(pos),mask1)));
      r11 = Or(r11, And(LShift(r10, 17), And(Not(pos),mask1)));
      r12 = Or(r12, And(LShift(r11, 17), And(Not(pos),mask1)));
      r13 = Or(r13, And(LShift(r12, 17), And(Not(pos),mask1)));
      r14 = Or(r14, And(LShift(r13, 17), And(Not(pos),mask1)));
      r15 = Or(r15, And(LShift(r14, 17), And(Not(pos),mask1)));
      r16 = Or(r16, And(LShift(r15, 17), And(Not(pos),mask1)));
  

      l1 = Or(l1, And(RShift(queens,17), And(Not(pos),mask1)));
      l2 = Or(l2, And(RShift(l1,17), And(Not(pos),mask1)));
      l3 = Or(l3, And(RShift(l2,17), And(Not(pos),mask1)));
      l4 = Or(l4, And(RShift(l3,17), And(Not(pos),mask1)));
      l5 = Or(l5, And(RShift(l4,17), And(Not(pos),mask1)));
      l6 = Or(l6, And(RShift(l5,17), And(Not(pos),mask1)));
      l7 = Or(l7, And(RShift(l6,17), And(Not(pos),mask1)));
      l8 = Or(l8, And(RShift(l7,17), And(Not(pos),mask1)));
      l9 = Or(l9, And(RShift(l8,17), And(Not(pos),mask1)));
      l10 = Or(l10, And(RShift(l9,17), And(Not(pos),mask1)));
      l11 = Or(l11, And(RShift(l10,17), And(Not(pos),mask1)));
      l12 = Or(l12, And(RShift(l11,17), And(Not(pos),mask1)));
      l13 = Or(l13, And(RShift(l12,17), And(Not(pos),mask1)));
      l14 = Or(l14, And(RShift(l13,17), And(Not(pos),mask1)));
      l15 = Or(l15, And(RShift(l14,17), And(Not(pos),mask1)));
      l16 = Or(l16, And(RShift(l15,17), And(Not(pos),mask1)));

     
    }
      
  } 
  
  for(MBOARD mask1 = BISHOP2, mask2 = BISHOP2; Positive(mask2); mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1) ) {
     if(Positive(And(queens, mask1))) {
      u1 = Or(u1, And(LShift(queens,15), And(Not(pos),mask1)));
      u2 = Or(u2, And(LShift(u1,15), And(Not(pos),mask1)));
      u3 = Or(u3, And(LShift(u2,15), And(Not(pos),mask1)));
      u4 = Or(u4, And(LShift(u3,15), And(Not(pos),mask1)));
      u5 = Or(u5, And(LShift(u4,15), And(Not(pos),mask1)));
      u6 = Or(u6, And(LShift(u5,15), And(Not(pos),mask1)));
      u7 = Or(u7, And(LShift(u6,15), And(Not(pos),mask1)));
      u8 = Or(u8, And(LShift(u7,15), And(Not(pos),mask1)));
      u9 = Or(u9, And(LShift(u8,15), And(Not(pos),mask1)));
      u10 = Or(u10, And(LShift(u9,15), And(Not(pos),mask1)));
      u11 = Or(u11, And(LShift(u10,15), And(Not(pos),mask1)));
      u12 = Or(u12, And(LShift(u11,15), And(Not(pos),mask1)));
      u13 = Or(u13, And(LShift(u12,15), And(Not(pos),mask1)));
      u14 = Or(u14, And(LShift(u13,15), And(Not(pos),mask1)));
      u15 = Or(u15, And(LShift(u14,15), And(Not(pos),mask1)));
      u16 = Or(u16, And(LShift(u15,15), And(Not(pos),mask1)));

      d1 = Or(d1, And(RShift(queens,15), And(Not(pos),mask1)));
      d2 = Or(d2, And(RShift(d1,15), And(Not(pos),mask1)));
      d3 = Or(d3, And(RShift(d2,15), And(Not(pos),mask1)));
      d4 = Or(d4, And(RShift(d3,15), And(Not(pos),mask1)));
      d5 = Or(d5, And(RShift(d4,15), And(Not(pos),mask1)));
      d6 = Or(d6, And(RShift(d5,15), And(Not(pos),mask1)));
      d7 = Or(d7, And(RShift(d6,15), And(Not(pos),mask1)));
      d8 = Or(d8, And(LShift(d7,15), And(Not(pos),mask1)));
      d9 = Or(d9, And(RShift(d8,15), And(Not(pos),mask1)));
      d10 = Or(d10, And(RShift(d9,15), And(Not(pos),mask1)));
      d11 = Or(d11, And(RShift(d10,15), And(Not(pos),mask1)));
      d12 = Or(d12, And(RShift(d11,15), And(Not(pos),mask1)));
      d13 = Or(d13, And(RShift(d12,15), And(Not(pos),mask1)));
      d14 = Or(d14, And(RShift(d13,15), And(Not(pos),mask1)));
      d15 = Or(d15, And(RShift(d14,15), And(Not(pos),mask1)));
      d16 = Or(d16, And(RShift(d15,15), And(Not(pos),mask1)));
    }
    if(Positive(And(queens,mask2))) {
      u1 = Or(u1, And(LShift(queens,15), And(Not(pos),mask2)));
      u2 = Or(u2, And(LShift(u1,15), And(Not(pos),mask2)));
      u3 = Or(u3, And(LShift(u2,15), And(Not(pos),mask2)));
      u4 = Or(u4, And(LShift(u3,15), And(Not(pos),mask2)));
      u5 = Or(u5, And(LShift(u4,15), And(Not(pos),mask2)));
      u6 = Or(u6, And(LShift(u5,15), And(Not(pos),mask2)));
      u7 = Or(u7, And(LShift(u6,15), And(Not(pos),mask2)));
      u8 = Or(u8, And(LShift(u7,15), And(Not(pos),mask2)));
      u9 = Or(u9, And(LShift(u8,15), And(Not(pos),mask2)));
      u10 = Or(u10, And(LShift(u9,15), And(Not(pos),mask2)));
      u11 = Or(u11, And(LShift(u10,15), And(Not(pos),mask2)));
      u12 = Or(u12, And(LShift(u11,15), And(Not(pos),mask2)));
      u13 = Or(u13, And(LShift(u12,15), And(Not(pos),mask2)));
      u14 = Or(u14, And(LShift(u13,15), And(Not(pos),mask2)));
      u15 = Or(u15, And(LShift(u14,15), And(Not(pos),mask2)));
      u16 = Or(u16, And(LShift(u15,15), And(Not(pos),mask2)));

      d1 = Or(d1, And(RShift(queens,15), And(Not(pos),mask2)));
      d2 = Or(d1, And(RShift(d1,15), And(Not(pos),mask2)));
      d3 = Or(d2, And(RShift(d2,15), And(Not(pos),mask2)));
      d4 = Or(d3, And(RShift(d3,15), And(Not(pos),mask2)));
      d5 = Or(d4, And(RShift(d4,15), And(Not(pos),mask2)));
      d6 = Or(d5, And(RShift(d5,15), And(Not(pos),mask2)));
      d7 = Or(d7, And(RShift(d6,15), And(Not(pos),mask2)));
      d8 = Or(d8, And(LShift(d7,15), And(Not(pos),mask2)));
      d9 = Or(d9, And(RShift(d8,15), And(Not(pos),mask2)));
      d10 = Or(d10, And(RShift(d9,15), And(Not(pos),mask2)));
      d11 = Or(d11, And(RShift(d10,15), And(Not(pos),mask2)));
      d12 = Or(d12, And(RShift(d11,15), And(Not(pos),mask2)));
      d13 = Or(d13, And(RShift(d12,15), And(Not(pos),mask2)));
      d14 = Or(d14, And(RShift(d13,15), And(Not(pos),mask2)));
      d15 = Or(d15, And(RShift(d14,15), And(Not(pos),mask2)));
      d16 = Or(d16, And(RShift(d15,15), And(Not(pos),mask2)));
      }   
  }
  
  MBOARD bishopMask1 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r1, r2),r3),r4),r5),r6),r7),r8),l1),
											     l2),l3),l4),l5), l6), l7), l8),
									u1), u2), u3), u4), u5), u6), u7), u8),d1), d2), d3), d4), d5), d6), d7), d8);

  MBOARD bishopMask2 =  Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(r9, r10),r11),r12),r13),r14),r15),r16),l9),
											     l10),l11),l12),l13), l14), l15), l16),
									u9), u10), u11), u12), u13), u14), u15), u16),d9), d10), d11), d12), d13), d14), d15), d16);
  
  return Or(bishopMask1, bishopMask2);
  } 

int main() {
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
  return 0;
}
