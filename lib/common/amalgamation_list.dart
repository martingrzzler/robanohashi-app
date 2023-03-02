import 'package:flutter/material.dart';
import 'package:robanohashi/api/subject_preview.dart';

import '../common/colors.dart';
import '../common/subject_card.dart';

class AmalgamationList extends StatelessWidget {
  const AmalgamationList({
    super.key,
    required this.amalgamation,
    required this.color,
  });

  final List<SubjectPreview> amalgamation;
  final Color color;

  Widget _buildVocabulary(SubjectPreview subject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: SubjectCard(
        color: color,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(subject.characters,
              style: const TextStyle(color: Colors.white, fontSize: 20)),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              subject.meanings.first,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              subject.readings!.first,
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
      children: amalgamation.map((e) => _buildVocabulary(e)).toList(),
    );
  }
}
