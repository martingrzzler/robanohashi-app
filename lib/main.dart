import 'package:flutter/material.dart';
import 'kanji.dart';
import 'dart:convert';
import 'package:jovial_svg/jovial_svg.dart';

import 'search/search_delegate.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Roba no hashi",
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: DictionarySearchDelegate());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: const Kanji(),
    );
  }
}
