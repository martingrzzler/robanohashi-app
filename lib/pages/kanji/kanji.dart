import 'package:flutter/material.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/composition.dart';
import 'package:robanohashi/common/future_wrapper.dart';
import 'package:robanohashi/common/kanji_grid.dart';
import 'package:robanohashi/common/mnemonic/subjects_mnemonics.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/pages/kanji/amalgamation.dart';
import 'package:robanohashi/api/api.dart';

import '../../api/kanji.dart';
import 'readings.dart';

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

    kanji = Api.fetchKanji(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: kanji,
      onData: (context, data) {
        return DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubjectCard(
                          color: getSubjectBackgroundColor("kanji"),
                          child: SelectableText(data.characters,
                              style: const TextStyle(
                                  fontSize: 60,
                                  height: 1.2,
                                  color: Colors.white))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                data.meanings
                                    .firstWhere((element) => element.primary)
                                    .meaning,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 5),
                            Text(
                                data.meanings
                                    .where((element) => !element.primary)
                                    .map((e) => e.meaning)
                                    .join(', '),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[700])),
                            const SizedBox(height: 13),
                            KanjiReadings(readings: data.readings)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Composition(
                    components: data.componentSubjects,
                    object: ComponentType.radical,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 50,
                    child: TabBar(tabs: [
                      Tab(
                        text: 'Mnemonics',
                      ),
                      Tab(
                        text: 'Vocabulary',
                      ),
                      Tab(
                        text: 'Similar',
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    MnemonicsListBySubject(subject: data),
                    AmalgamationList(vocabs: data.amalgamationSubjects),
                    KanjiGrid(kanjis: data.visualSimilarSubjects)
                  ]))
                ]),
          ),
        );
      },
    );
  }
}
