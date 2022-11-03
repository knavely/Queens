#include "generator.h"

typedef unsigned long long uint64;
typedef unsigned long long  BOARD;

void drawBoard(BOARD white, BOARD black) {
  for(int r = 0; r < 8; ++r) {
    for(int c = 0; c < 8; ++c) {
      if( (1L << (r*8 + c)) & white) 
	printf(" %s ", "\u2655");
      else if( (1L << (r*8 + c)) & black) 
	printf(" %s ", "\u265B");
      else  
	printf(" %s ", "\u25A0");
    }
    printf("\n");
  }
  printf("\n");
  
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

BOARD findNN(BOARD board) {
  int w = countWhiteQueens(board);
  int b = countBlackQueensFromBoard(board);
  //increase black queens
  if(w > b) {
    int j = 64;
    BOARD max = board - 1;
    int i;
    do {
      i = (rand() % 64) + 1;
      if(board & (1ULL << i)){
	j--;
	BOARD t = board ^ (1ULL << i);
	if(countBlackQueensFromBoard(max) < countBlackQueensFromBoard(t))
	  max = t;
      }
    } while(j && !(board & (1ULL << i)));
    
    return max;
  } //reduce black queens
  else if(b > w) {
    int i;
    int j = 64;
    BOARD min = board+1;
    do {
      i = (rand() % 64) + 1;
      if(!(board & (1ULL << i))){
	BOARD t = board ^ (1ULL << i);
	if(countBlackQueensFromBoard(min) > countBlackQueensFromBoard(t))
	  min = t;
	j--;
      }
    } while(j && (board & (1ULL << i)));
    
    return min;
  }
  else {
    return board;
  }
}

BOARD firstGuess() {
  BOARD start = rrand();//(rrand() % 2) | ((rrand() % 2) << 1) | ((rrand() % 2) << 2)
    //| ((rrand() % 2) << 3) | ((rrand() % 2) << 4) | ((rrand() % 2) << 5)
    //| ((rrand() % 2) << 6) | ((rrand() % 2) << 7) | ((rrand() % 2) << 8);

  int i = 0;
  BOARD f = findNN(start);
  BOARD p = start;
  while(f != p) {    
    if(i % 100000000 == 0) {
      drawBoard(f,~getQueenMask(f));
    }
    
    //f = findNN(f);
    //    if(countWhiteQueens(f) < 9)
    f = rrand();
    //    p = f;
    if(countWhiteQueens(f) == countBlackQueensFromBoard(f)) {
      //drawBoard(f, ~getQueenMask(f));
      if(countWhiteQueens(f) == 9)
	return f;
    }
    ++i;
  }
  return f;
}

int main(){
  //BOARD f = firstGuess();
  //printf("FIRST \n");
  //drawBoard(f, ~getQueenMask(f));
  
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
  BOARD c = 0;
  /*    do {
    board = getNextBoard(board);
    mask = getQueenMask(board);
    BOARD B;
    if(i % 1000000000 == 0) {
      drawBoard(B, ~getQueenMask(B));
      printf("Found %llu solutions, iteration %llu \n",c, i);
    }
    //    BOARD c = __builtin_popcount(board);
    //    printf("%llu \n", mask);
    ++i;
    if(countBlackQueens(mask) == 9) {
      B = board;
      ++c;
    }
  } while(countWhiteQueens(board) < 10);//while(countBlackQueens(mask) < 9);
  */
  printf("Found %llu solutions \n",c);
  printf("%llu\n",countBlackQueens(mask));

  drawBoard(board, ~mask);
  
  BOARD pattern = 1ULL | (1ULL << 8) | (1ULL << 16) | (1ULL << 24)
    | (1ULL << 32ULL) | (1ULL << 40ULL) | (1ULL << 48ULL) | (1ULL << 56ULL);
  
  BOARD white = 1ULL << 60;
  BOARD black = getQueenMask(white);
  drawBoard(white,0);
  printf("\n");
  drawBoard(0,black);

  printf("%llu \n",pattern);

  BOARD g;
  srand(time(0));
  do {
    g = genWord(.4,4);
    //drawBoard(g,~getQueenMask(g));
    //    printf("white queens %llu\n", countWhiteQueens(g));
  } while(!((countBlackQueensFromBoard(g) == countWhiteQueens(g)) && (countWhiteQueens(g) == 9)));
  drawBoard(g,~getQueenMask(g));
  return 0;    
}
