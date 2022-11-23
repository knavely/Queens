#include <stdio.h>
#include <wchar.h>
#include <stdint.h>
#include <stdlib.h>
//#include <math.h>
#include <time.h>
#include "cuda_runtime.h"
#include "queens.h"


typedef unsigned long long BOARD;
__device__  int geom(float x, int id);
__device__  BOARD genWord(float x, int m, int id);

__device__  MBOARD genMBOARD(float x, int m, int id);
__device__ MBOARD genWordNV(float x, int m, int id);
__host__  int geomH(float x);
__host__  MBOARD genWordH(float x, int m);

__host__  MBOARD genMBOARDH(float x, int m);

