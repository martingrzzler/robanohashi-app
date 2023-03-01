import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/kanji/api.dart';
import 'package:robanohashi/search/api.dart';

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

          final data = snapshot.data as Kanji;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                        // 3. Primary reading
                        // 4. Other readings
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    RadicalComposition(
                      radicals: data.componentSubjects,
                    ),
                    const Divider(),
                    KanjiAmalgamation(
                      vocabs: data.amalgamationSubjects,
                    )
                  ]),
            ),
          );
        },
      ),
    );
  }
}

class KanjiAmalgamation extends StatelessWidget {
  const KanjiAmalgamation({
    super.key,
    required this.vocabs,
  });

  final List<SubjectPreview> vocabs;

  Widget _buildVocabulary(SubjectPreview vocabulary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: SubjectCard(
        color: getSubjectBackgroundColor('vocabulary'),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(vocabulary.characters,
              style: const TextStyle(color: Colors.white, fontSize: 20)),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              vocabulary.meanings.first,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              vocabulary.readings!.first,
              style: const TextStyle(color: Colors.white),
            ),
          ])
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: vocabs.map((e) => _buildVocabulary(e)).toList(),
    );
  }
}

class RadicalComposition extends StatelessWidget {
  const RadicalComposition({
    super.key,
    required this.radicals,
  });

  final List<SubjectPreview> radicals;

  Widget _buildRadical(SubjectPreview radical) {
    return Column(
      children: [
        SubjectCard(
          color: getSubjectBackgroundColor('radical'),
          child: radical.characters != ""
              ? Text(
                  radical.characters,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                )
              : SizedBox(
                  width: 30,
                  height: 30,
                  child: ScalableImageWidget(
                      si: ScalableImage.fromSvgString(radical.characterImage)),
                ),
        ),
        const SizedBox(height: 2),
        Text(
          radical.meanings.first,
          style: TextStyle(color: Colors.grey[600], fontSize: 15.0),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children:
              List.generate(radicals.length + radicals.length - 1, (index) {
            return (index % 2 == 0)
                ? _buildRadical(radicals[index ~/ 2])
                : Text('+',
                    style: TextStyle(fontSize: 25, color: Colors.grey[700]));
          }),
        ));
  }
}
