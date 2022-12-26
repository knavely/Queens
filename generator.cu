#include "generator.cuh"
//#include "cuda_runtime.h"
//#include <curand.h>
#include "philox.h"


typedef unsigned long long BOARD;

__device__ int geomNV(float x, int id) {
  static int p = 10000;
  thrust::default_random_engine rng;
  thrust::uniform_real_distribution<float> uniform(0.0, 1.0);
  //rng.discard(id);
  //float r = uniform(rng);
  float r = x + 1;
  //   printf("%f\n",r);
  int i = 0;
  while(r > x) {
    rng.discard(id*p++);
    r = uniform(rng);   
    ++i;
  }
  return i;
}

__device__ inline BOARD ROL64(BOARD a, unsigned int offset){
  const int _offset = offset;
  return ((offset != 0) ? ((a << _offset) ^ (a >> (64-offset))) : a);
}

__device__  MBOARD32 genWordNV32(float x, int m, int id) {
  //B = 1, A = 0
  //float c = .01;
  float c = (pow(x,2)*((1-pow(x,m+32))*(1-pow(x,m+32))))/(pow(1-x,2));
 
  MBOARD32 g = {0ULL};
  //int nB = (geomNV(x+.5,id) % (m+1));
  int nB = (geomNV(x,id) % (m+1));
  //  printf("%i\n",nB);
  g.board[0] = g.board[0] | ((1ULL << nB) - 1);
  int nA = (geomNV(x,id) % (1024* m+1));
  int core = geomNV(c,id);
  for(int i = 0; i < core; ++i) {
    int ya = (geomNV(x,id) % ((1024)*m+1)) + 1;
    int yb = ((geomNV(x,id) % (m+1)) +1);

    g = LShift(g,ya);
    g = LShift(g,yb);
    g.board[0] = g.board[0] | ((1ULL << yb) - 1);
    //g.board[((i+nB)/64) % 16] = ROL64(g.board[((i+nB)/64) % 16],(ya + yb));
    //g.board[((i+nB)/64) % 16] = g.board[((i+nB)/64) % 16] | ((1ULL << yb) -1);
  }
  //  printf("%i , %i \n", nB,nA);
  g.board[15] = (g.board[15] << nA) & ~(ROL64(1,nA) -1);
  
  return g;
}

__device__  MBOARD genWordNV(float x, int m, int id) {
  //B = 1, A = 0
  float c = (pow(x,2)*((1-pow(x,m))*(1-pow(x,m))))/(pow(1-x,2));
 
  MBOARD g = {0ULL};
  //  int nB = (geomNV(x+.5,id) % (m+1));
  int nB = (geomNV(x,id) % (m+1));
  //  printf("%i\n",nB);
  g.board[0] = g.board[0] | ((1ULL << nB) - 1);
  /*
  int nA = geomNV(x,id)*4 % (256*m+1);
  int core = geomNV(c,id);
  for(int i = 0; i < core; ++i) {
    int ya = (geomNV(x,id) % (300*m+1))*4 + 1;
    int yb = ((geomNV(x+.5,id) % (m+1)) +1);
    g.board[((i+nB)/64) % 4] = ROL64(g.board[((i+nB)/64) % 4],(ya + yb));
    g.board[((i+nB)/64) % 4] = g.board[((i+nB)/64) % 4] | ((1ULL << yb) -1);
  }
  */
  int nA = geomNV(x,id) % (m+1);
  int core = geomNV(c,id);
  for(int i = 0; i < core; ++i) {
    int ya = (geomNV(x,id) % (300*m+1))*4 + 1;
    int yb = ((geomNV(x,id) % (m+1)) +1);
    g.board[((i+nB)/64) % 4] = ROL64(g.board[((i+nB)/64) % 4],(ya + yb));
    g.board[((i+nB)/64) % 4] = g.board[((i+nB)/64) % 4] | ((1ULL << yb) -1);
  }
  //  printf("%i , %i \n", nB,nA);
  g.board[3] = g.board[3] & ~(ROL64(1,nA) -1);
  
  return g;
}

__device__  int geom(float x,int id) {
  static int p = 0;
  //if(p == 5000)
  p = p + 10000 + id;
  Philox_2x32<20> sampler;
  int i = 0;
  //x = x * 100;
  int r = x+1;
  float rr = x+1;
  while(rr > x) {
    //rr = sampler.rand_int(p+5001,p+5002,p+5003,100);
    rr = sampler.rand_float(p+id,0,1.0);
    p++;
    ++i;
  }
  return i;
}

__device__  BOARD genWord(float x, int m, int id) {
  //B = 1, A = 0
  float c = (pow(x,2)*((1-pow(x,m))*(1-pow(x,m))))/(pow(1-x,2));
  BOARD g = 0ULL;
  int nB = geom(x,id) % (m+1);
  g = g | ((1ULL << nB) - 1);
  
  int nA = geom(x,id) % (m+1);
  int core = geom(c,id);
  for(int i = 0; i < core; ++i) {
    int ya = (geom(x,id) % (m)) + 1;
    int yb = (geom(x,id) % (m)) + 1;
    g = g << (ya + yb);
    g = g | ((1ULL << yb) -1);
  }
  
  //  printf("%i , %i \n", nB,nA);
  g = g << nA;
  return g;
}
  
__device__  MBOARD genMBOARD(float x, int m, int id) {
  return {.board = {genWord(x,m,id),genWord(x,m,id),genWord(x,m,id),genWord(x,m,id)}};
}

__host__ int geomH(float x) {
  int i = 0;
  x = x * 100;
  int r = x+1;
  while(r > x) {
    r = rand() % 100;
    ++i;
  }
  return i;
}
__host__  MBOARD genWordH(float x, int m) {
  //B = 1, A = 0
  float c = (pow(x,2)*((1-pow(x,m))*(1-pow(x,m))))/(pow(1-x,2));
  MBOARD g = {0ULL};
  int nB = geomH(x) % (m+1);
  g.board[0] = g.board[0] | ((1ULL << nB) - 1);
  
  
  int nA = geomH(x) % (256*m+1);
  int core = geomH(c);
  for(int i = 0; i < core; ++i) {
    int ya = (geomH(x) % (256*m)) + 1;
    int yb = (geomH(x) % (m)) + 1;
    g.board[((i+nB)/64) % 4] = g.board[((i+nB)/64) % 4] << (ya + yb);
    g.board[((i+nB)/64) % 4] = g.board[((i+nB)/64) % 4] | ((1ULL << yb) -1);
  }
  
  //  printf("%i , %i \n", nB,nA);
  g.board[3] = g.board[3] & ~((1 << nA) -1);
  
  return g;
}

__host__  MBOARD genMBOARDH(float x, int m) {
  //return {.board = {genWordH(x,m),genWordH(x,m),genWordH(x,m),genWordH(x,m)}};
  return genWordH(x,m);
}
/*int main(){
  srand(time(0));
  genWord(.5,4);
}
*/
