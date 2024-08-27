import 'package:chess_game/pieces/game_init.dart';
import 'package:chess_game/pieces/game_state.dart';
import 'package:flutter/material.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';



class ChessArea extends StatefulWidget {
  const ChessArea({Key? key}) : super(key: key);

  @override
  State<ChessArea> createState() => _ChessAreaState();
}

class _ChessAreaState extends State<ChessArea> {
  final ChessBoardState _boardState = ChessBoardState();
  int? _selectedRow;
  int? _selectedCol;

  void _onCellTap(int row, int col) {
    if (_selectedRow == null || _selectedCol == null) {
      // First tap, select a piece
      if (_boardState.pieceAt(row, col) != null && 
          _boardState.pieceAt(row, col)!.color == _boardState.currentTurn) {
        setState(() {
          _selectedRow = row;
          _selectedCol = col;
        });
      }
    } else {
      // Second tap, attempt to move the piece
      if (_boardState.makeMove(_selectedRow!, _selectedCol!, row, col)) {
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
        });
      } else {
        // Invalid move, deselect
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
        });
      }
    }
  }

  Widget _buildPieceWidget(ChessPiece? piece) {
    if (piece == null) return Container();
    switch (piece.type) {
      case PieceType.king:
        return piece.color == PieceColor.white ? WhiteKing() : BlackKing();
      case PieceType.queen:
        return piece.color == PieceColor.white ? WhiteQueen() : BlackQueen();
      case PieceType.rook:
        return piece.color == PieceColor.white ? WhiteRook() : BlackRook();
      case PieceType.bishop:
        return piece.color == PieceColor.white ? WhiteBishop() : BlackBishop();
      case PieceType.knight:
        return piece.color == PieceColor.white ? WhiteKnight() : BlackKnight();
      case PieceType.pawn:
        return piece.color == PieceColor.white ? WhitePawn() : BlackPawn();
    }
  }


   @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width;
    double cellSize = boardSize / 8;

    return Container(
      width: boardSize,
      height: boardSize,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // Number of columns
        ),
        itemCount: 64, // Total number of cells (8x8)
        itemBuilder: (BuildContext context, int index) {
          int row = index ~/ 8;
          int col = index % 8;

          // Determine the color of the cell
          final bool isWhite = (row % 2 == 0 && col % 2 == 0) ||
              (row % 2 != 0 && col % 2 != 0);

          // Highlight the selected cell
          final bool isSelected =
              row == _selectedRow && col == _selectedCol;

          return GestureDetector(
            onTap: () => _onCellTap(row, col),
            child: Container(
              width: cellSize,
              height: cellSize,
              color: isSelected
                  ? Colors.green
                  : isWhite
                      ? Colors.white
                      : Colors.brown,
              child: Center(
                child: _buildPieceWidget(_boardState.pieceAt(row, col)),
              ),
            ),
          );
        },
      ),
    );
  }
}
