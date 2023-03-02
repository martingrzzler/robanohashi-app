import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:robanohashi/app_bar.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/composition.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/common/tagged_mnemonic.dart';
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
    return Scaffold(
      appBar: const CustomAppBar(),
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

          final data = snapshot.data as Kanji;

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
                            child: Text(data.characters,
                                style: const TextStyle(
                                    fontSize: 60, color: Colors.white))),
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
                          text: 'Meaning',
                        ),
                        Tab(
                          text: 'Reading',
                        ),
                        Tab(
                          text: 'Vocabulary',
                        )
                      ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: TabBarView(children: [
                      MeaningMnemonics(),
                      TaggedMnemonic(
                        mnemonic: data.readingMnemonic,
                        tags: const {Tag.ja, Tag.kanji, Tag.reading},
                      ),
                      AmalgamationList(vocabs: data.amalgamationSubjects)
                    ]))
                  ]),
            ),
          );
        },
      ),
    );
  }
}

class MeaningMnemonics extends StatefulWidget {
  MeaningMnemonics({
    super.key,
  });

  static const String mnemonic =
      'The meaning of this kanji is "to write". It is made up of the radical "to write" (曰) and the kanji "to write" (文). And it is pronounced "bun". And so, the meaning of this kanji is "to write". very cool kanji. I like it. generate a lot of text to test the layout. I hope this will never happen in real life. LOL generate more t';

  @override
  State<MeaningMnemonics> createState() => _MeaningMnemonicsState();
}

class _MeaningMnemonicsState extends State<MeaningMnemonics> {
  bool _showForm = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      return Form(
        key: _formKey,
        child: Stack(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 40.0, top: 25),
                  child: TextFormField(
                    maxLines: 50,
                    autofocus: true,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                        hintText: 'The more absurd the better...'),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.send))),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                    onPressed: () => setState(() {
                          _showForm = false;
                        }),
                    icon: const Icon(Icons.close)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _showForm = true;
                });
              },
              label: const Text('Add a mnemonic'),
            );
          }
          return Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.star_border)),
                  Row(children: [
                    Transform.rotate(
                      angle: pi / 2,
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chevron_left,
                        ),
                      ),
                    ),
                    const Text('16'),
                    Transform.rotate(
                        angle: -pi / 2,
                        child: IconButton(
                            iconSize: 30,
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_left)))
                  ]),
                  Expanded(
                    child: Container(),
                  ),
                  const Text(
                    'username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(timeago.format(
                      DateTime.now().subtract(const Duration(days: 700)))),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: Text(
                      MeaningMnemonics.mnemonic,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const Divider()
            ],
          );
        });
  }
}
