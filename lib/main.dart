import 'package:flutter/material.dart';
import 'package:robanohashi/kanji/kanji.dart';

import 'search/search_delegate.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        // '/kanji': (context) => const KanjiView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == KanjiView.routeName) {
          final args = settings.arguments as KanjiViewArgs;
          return MaterialPageRoute(
            builder: (context) => KanjiView(id: args.id),
          );
        }
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: const Placeholder(),
    );
  }
}
