

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "reversi.h"

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
void possibleMoves(char board[][26], int n, char colour){
    int row, col, deltaRow, deltaCol;
    bool match = false;
    
    printf("Available moves for %c:\n", colour);
    
    for (row = 0; row <= n-1; row++){
        for (col = 0; col <= n-1; col++){
          bool match = false;
            if (board[row][col] == 'U'){
                for (deltaRow = -1; deltaRow <= 1; deltaRow++){
                    if (match == true) { 
                        match = false; 
                        break;
                    }

                    for (deltaCol = -1; deltaCol <= 1; deltaCol++){
                        if (deltaRow == 0 && deltaCol == 0)
                        {
                        }
                        
                        else
                        {
                            if (checkLegalInDirection(board, n, row, col, colour, deltaRow, deltaCol)){
                                printf("%c%c\n", row + 'a', col + 'a');
                                match = true;
                                break;
                            }
                        }  
                    }
                }
            }
        }
    }
}

void changeColor(int n, char color, char board[][26], int row, int col,
                 int deltaRow, int deltaCol) {
  int i = 1;
  while (board[row + (deltaRow * i)][col + (deltaCol * i)] != color) {
    board[row + (deltaRow * i)][col + (deltaCol * i)] = color;
    i++;
  }
}

void checkInput(int n, char color, char board[][26], int row, int col) {
  int counter=0;
  if ((positionInBounds(n, row, col) == true) && (board[row][col] == 'U')) {
    for (int deltaRow = -1; deltaRow <= 1; deltaRow++) {
      for (int deltaCol = -1; deltaCol <= 1; deltaCol++) {
        if ((deltaRow != 0 || deltaCol != 0) &&
            (checkLegalInDirection(board, n, row, col, color, deltaRow, deltaCol)) ==true){
            board[row][col] = color;
            changeColor(n, color, board, row, col, deltaRow, deltaCol);
            counter++;
          }
      }
    }
    if(counter>0){
      printf("Valid move.\n");
      printBoard(board, n);
      return;
    }
    printf("Invalid move.\n");
    printBoard(board, n);
    return;
  }

  else {
    printf("Invalid move.\n");
    printBoard(board, n);
    return;
  }
}

int main(void) {
  int n;
  char board[26][26];

  printf("Enter the board dimension: ");
  scanf("%d", &n);
  startBoard(n, board);
  printBoard(board, n);

  char color, row, col;
  printf("Enter board configuration:\n");

  while (color != '!' || row != '!' || col != '!') {
    scanf(" %c%c%c", &color, &row, &col);
    board[row - 'a'][col - 'a'] = color;
  }

  printBoard(board, n);

  possibleMoves(board, n, 'W');

  possibleMoves(board, n, 'B');

  printf("Enter a move:\n");
  scanf(" %c%c%c", &color, &row, &col);

  checkInput(n, color, board, row - 'a', col - 'a');

  return 0;
}
