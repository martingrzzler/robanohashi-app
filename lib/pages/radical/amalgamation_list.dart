import 'package:flutter/material.dart';
import 'package:robanohashi/api/subject_preview.dart';
import 'package:robanohashi/pages/kanji/kanji.dart';

import '../../common/colors.dart';
import '../../common/subject_card.dart';

class AmalgamationGrid extends StatelessWidget {
  const AmalgamationGrid({
    super.key,
    required this.amalgamation,
    required this.color,
  });

  final List<SubjectPreview> amalgamation;
  final Color color;

  Widget _buildVocabulary(SubjectPreview subject, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SubjectCard(
        color: color,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(subject.characters,
              style: const TextStyle(color: Colors.white, fontSize: 40)),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            subject.meanings.first,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            subject.readings!.first,
            style: const TextStyle(color: Colors.white),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      children: amalgamation
          .map((e) => _buildVocabulary(e, () {
                Navigator.pushNamed(context, '/kanji',
                    arguments: KanjiViewArgs(id: e.id));
              }))
          .toList(),
    );
  }
}
