import 'package:flutter/material.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/vocabulary.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/common/composition.dart';
import 'package:robanohashi/common/tagged_mnemonic.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roba no hashi'),
      ),
      body: FutureBuilder(
        future: vocabulary,
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

          final data = snapshot.data as Vocabulary;

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
                        Column(
                          children: [
                            SubjectCard(
                              color: getSubjectBackgroundColor("vocabulary"),
                              child: Text(data.characters,
                                  style: const TextStyle(
                                    fontSize: 45,
                                    color: Colors.white,
                                  )),
                            ),
                            Text(
                              data.readings
                                  .firstWhere((element) => element.primary)
                                  .reading,
                              style: TextStyle(
                                fontSize: 20,
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
                            ]))
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
                          Tab(text: 'Meaning'),
                          Tab(text: 'Reading'),
                          Tab(text: 'Examples'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                        child: TabBarView(children: [
                      Placeholder(),
                      TaggedMnemonic(
                          mnemonic: data.readingMnemonic,
                          tags: const {Tag.kanji, Tag.ja, Tag.reading}),
                      Examples(examples: data.contextSentences),
                    ]))
                  ]),
            ),
          );
        },
      ),
    );
  }
}

class Examples extends StatelessWidget {
  const Examples({
    super.key,
    required this.examples,
  });

  final List<ContextSentence> examples;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: examples.length,
        itemBuilder: (context, index) {
          final example = examples[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(example.ja,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  )),
              const SizedBox(height: 5),
              Text(example.hiragana,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 5),
              Text(example.en,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 5),
              const Divider(),
            ],
          );
        });
  }
}
