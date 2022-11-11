#define N 4
#define R 64 / N
#define M R * R

typedef unsigned long long  BOARD;

typedef struct MBOARD {
  BOARD board[N] = {0};
} MBOARD;
