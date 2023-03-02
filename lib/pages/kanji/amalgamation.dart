import 'package:flutter/material.dart';
import 'package:robanohashi/api/subject_preview.dart';
import 'package:robanohashi/pages/vocabulary/vocabulary.dart';

import '../../common/colors.dart';
import '../../common/subject_card.dart';

class AmalgamationList extends StatelessWidget {
  const AmalgamationList({
    super.key,
    required this.vocabs,
  });

  final List<SubjectPreview> vocabs;

  Widget _buildVocabulary(BuildContext context, SubjectPreview vocabulary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, VocabularyView.routeName,
              arguments: VocabularyViewArgs(id: vocabulary.id));
        },
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: vocabs.length,
      itemBuilder: (context, index) => _buildVocabulary(context, vocabs[index]),
    );
  }
}
