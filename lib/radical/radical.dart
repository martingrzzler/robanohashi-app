import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/radical.dart';
import 'package:robanohashi/common/amalgamation_list.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/common/tagged_mnemonic.dart';

class RadicalViewArgs {
  RadicalViewArgs({required this.id});

  final int id;
}

class RadicalView extends StatefulWidget {
  const RadicalView({super.key, required this.id});

  final int id;
  static const routeName = '/radical';

  @override
  State<RadicalView> createState() => _RadicalViewState();
}

class _RadicalViewState extends State<RadicalView> {
  late Future<Radical> radical;

  @override
  void initState() {
    super.initState();

    radical = Api.fetchRadical(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roba no hashi'),
      ),
      body: FutureBuilder(
        future: radical,
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

          final data = snapshot.data as Radical;

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
                        SubjectCard(
                          color: getSubjectBackgroundColor("radical"),
                          child: data.characters != ""
                              ? Text(
                                  data.characters,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 60.0,
                                  ),
                                )
                              : SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ScalableImageWidget(
                                      si: ScalableImage.fromSvgString(
                                          data.characterImage)),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              data.meanings
                                  .firstWhere((element) => element.primary)
                                  .meaning,
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data.meanings
                                  .where((element) => !element.primary)
                                  .map((e) => e.meaning)
                                  .join(', '),
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: 50,
                      child: AppBar(
                        bottom:
                            const TabBar(indicatorColor: Colors.grey, tabs: [
                          Tab(
                            text: 'Meaning',
                          ),
                          Tab(
                            text: 'Kanji',
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          TaggedMnemonic(
                              mnemonic: data.meaningMnemonic,
                              tags: const {Tag.ja, Tag.radical}),
                          AmalgamationList(
                              amalgamation: data.amalgamationSubjects,
                              color: getSubjectBackgroundColor("kanji")),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}
