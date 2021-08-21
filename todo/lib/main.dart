import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(ReorderableTodo());

class ReorderableTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reorderable Todo',
      home: Home(),
    );
  }
}
