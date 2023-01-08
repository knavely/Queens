#include "gen.h"

typedef unsigned long long BOARD;

int geom(float x) {
  int i = 0;
  x = x * 100;
  int r = x+1;
  while(r > x) {
    r = rand() % 100;
    ++i;
  }
  return i;
}

BOARD genWord64(float x, int m) {
  //B = 1, A = 0
  float c = (pow(x,2)*((1-pow(x,m))*(1-pow(x,m))))/(pow(1-x,2));
  BOARD g = 0ULL;
  int nB = geom(x) % (m+1);
  g = g | ((1ULL << nB) - 1);
  
  int nA = geom(x) % (m+1);
  int core = geom(c);
  for(int i = 0; i < core; ++i) {
    int ya = (geom(x) % (m)) + 1;
    int yb = (geom(x) % (m)) + 1;
    g = g << (ya + yb);
    g = g | ((1ULL << yb) -1);
  }
  
  //  printf("%i , %i \n", nB,nA);
  g = g << nA;
  return g;
}

BOARD genWordT8(float x, int m) {
  //B = 1, A = 0
  float c = (pow(x,2)*((1-pow(x,m))*(1-pow(x,m))))/(pow(1-x,2));
  BOARD g = 0ULL;
  int nB = geom(x) % (m+1);
  g = g | ((1ULL << nB) - 1);
  
  int nA = geom(x) % (m+1);
  int core = geom(c);
  for(int i = 0; i < core; ++i) {
    int ya = (geom(x) % (m)) + 1;
    int yb = (geom(x) % (m)) + 1;
    g = LShift(g,(ya + yb));
    g = g | ((1ULL << yb) -1);
  }
  
  //  printf("%i , %i \n", nB,nA);
  g = LShift(g,nA);
  return g;
}
