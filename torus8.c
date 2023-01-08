#include "gen.h"
#include <time.h>


typedef unsigned long long uint64;
typedef unsigned long long  BOARD;


void drawBoard(BOARD white, BOARD black) {
  for(int r = 0; r < 8; ++r) {
    for(int c = 0; c < 8; ++c) {
      if( (1L << (r*8 + c)) & white) 
	printf("%s ", "\u2655");
      else if( (1L << (r*8 + c)) & black) 
	printf("%s ", "\u265B");
      else  
	printf("%s ", "\u25A0");
    }
    printf("\n");
  }
  printf("\n");
}

/*
void drawBoard(BOARD white, BOARD black) {
  for(int r = 0; r < 8; ++r) {
    for(int c = 0; c < 8; ++c) {
      if( (1L << (r*8 + c)) & white) 
	printf("%s ", "\u25A0");
      else if( (1L << (r*8 + c)) & black) 
	printf("%s ", "\u25A1");
      else  
	printf("%s ", "\u25A6");
    }
    printf("\n");
  }
  printf("\n");
}
*/

BOARD LShift(BOARD B,int k) {
  BOARD t = 0, t0 = 0; //(B.board[0] & (((1ULL << (k)) - 1) << 64-k));
  
  BOARD T = B;

  if((~((1ULL << (k)) - 1) & B)){
    t0 = (~((1ULL << (k)) - 1) & B) >> 64 - k;
  }

  t = (T & (((1ULL << (k)) - 1) << 64-k)) >> 64-k;	
  B = ((B << k) | t);
  
  B = B | t0;
  return B;
}

BOARD RShift(BOARD B,int k) {
  BOARD t = 0ULL, t16 = 0ULL; //B.board[0] & (((1ULL << k) - 1) << 64-k);
  
  BOARD T = B;
  if((((1ULL << k) - 1) & B)){
    t16 = (((1ULL << k) - 1) & B) << 64 - k;
  }

  t = (T & ((1ULL << (k)) - 1)) << 64-k;	
  B = ((B >> k) | t);
  
  B = B | t16;
  return B;
}

BOARD RShiftBishop1(BOARD mb, int k) {
  BOARD r = mb;
  for(int i = 0; i < k; ++i) {
    r = RShift(r,8);
  }
  return r;
}

BOARD LShiftBishop1(BOARD mb, int k) {
  BOARD l = mb;
  for(int i = 0; i < k; ++i) {
    l = LShift(l,8);
  }
  return l;
}

BOARD getBishopMask(BOARD queens) {
  const unsigned long BISHOP1 = 0x8040201008040201;
  const unsigned long BISHOP2 = 0x0102040810204080;
  const unsigned long BISHOP3 = (BISHOP1 >>1);
  const unsigned long BISHOP4 = BISHOP2 <<1;
  const unsigned long BISHOP = BISHOP1 | BISHOP3;

  unsigned long bishops = queens;
  unsigned long pos = queens;

  unsigned long r1 = 0,r2 = 0,r3 = 0,r4 = 0,r5 = 0,r6 = 0,r7 = 0,r8 = 0,l1 = 0,l2 = 0,l3= 0,l4 = 0,l5 = 0,
    l6 = 0,l7 = 0,l8 = 0;
  unsigned long u1 = 0,u2 = 0,u3 = 0,u4 = 0,u5 = 0,u6 = 0,u7 = 0,u8 = 0,d1 = 0,d2 = 0,d3 = 0,d4 = 0,d5 = 0
    ,d6 = 0,d7 = 0,d8 = 0;

  int i = 0;
  for(unsigned long mask1 = BISHOP1, mask2 = BISHOP1; i < 8; mask1 = RShiftBishop1(mask1,1),
	mask2 = LShiftBishop1(mask2,1), ++i ) {
    if(queens & mask2) {
      r1 |= (LShift(queens,9)) & ~pos & mask2;
      r2 |= LShift(r1,9) & ~pos & mask2;
      r3 |= LShift(r2,9) & ~pos & mask2;
      r4 |= LShift(r3,9) & ~pos & mask2;
      r5 |= LShift(r4,9) & ~pos & mask2;
      r6 |= LShift(r5,9) & ~pos & mask2;
      r7 |= LShift(r6,9) & ~pos & mask2;
      r8 |= LShift(r7,9) & ~pos & mask2;

      l1 |= RShift(queens,9) & ~pos & mask2;
      l2 |= RShift(l1, 9) & ~pos & mask2;
      l3 |= RShift(l2, 9) & ~pos & mask2;
      l4 |= RShift(l3, 9) & ~pos & mask2;
      l5 |= RShift(l4, 9) & ~pos & mask2;
      l6 |= RShift(l5, 9) & ~pos & mask2;
      l7 |= RShift(l6, 9) & ~pos & mask2;
      l8 |= RShift(l7, 9) & ~pos & mask2;
    } 
    if(queens & mask1) {
      r1 |= LShift(queens, 9) & ~pos & mask1;
      r2 |= LShift(r1, 9)  & ~pos & mask1;
      r3 |= LShift(r2, 9) & ~pos & mask1;
      r4 |= LShift(r3, 9) & ~pos & mask1;
      r5 |= LShift(r4, 9) & ~pos & mask1;
      r6 |= LShift(r5, 9) & ~pos & mask1;
      r7 |= LShift(r6, 9) & ~pos & mask1;
      r8 |= LShift(r7, 9) & ~pos & mask1;

      l1 |= RShift(queens, 9) & ~pos & mask1;
      l2 |= RShift(l1, 9) & ~pos & mask1;
      l3 |= RShift(l2, 9) & ~pos & mask1;
      l4 |= RShift(l3, 9) & ~pos & mask1;
      l5 |= RShift(l4, 9) & ~pos & mask1;
      l6 |= RShift(l5, 9) & ~pos & mask1;
      l7 |= RShift(l6, 9) & ~pos & mask1;
      l8 |= RShift(l7, 9) & ~pos & mask1;
    }  
  } 
  i = 0;
  for(unsigned long mask1 = BISHOP2, mask2 = BISHOP2; i < 8; mask1 = RShiftBishop1(mask1,1), mask2 = LShiftBishop1(mask2,1), ++i ) {
    if(queens & mask1) { 
      u1 |= LShift(queens, 7) & ~pos & mask1;
      u2 |= LShift(u1, 7) & ~pos & mask1;
      u3 |= LShift(u2, 7) & ~pos & mask1;
      u4 |= LShift(u3, 7) & ~pos & mask1;
      u5 |= LShift(u4, 7) & ~pos & mask1;
      u6 |= LShift(u5, 7) & ~pos & mask1;
      u7 |= LShift(u6, 7) & ~pos & mask1;
      u8 |= LShift(u7, 7) & ~pos & mask1;

      d1 |= RShift(queens, 7) & ~pos & mask1;
      d2 |= RShift(d1, 7) & ~pos & mask1;
      d3 |= RShift(d2, 7) & ~pos & mask1;
      d4 |= RShift(d3, 7) & ~pos & mask1;
      d5 |= RShift(d4, 7) & ~pos & mask1;
      d6 |= RShift(d5, 7) & ~pos & mask1;
      d7 |= RShift(d6, 7) & ~pos & mask1;
      d8 |= RShift(d7, 7) & ~pos & mask1;
    }
    if(queens & mask2) {
      u1 |= LShift(queens, 7) & ~pos & mask2;
      u2 |= LShift(u1, 7) & ~pos & mask2;
      u3 |= LShift(u2, 7) & ~pos & mask2;
      u4 |= LShift(u3, 7) & ~pos & mask2;
      u5 |= LShift(u4, 7) & ~pos & mask2;
      u6 |= LShift(u5, 7) & ~pos & mask2;
      u7 |= LShift(u6, 7) & ~pos & mask2;
      u8 |= LShift(u7, 7) & ~pos & mask2;

      d1 |= RShift(queens, 7) & ~pos & mask2;
      d2 |= RShift(d1, 7) & ~pos & mask2;
      d3 |= RShift(d2, 7) & ~pos & mask2;
      d4 |= RShift(d3, 7) & ~pos & mask2;
      d5 |= RShift(d4, 7) & ~pos & mask2;
      d6 |= RShift(d5, 7) & ~pos & mask2;
      d7 |= RShift(d6, 7) & ~pos & mask2;
      d8 |= RShift(d7, 7) & ~pos & mask2;
    }  
  }
  
  BOARD bishopMask =  r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 |
    l1 | l2 | l3 | l4 | l5 | l6 | l7 | l8 |
    u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8 |
    d1 | d2 | d3 | d4 | d5 | d6 | d7 | d8;
  
  return bishopMask;
}

uint64 getRookMask(BOARD queens) {
    BOARD r1 = 0,r2 = 0,r3 = 0,r4 = 0,r5 = 0,r6 = 0,r7 = 0,r8 = 0,l1 = 0,l2 = 0,l3= 0,l4 = 0,l5 = 0,
    l6 = 0,l7 = 0,l8 = 0;
  BOARD u1 = 0,u2 = 0,u3 = 0,u4 = 0,u5 = 0,u6 = 0,u7 = 0,u8 = 0,d1 = 0,d2 = 0,d3 = 0,d4 = 0,d5 = 0
    ,d6 = 0,d7 = 0,d8 = 0;

  BOARD pos = queens;
    for(BOARD mask = 0xFF; mask > 0; mask = mask << 8) {
    if(queens & mask) {
      r1 |= (queens << 1 ) & ~pos & mask;
      r2 |= (r1 << 1) & ~pos & mask;
      r3 |= (r2 << 1) & ~pos & mask;
       r4 |= (r3 << 1) & ~pos & mask;
      r5 |= (r4 << 1) & ~pos & mask;
      r6 |= (r5 << 1) & ~pos & mask;
      r7 |= (r6 << 1) & ~pos & mask;
      r8 |= (r7 << 1) & ~pos & mask;
    
    l1 |= (queens >> 1) & ~pos & mask;
    l2 |= (l1 >> 1) & ~pos & mask;
      l3 |= (l2 >> 1) & ~pos & mask;
      l4 |= (l3 >> 1) & ~pos & mask;
      l5 |= (l4 >> 1) & ~pos & mask;
      l6 |= (l5 >> 1) & ~pos & mask;
      l7 |= (l6 >> 1) & ~pos & mask;
      l8 |= (l7 >> 1) & ~pos & mask; 
    }
    } 
  BOARD pattern = 1ULL | (1ULL << 8) | (1ULL << 16) | (1ULL << 24)
    | (1ULL << 32ULL) | (1ULL << 40ULL) | (1ULL << 48ULL) | (1ULL << 56ULL);
  for(BOARD mask = pattern; mask >0; mask = mask << 1) {
    if(queens & mask) {
      u1 |= (queens << 8) & ~pos & mask;
      u2 |= (u1 << 8) & ~pos & mask;
      u3 |= (u2 << 8) & ~pos & mask;
      u4 |= (u3 << 8) & ~pos & mask;
      u5 |= (u4 << 8) & ~pos & mask;
      u6 |= (u5 << 8) & ~pos & mask;
      u7 |= (u6 << 8) & ~pos & mask;
      u8 |= (u7 << 8) & ~pos & mask;
    
      d1 |= (queens >> 8) & ~pos & mask;
      d2 |= (d1 >> 8) & ~pos & mask;
      d3 |= (d2 >> 8) & ~pos & mask;
      d4 |= (d3 >> 8) & ~pos & mask;
      d5 |= (d4 >> 8) & ~pos & mask;
      d6 |= (d5 >> 8) & ~pos & mask;
      d7 |= (d6 >> 8) & ~pos & mask;
      d8 |= (d7 >> 8) & ~pos & mask;
    } 
  } 
  BOARD rookMask = queens | r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 |
    l1 | l2 | l3 | l4 | l5 | l6 | l7 | l8 |
    u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8 |
    d1 | d2 | d3 | d4 | d5 | d6 | d7 | d8;
    
  return rookMask;
}

BOARD getNextBoard(BOARD v) {
  BOARD t = v | (v - 1); // t gets v's least significant 0 bits set to 1
  return (t + 1) | (((~t & -~t) - 1) >> (__builtin_ctzll(v) + 1));
}

uint64 getQueenMask(uint64 board) {
  return getBishopMask(board) | getRookMask(board);
}

uint64 countBlackQueens(BOARD mask) {
  return __builtin_popcountll(~mask);
}
uint64 countBlackQueensFromBoard(BOARD board) {
  return __builtin_popcountll(~getQueenMask(board));
}

BOARD countWhiteQueens(BOARD board) {
 return  __builtin_popcountll(board);
}

BOARD rrand(){ return (BOARD)(rand());}


int main(){
  
  unsigned long long start = 1L | (1L << 1) | (1L << 2) | (1L << 3) | (1L << 4) | 1L | (1L << 5) | (1L << 6) | (1L << 7) | (1L << 8); // current permutation of bits
  
  unsigned long long w; // next permutation of bits

  unsigned long long t = start | (start - 1); // t gets v's least significant 0 bits set to 1
  // Next set to 1 the most significant bit to change,
  // set to 0 the least significant ones, and add the necessary 1 bits.
  w = (t + 1) | (((~t & -~t) - 1) >> (__builtin_ctz(start) + 1));

  printf("%llu %llu \n",start,w);

  BOARD board = start;
  drawBoard(start,0);
  BOARD mask;

  BOARD i = 1;
  
  printf("%llu\n",countBlackQueens(mask));

  const unsigned long BISHOP1 = 0x8040201008040201;
  const unsigned long BISHOP2 = 0x0102040810204080;

  board = RShiftBishop1(BISHOP2,2);
  drawBoard(board, 0);

  board = LShiftBishop1(BISHOP1,3);
  drawBoard(board, 0);

  drawBoard(getBishopMask(1ULL << 16ULL),1ULL << 16ULL);

  BOARD pattern = 1ULL | (1ULL << 8) | (1ULL << 16) | (1ULL << 24)
    | (1ULL << 32ULL) | (1ULL << 40ULL) | (1ULL << 48ULL) | (1ULL << 56ULL);
  
  BOARD white = 1ULL << 60;
  BOARD black = getBishopMask(white);
  drawBoard(white,0);
  printf("\n");
  drawBoard(0,black);
  drawBoard(~black,white);
  
  printf("%llu \n",pattern);

  BOARD g = 1;
  struct timespec tstart, end;
  srand(time(0));
  time_t t1 = time(0);
  clock_gettime(CLOCK_MONOTONIC, &tstart);
  int mn = 0;
  do {
    g = genWordT8(.3,5);
    //g = rand();
    //g++;
    //drawBoard(g,~getQueenMask(g));
    //    printf("white queens %llu\n", countWhiteQueens(g));
    int bQ = countBlackQueensFromBoard(g);
    int wQ = countWhiteQueens(g);
    mn = (bQ > wQ) ? wQ : bQ;
    if(mn >= 7){
      printf("%i\n",mn);
      drawBoard(g,~getQueenMask(g));
    }
  } while(mn < 8 && g);
  clock_gettime(CLOCK_MONOTONIC, &end);
  time_t t2 = time(0);

  printf("took %f \n", (end.tv_sec - tstart.tv_sec) * 1e9 + (end.tv_nsec - tstart.tv_nsec) * 1e-9);
  drawBoard(g,~getQueenMask(g));
  
  return 0;    
}
