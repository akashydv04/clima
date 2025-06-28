import 'package:clima/screens/screen1.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Climate());
}

class Climate extends StatelessWidget {
  const Climate({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screen1(),
    );
  }
}
