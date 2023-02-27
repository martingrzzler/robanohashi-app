import 'package:flutter/material.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/kanji/api.dart';

class KanjiViewArgs {
  KanjiViewArgs({required this.id});

  final int id;
}

class KanjiView extends StatefulWidget {
  const KanjiView({super.key, required this.id});

  final int id;

  static const routeName = '/kanji';

  @override
  State<KanjiView> createState() => _KanjiViewState();
}

class _KanjiViewState extends State<KanjiView> {
  late Future<Kanji> kanji;

  @override
  void initState() {
    super.initState();

    kanji = fetchKanji(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roba no hashi'),
      ),
      body: FutureBuilder(
        future: kanji,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error),
                SizedBox(width: 10),
                Text('Oops, something went wrong!'),
              ],
            ));
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubjectCard(
                      color: getSubjectBackgroundColor("kanji"),
                      child: Text(snapshot.data!.characters,
                          style: const TextStyle(
                              fontSize: 50, color: Colors.white))),
                ],
              ),
            ]),
          );
        },
      ),
    );
  }
}
