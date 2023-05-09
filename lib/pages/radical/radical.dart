import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/radical.dart';
import 'package:robanohashi/common/bookmark.dart';
import 'package:robanohashi/common/future_wrapper.dart';
import 'package:robanohashi/common/kanji_grid.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/common/mnemonic/tagged_mnemonic.dart';

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
    return FutureWrapper(
      future: radical,
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
                      SubjectCard(
                        color: getSubjectBackgroundColor("radical"),
                        child: data.characters != ""
                            ? SelectableText(
                                data.characters,
                                style: const TextStyle(
                                  color: Colors.white,
                                  height: 1.2,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.meanings
                                    .firstWhere((element) => element.primary)
                                    .meaning,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SubjectBookmark(
                                  subjectId: data.id, object: 'radical')
                            ],
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
                      )),
                    ],
                  ),
                  const Divider(),
                  TaggedMnemonic(
                      mnemonic: data.meaningMnemonic,
                      tags: const {Tag.ja, Tag.radical}),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: KanjiGrid(
                      kanjis: data.amalgamationSubjects,
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
