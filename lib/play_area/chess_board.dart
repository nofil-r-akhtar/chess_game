import 'package:chess_game/play_area/chess_area.dart';
import 'package:flutter/material.dart';


class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      color: Color(0xFF354A21),
      
      child: Center(child: ChessArea()),

    );
  }
}