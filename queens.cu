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

/*
MBOARD getBishopMask(MBOARD queens) {
  const unsigned long BISHOP1 = 0x8040201008040201;
  const unsigned long BISHOP2 = 0x0102040810204080;
  
  MBOARD bishops = queens;
  MBOARD pos = queens;

  unsigned long r1 = 0,r2 = 0,r3 = 0,r4 = 0,r5 = 0,r6 = 0,r7 = 0,r8 = 0,l1 = 0,l2 = 0,l3= 0,l4 = 0,l5 = 0,
    l6 = 0,l7 = 0,l8 = 0;
  unsigned long u1 = 0,u2 = 0,u3 = 0,u4 = 0,u5 = 0,u6 = 0,u7 = 0,u8 = 0,d1 = 0,d2 = 0,d3 = 0,d4 = 0,d5 = 0
    ,d6 = 0,d7 = 0,d8 = 0;

  
  for(unsigned long mask1 = BISHOP1, mask2 = BISHOP1; mask2 > 0; mask1 = mask1 >> 8, mask2 = mask2 << 8 ) {
    if(queens & mask2) {
      r1 |= (queens << 9) & ~pos & mask2;
      r2 |= (r1 << 9) & ~pos & mask2;
      r3 |= (r2 << 9) & ~pos & mask2;
      r4 |= (r3 << 9) & ~pos & mask2;
      r5 |= (r4 << 9) & ~pos & mask2;
      r6 |= (r5 << 9) & ~pos & mask2;
      r7 |= (r6 << 9) & ~pos & mask2;
      r8 |= (r7 << 9) & ~pos & mask2;

      l1 |= (queens >> 9) & ~pos & mask2;
      l2 |= (l1 >> 9) & ~pos & mask2;
      l3 |= (l2 >> 9) & ~pos & mask2;
      l4 |= (l3 >> 9) & ~pos & mask2;
      l5 |= (l4 >> 9) & ~pos & mask2;
      l6 |= (l5 >> 9) & ~pos & mask2;
      l7 |= (l6 >> 9) & ~pos & mask2;
      l8 |= (l7 >> 9) & ~pos & mask2;
    } 
    if(queens & mask1) {
      r1 |= (queens << 9) & ~pos & mask1;
      r2 |= (r1 <<9)  & ~pos & mask1;
      r3 |= (r2 << 9) & ~pos & mask1;
      r4 |= (r3  << 9) & ~pos & mask1;
      r5 |= (r4 << 9) & ~pos & mask1;
      r6 |= (r5 << 9) & ~pos & mask1;
      r7 |= (r6 << 9) & ~pos & mask1;
      r8 |= (r7  << 9) & ~pos & mask1;

      l1 |= (queens >> 9) & ~pos & mask1;
      l2 |= (l1 >> 9) & ~pos & mask1;
      l3 |= (l2 >> 9) & ~pos & mask1;
      l4 |= (l3 >> 9) & ~pos & mask1;
      l5 |= (l4 >> 9) & ~pos & mask1;
      l6 |= (l5 >> 9) & ~pos & mask1;
      l7 |= (l6 >> 9) & ~pos & mask1;
      l8 |= (l7 >> 9) & ~pos & mask1;
    }  
  } 
  
  for(unsigned long mask1 = BISHOP2, mask2 = BISHOP2; mask2 > 0; mask1 = mask1 >> 8, mask2 = mask2 << 8 ) {
    if(queens & mask1) { 
      u1 |= (queens  << 7) & ~pos & mask1;
      u2 |= (u1 << 7) & ~pos & mask1;
      u3 |= (u2 << 7) & ~pos & mask1;
      u4 |= (u3 << 7) & ~pos & mask1;
      u5 |= (u4 << 7) & ~pos & mask1;
      u6 |= (u5 << 7) & ~pos & mask1;
      u7 |= (u6 << 7) & ~pos & mask1;
      u8 |= (u7 << 7) & ~pos & mask1;

      d1 |= (queens  >> 7) & ~pos & mask1;
      d2 |= (d1 >> 7) & ~pos & mask1;
      d3 |= (d2 >> 7) & ~pos & mask1;
      d4 |= (d3 >> 7) & ~pos & mask1;
      d5 |= (d4 >> 7) & ~pos & mask1;
      d6 |= (d5 >> 7) & ~pos & mask1;
      d7 |= (d6 >> 7) & ~pos & mask1;
      d8 |= (d7 >> 7) & ~pos & mask1;
    }
    if(queens & mask2) {
      u1 |= (queens << 7) & ~pos & mask2;
      u2 |= (u1 << 7) & ~pos & mask2;
      u3 |= (u2 << 7) & ~pos & mask2;
      u4 |= (u3 << 7) & ~pos & mask2;
      u5 |= (u4 << 7) & ~pos & mask2;
      u6 |= (u5 << 7) & ~pos & mask2;
      u7 |= (u6 << 7) & ~pos & mask2;
      u8 |= (u7 << 7) & ~pos & mask2;

      d1 |= (queens >> 7) & ~pos & mask2;
      d2 |= (d1 >> 7) & ~pos & mask2;
      d3 |= (d2 >> 7) & ~pos & mask2;
      d4 |= (d3 >> 7) & ~pos & mask2;
      d5 |= (d4 >> 7) & ~pos & mask2;
      d6 |= (d5 >> 7) & ~pos & mask2;
      d7 |= (d6 >> 7) & ~pos & mask2;
      d8 |= (d7 >> 7) & ~pos & mask2;
    }  
  }
  
  BOARD bishopMask =  r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 |
    l1 | l2 | l3 | l4 | l5 | l6 | l7 | l8 |
    u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8 |
    d1 | d2 | d3 | d4 | d5 | d6 | d7 | d8;
  
  return bishopMask;
  } */

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
  drawBoard(bishopDiagonal1(),RShiftBishop1(bishopDiagonal2(),3));
  return 0;
}
