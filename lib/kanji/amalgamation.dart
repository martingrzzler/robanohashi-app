import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../common/subject_card.dart';
import '../search/api.dart';

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
