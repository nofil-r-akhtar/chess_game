import 'package:chess_game/play_area/chess_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Ensure that the Flutter bindings are initialized before modifying the UI
  WidgetsFlutterBinding.ensureInitialized();

  // Remove the status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChessBoard(),
    );
  }
}
