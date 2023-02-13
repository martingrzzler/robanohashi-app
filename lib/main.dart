import 'package:flutter/material.dart';
import 'kanji.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text('Roba no hashi')),
      body: Kanji(),
    ));
  }
}
