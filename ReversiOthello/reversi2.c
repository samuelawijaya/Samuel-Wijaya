

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

// n is input for the size (even number <=26)
void startBoard(int n, char board[][26]) {
  int row, column;

  for (row = 0; row < n; row++) {
    for (column = 0; column < n; column++) {
      board[row][column] = 'U';
      board[n / 2 - 1][n / 2 - 1] = 'W';
      board[n / 2][n / 2 - 1] = 'B';
      board[n / 2 - 1][n / 2] = 'B';
      board[n / 2][n / 2] = 'W';
    }
  }
}

void printBoard(char board[][26], int n) {
  int i, j;

  printf("  ");  // prints the empty gap

  for (int x = 0; x < n; x++) {
    printf("%c", 'a' + x);
  }

  printf("\n");

  for (int i = 0; i < n; i++) {
    printf("%c ", 'a' + i);
    for (j = 0; j < n; j++) {
      printf("%c", board[i][j]);
    }
    printf("\n");
  }
}

bool positionInBounds(int n, int row, int column) {
  if (((row >= 0) && (row < n)) && ((column >= 0) && (column < n))) {
    return true;
  } else {
    return false;
  }
}

bool checkLegalInDirection(char board[][26], int n, int row, int col,
                           char colour, int deltaRow, int deltaCol) {
  int i = 1;
  char opponentColor;

  if (colour == 'W') {
    opponentColor = 'B';
  } else {
    opponentColor = 'W';
  }

  while ((positionInBounds(n, row + (deltaRow * i), col + (deltaCol * i))) &&
         ((board[row + (deltaRow * i)][col + (deltaCol * i)]) != (colour)) &&
         ((board[row + (deltaRow * i)][col + (deltaCol * i)]) != ('U'))) {
    i++;
    if (((positionInBounds(n, row + (deltaRow * i), col + (deltaCol * i))) ==
         true) &&
        (board[row + (deltaRow * i)][col + (deltaCol * i)] == colour)) {
      return true;
    }

    else {
      if (((positionInBounds(n, row + (deltaRow * i), col + (deltaCol * i))) ==
           true) &&
          (board[row + (deltaRow * i)][col + (deltaCol * i)] ==
           opponentColor)) {
        continue;
      }

      else {
        if ((positionInBounds(n, row + (deltaRow * i), col + (deltaCol * i)) ==
             false)) {
          return false;
        }

        else if (board[row + (deltaRow * i)][col + (deltaCol * i)] == colour) {
          return true;
        }

        else {
          return false;
        }
      }
    }
  }
  return false;
}

// function to find the possible moves
bool possibleMoves(char board[][26], int n, char color) {
  int row, col, deltaRow, deltaCol;
  bool match = false;

  for (row = 0; row <= n - 1; row++) {
    for (col = 0; col <= n - 1; col++) {
      bool match = false;
      if (board[row][col] == 'U') {
        for (deltaRow = -1; deltaRow <= 1; deltaRow++) {
          if (match == true) {
            match = false;
            break;
          }
          for (deltaCol = -1; deltaCol <= 1; deltaCol++) {
            if (deltaRow == 0 && deltaCol == 0) {
            }

            else {
              if (checkLegalInDirection(board, n, row, col, color, deltaRow,
                                        deltaCol)) {
                return true;
              }
            }
          }
        }
      }
    }
  }
  return false;
}

void changeColor(int n, char color, char board[][26], int row, int col,
                 int deltaRow, int deltaCol) {
  board[row][col] = color;
  int i = 1;
  while (board[row + (deltaRow * i)][col + (deltaCol * i)] != color) {
    board[row + (deltaRow * i)][col + (deltaCol * i)] = color;
    i++;
  }
}

bool gameOver(char board[][26], int n, bool* playerInvalid) {
  int row, col;
  if (*playerInvalid == true) {
    return true;
  }

  for (row = 0; row <= n - 1; row++) {
    for (col = 0; col <= n - 1; col++) {
      if (board[row][col] == 'U') {
        return false;
      }
    }
  }
  return true;
}

void checkInput(int n, char player, char board[][26], int row, int col,
                char comp, bool* playerInvalid) {
  int counter=0;
  if ((positionInBounds(n, row, col) == true) && (board[row][col] == 'U')) {
    for (int deltaRow = -1; deltaRow <= 1; deltaRow++) {
      for (int deltaCol = -1; deltaCol <= 1; deltaCol++) {
        if ((deltaRow != 0 || deltaCol != 0) &&
            (checkLegalInDirection(board, n, row, col, player, deltaRow,
                                   deltaCol)) == true) {
          changeColor(n, player, board, row, col, deltaRow, deltaCol);
          counter++;
        }
      }
    }
    if(counter>0){
    printBoard(board, n);
    return;
    }
  }
  printf("Invalid move.\n");
  printf("%c player wins.", comp);
  *playerInvalid = true;
  gameOver(board, n, playerInvalid);
  return;
}

int tilesFlipped(int n, int row, int col, char board[][26], char color,
                 int deltaRow, int deltaCol) {
  int gap = 1;
  int max = 0;
  while (positionInBounds(n, row + (deltaRow * gap), col + (deltaCol * gap)) &&
         board[row + (deltaRow * gap)][col + (deltaCol * gap)] != color) {
    gap++;
    max++;
  }
  return max;
}

void scoreboard(int n, char board[][26], char comp) {
  int deltaRow, deltaCol;
  int score = 0;
  int rowMax = 0;
  int colMax = 0;
  int scoremax = 0;

  int scoreboard[26][26];

  for (int row = 0; row < n; row++) {
    for (int col = 0; col < n; col++) {
      if ((positionInBounds(n, row, col)) && (board[row][col] == 'U')) {
        for (deltaRow = -1; deltaRow <= 1; deltaRow++) {
          for (deltaCol = -1; deltaCol <= 1; deltaCol++) {
            if ((deltaRow != 0 || deltaCol != 0) &&
                checkLegalInDirection(board, n, row, col, comp, deltaRow,
                                      deltaCol)) {
              score +=
                  tilesFlipped(n, row, col, board, comp, deltaRow, deltaCol);
            }
          }
        }
      }
      scoreboard[row][col] = score;
      score = 0;
    }
  }
  for (int row = 0; row < n; row++) {
    for (int col = 0; col < n; col++) {
      if (scoreboard[row][col] > scoremax) {
        scoremax = scoreboard[row][col];
        rowMax = row;
        colMax = col;
      }
    }
  }
  for (deltaRow = -1; deltaRow <= 1; deltaRow++) {
    for (deltaCol = -1; deltaCol <= 1; deltaCol++) {
      if (checkLegalInDirection(board, n, rowMax, colMax, comp, deltaRow,
                                deltaCol)) {
        changeColor(n, comp, board, rowMax, colMax, deltaRow, deltaCol);
      }
    }
  }
  printf("Computer places %c at %c%c. \n", comp, rowMax + 97, colMax + 97);
  printBoard(board, n);
}

void playerMoves(int n, char board[][26], char currentPlayer, char comp,
                 char player, bool* playerInvalid) {
  char row, col;

  if (possibleMoves(board, n, player)) {
    printf("Enter move for colour %c (RowCol):", player);
    scanf(" %c%c", &row, &col);
    checkInput(n, currentPlayer, board, row - 'a', col - 'a', comp,
               playerInvalid);
    return;
  } else {
    printf("%c player has no valid move. \n", player);
  }
  return;
}

void computerMoves(int n, char board[][26], char currentPlayer, char comp,
                   char player) {
  if (possibleMoves(board, n, comp)) {
    scoreboard(n, board, comp);
  } else {
    printf("%c player has no valid move.\n", comp);
  }
}

char moveTurn(int n, char board[][26], char currentPlayer, char comp,
              char player, bool* playerInvalid) {
  if (currentPlayer == player) {
    playerMoves(n, board, currentPlayer, comp, player, playerInvalid);
    currentPlayer = comp;
  } else if (currentPlayer == comp) {
    computerMoves(n, board, currentPlayer, comp, player);
    currentPlayer = player;
  }
  return currentPlayer;
}

int main(void) {
  int n, row, col;
  char board[26][26];
  char currentPlayer = 'B';
  char comp, player;
  bool playerInvalid = false;

  printf("Enter the board dimension: ");
  scanf("%d", &n);
  startBoard(n, board);

  printf("Computer plays (B/W): ");
  scanf(" %c", &comp);

  printBoard(board, n);

  if (comp == 'W') {
    player = 'B';
  } else {
    player = 'W';
  }

  while (gameOver(board, n, &playerInvalid) == false) {
    if (playerInvalid == false) {
      currentPlayer =
          moveTurn(n, board, currentPlayer, comp, player, &playerInvalid);
    }
  }
  if (playerInvalid == false) {
    int playerScore = 0;
    int compScore = 0;
    for (int row = 0; row <= n - 1; row++) {
      for (int col = 0; col <= n - 1; col++) {
        if (board[row][col] == comp) {
          compScore++;
        } else if (board[row][col] == player) {
          playerScore++;
        }
      }
    }
    if (compScore > playerScore) {
      printf("%c player wins. ", comp);
      return 0;
    } else if (playerScore > compScore) {
      printf("%c player wins. ", player);
      return 0;
    } else {
      printf("Draw!");
      return 0;
    }
  }
  return 0;
}
