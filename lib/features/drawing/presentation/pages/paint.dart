import 'package:flutter/material.dart';

class PaintScreen extends StatelessWidget {
  const PaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Paint & Draw Screen", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}