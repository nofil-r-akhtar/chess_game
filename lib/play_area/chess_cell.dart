
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ChessCell extends StatelessWidget {
  final Color cellColor;
  Widget? piece;
  ChessCell({super.key, required this.cellColor, this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0,
      height: 35.0,
      color: cellColor,
      child: Center(
        child: piece,
      )
    );
  }
}