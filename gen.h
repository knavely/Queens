#include <stdio.h>
#include <wchar.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>



typedef unsigned long long BOARD;

BOARD genWord64(float x, int m);
BOARD genWordT8(float x, int m);
BOARD LShift(BOARD B,int k);
