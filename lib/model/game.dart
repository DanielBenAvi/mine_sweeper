import 'dart:math';
import 'package:flutter/material.dart';

class GameManager {
  // board size
  int rows;
  int cols;

  // number of mines
  int mines;

  // game board
  List<List<Cell>> board;

  // game state
  bool isGameOver;
  bool isGameWon;

  // constructor
  GameManager(this.rows, this.cols, this.mines)
      : board = [],
        isGameOver = false,
        isGameWon = false;

  void generateMines() {
    board.clear();
    // clear the board with empty cells
    for (var i = 0; i < rows; i++) {
      board.add([]);
      for (var j = 0; j < cols; j++) {
        board[i].add(Cell(row: i, col: j, value: 0));
      }
    }

    // generate mines
    for (var i = 0; i < mines; i++) {
      var row = 0;
      var col = 0;
      do {
        row = Random().nextInt(rows); // generate random row
        col = Random().nextInt(cols); // generate random column
      } while (board[row][col].value == -1); // check if cell is already a mine
      board[row][col].value = -1; // assign mine to cell
    }

    // assign values to cells
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (board[i][j].value == -1) {
          // if cell is a mine, increment the value of its neighbors
          for (var x = -1; x <= 1; x++) {
            for (var y = -1; y <= 1; y++) {
              if (i + x >= 0 &&
                  i + x < rows &&
                  j + y >= 0 &&
                  j + y < cols &&
                  board[i + x][j + y].value != -1) {
                board[i + x][j + y].value++;
              }
            }
          }
        }
      }
    }
  }

  void reveal(int i, int j) {
    if (board[i][j].isRevealed || board[i][j].isFlagged) {
      return;
    }

    if (board[i][j].value == -1) {
      // reveal all mines
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < cols; j++) {
          if (board[i][j].value == -1) {
            board[i][j].isRevealed = true;
          }
        }
      }
      debugPrint('Game Over');
      isGameOver = true;
      return;
    }

    board[i][j].isRevealed = true;

    if (board[i][j].value != 0) {
      return;
    }

    for (var x = -1; x <= 1; x++) {
      for (var y = -1; y <= 1; y++) {
        if (i + x >= 0 &&
            i + x < rows &&
            j + y >= 0 &&
            j + y < cols &&
            !board[i + x][j + y].isRevealed) {
          reveal(i + x, j + y);
        }
      }
    }
    checkGameWon();
  }

  void checkGameWon() {
    var revealedCount = 0;
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        if (board[i][j].isRevealed) {
          revealedCount++;
        }
      }
    }
    if (revealedCount == rows * cols - mines) {
      debugPrint('Game Won');
      isGameWon = true;
    }
  }
}

class Cell {
  final int row;
  final int col;
  int value;
  bool isRevealed;
  bool isFlagged;

  Cell({
    required this.row,
    required this.col,
    required this.value,
    this.isRevealed = false,
    this.isFlagged = false,
  });

  String valueToString() {
    if (isFlagged) {
      return 'F';
    } else if (!isRevealed) {
      return '';
    } else if (value == -1) {
      return 'B';
    } else if (value == 0) {
      return '';
    } else {
      return value.toString();
    }
  }
}
