import 'package:flutter/material.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/vocabulary.dart';
import 'package:robanohashi/common/bookmark.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/future_wrapper.dart';
import 'package:robanohashi/common/mnemonic/subjects_mnemonics.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/common/composition.dart';

import 'examples.dart';

class VocabularyViewArgs {
  const VocabularyViewArgs({required this.id});

  final int id;
}

class VocabularyView extends StatefulWidget {
  const VocabularyView({super.key, required this.id});

  final int id;
  static const String routeName = '/vocabulary';

  @override
  State<VocabularyView> createState() => _VocabularyViewState();
}

class _VocabularyViewState extends State<VocabularyView> {
  late Future<Vocabulary> vocabulary;

  @override
  void initState() {
    super.initState();

    vocabulary = Api.fetchVocabulary(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: vocabulary,
      onData: (context, data) {
        return DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SubjectCard(
                            color: getSubjectBackgroundColor("vocabulary"),
                            child: SelectableText(data.characters,
                                style: const TextStyle(
                                  fontSize: 45,
                                  height: 1.2,
                                  color: Colors.white,
                                )),
                          ),
                          SelectableText(
                            data.readings
                                .firstWhere((element) => element.primary)
                                .reading,
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.2,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              data.meanings
                                  .firstWhere((element) => element.primary)
                                  .meaning,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                data.meanings
                                    .where((element) => !element.primary)
                                    .map((e) => e.meaning)
                                    .join(", "),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700])),
                          ])),
                      SubjectBookmark(subjectId: data.id, object: 'vocabulary'),
                    ],
                  ),
                  const Divider(),
                  Composition(
                      components: data.componentSubjects,
                      object: ComponentType.kanji),
                  const SizedBox(height: 10),
                  const SizedBox(
                    height: 50,
                    child: TabBar(
                      tabs: [
                        Tab(text: 'Mnemonics'),
                        Tab(text: 'Examples'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    MnemonicsListBySubject(
                      subject: data,
                    ),
                    Examples(examples: data.contextSentences),
                  ]))
                ]),
          ),
        );
      },
    );
  }
}
