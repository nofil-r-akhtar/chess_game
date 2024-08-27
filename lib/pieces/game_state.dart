

import 'package:chess_game/pieces/game_init.dart';

class ChessBoardState {
  List<List<ChessPiece?>> board;

  ChessBoardState()
      : board = List.generate(8, (row) => List.generate(8, (col) => null)) {
    _initializeBoard();
  }

  void _initializeBoard() {
    // Setup pieces on the board
    for (int i = 0; i < 8; i++) {
      board[1][i] = ChessPiece(PieceType.pawn, PieceColor.black);
      board[6][i] = ChessPiece(PieceType.pawn, PieceColor.white);
    }
    board[0][0] = board[0][7] = ChessPiece(PieceType.rook, PieceColor.black);
    board[0][1] = board[0][6] = ChessPiece(PieceType.knight, PieceColor.black);
    board[0][2] = board[0][5] = ChessPiece(PieceType.bishop, PieceColor.black);
    board[0][3] = ChessPiece(PieceType.queen, PieceColor.black);
    board[0][4] = ChessPiece(PieceType.king, PieceColor.black);

    board[7][0] = board[7][7] = ChessPiece(PieceType.rook, PieceColor.white);
    board[7][1] = board[7][6] = ChessPiece(PieceType.knight, PieceColor.white);
    board[7][2] = board[7][5] = ChessPiece(PieceType.bishop, PieceColor.white);
    board[7][3] = ChessPiece(PieceType.queen, PieceColor.white);
    board[7][4] = ChessPiece(PieceType.king, PieceColor.white);
  }

  ChessPiece? pieceAt(int row, int col) {
    return board[row][col];
  } 

  void movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    board[toRow][toCol] = board[fromRow][fromCol];
    board[fromRow][fromCol] = null;
  }

  bool isMoveLegal(int fromRow, int fromCol, int toRow, int toCol) {
    ChessPiece? piece = pieceAt(fromRow, fromCol);
    if (piece == null) return false; // No piece to move

    switch (piece.type) {
      case PieceType.pawn:
        return _isPawnMoveLegal(piece.color, fromRow, fromCol, toRow, toCol);
      case PieceType.knight:
        return _isKnightMoveLegal(fromRow, fromCol, toRow, toCol);
      case PieceType.bishop:
        return _isBishopMoveLegal(fromRow, fromCol, toRow, toCol);
      case PieceType.rook:
        return _isRookMoveLegal(fromRow, fromCol, toRow, toCol);
      case PieceType.queen:
        return _isQueenMoveLegal(fromRow, fromCol, toRow, toCol);
      case PieceType.king:
        return _isKingMoveLegal(fromRow, fromCol, toRow, toCol);
    }
  }

  bool _isPawnMoveLegal(PieceColor color, int fromRow, int fromCol, int toRow, int toCol) {
    int direction = (color == PieceColor.white) ? -1 : 1;
    int startRow = (color == PieceColor.white) ? 6 : 1;

    if (fromCol == toCol) {
      // Moving forward
      if (toRow == fromRow + direction) {
        return pieceAt(toRow, toCol) == null; // Single step forward
      } else if (fromRow == startRow && toRow == fromRow + 2 * direction) {
        return pieceAt(toRow, toCol) == null && pieceAt(fromRow + direction, fromCol) == null; // Double step forward
      }
    } else if ((fromCol - toCol).abs() == 1 && toRow == fromRow + direction) {
      // Capture
      return pieceAt(toRow, toCol) != null && pieceAt(toRow, toCol)!.color != color;
    }
    return false;
  }

  bool _isKnightMoveLegal(int fromRow, int fromCol, int toRow, int toCol) {
    int dRow = (fromRow - toRow).abs();
    int dCol = (fromCol - toCol).abs();
    return (dRow == 2 && dCol == 1) || (dRow == 1 && dCol == 2);
  }

  bool _isBishopMoveLegal(int fromRow, int fromCol, int toRow, int toCol) {
    return (fromRow - toRow).abs() == (fromCol - toCol).abs() && _isPathClear(fromRow, fromCol, toRow, toCol);
  }

  bool _isRookMoveLegal(int fromRow, int fromCol, int toRow, int toCol) {
    return (fromRow == toRow || fromCol == toCol) && _isPathClear(fromRow, fromCol, toRow, toCol);
  }

  bool _isQueenMoveLegal(int fromRow, int fromCol, int toRow, int toCol) {
    return _isBishopMoveLegal(fromRow, fromCol, toRow, toCol) || _isRookMoveLegal(fromRow, fromCol, toRow, toCol);
  }

  bool _isKingMoveLegal(int fromRow, int fromCol, int toRow, int toCol) {
    return (fromRow - toRow).abs() <= 1 && (fromCol - toCol).abs() <= 1;
  }

  bool _isPathClear(int fromRow, int fromCol, int toRow, int toCol) {
    int dRow = toRow - fromRow;
    int dCol = toCol - fromCol;

    int stepRow = dRow == 0 ? 0 : dRow ~/ dRow.abs();
    int stepCol = dCol == 0 ? 0 : dCol ~/ dCol.abs();

    int row = fromRow + stepRow;
    int col = fromCol + stepCol;

    while (row != toRow || col != toCol) {
      if (pieceAt(row, col) != null) return false;
      row += stepRow;
      col += stepCol;
    }
    return true;
  }

  PieceColor currentTurn = PieceColor.white;

  bool makeMove(int fromRow, int fromCol, int toRow, int toCol) {
    if (!isMoveLegal(fromRow, fromCol, toRow, toCol)) return false;

    movePiece(fromRow, fromCol, toRow, toCol);
    currentTurn = (currentTurn == PieceColor.white) ? PieceColor.black : PieceColor.white;
    return true;
  }

  bool isKingInCheck(PieceColor color) {
  // Find the king's position
  int kingRow = -1, kingCol = -1;
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      ChessPiece? piece = pieceAt(row, col);
      if (piece != null && piece.type == PieceType.king && piece.color == color) {
        kingRow = row;
        kingCol = col;
        break;
      }
    }
    if (kingRow != -1) break;
  }

  // Check if any opponent's piece can attack the king
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      ChessPiece? piece = pieceAt(row, col);
      if (piece != null && piece.color != color) {
        if (isMoveLegal(row, col, kingRow, kingCol)) {
          return true;
        }
      }
    }
  }

  return false;
}
}