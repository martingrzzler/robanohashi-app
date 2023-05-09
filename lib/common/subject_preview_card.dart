import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:robanohashi/api/subject_preview.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/pages/kanji/kanji.dart';
import 'package:robanohashi/pages/radical/radical.dart';
import 'package:robanohashi/pages/vocabulary/vocabulary.dart';

class SubjectPreviewCard extends StatelessWidget {
  const SubjectPreviewCard({super.key, required this.subject});

  final SubjectPreview subject;

  _navigate(BuildContext context) {
    switch (subject.object) {
      case 'radical':
        Navigator.pushNamed(context, '/radical',
            arguments: RadicalViewArgs(id: subject.id));
        break;
      case 'kanji':
        Navigator.pushNamed(context, '/kanji',
            arguments: KanjiViewArgs(id: subject.id));
        break;
      case 'vocabulary':
        Navigator.pushNamed(context, '/vocabulary',
            arguments: VocabularyViewArgs(id: subject.id));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        _navigate(context);
      },
      child: ListTile(
        trailing: const Icon(Icons.chevron_right),
        leading: SubjectCard(
          color: getSubjectBackgroundColor(subject.object),
          child: subject.characters == ""
              ? SizedBox(
                  width: 25,
                  height: 25,
                  child: ScalableImageWidget(
                    si: ScalableImage.fromSvgString(
                      subject.characterImage,
                    ),
                  ),
                )
              : Text(subject.characters,
                  style: const TextStyle(fontSize: 25, color: Colors.white)),
        ),
        title: Text(subject.readings?.join(", ") ?? "",
            overflow: TextOverflow.ellipsis),
        subtitle: Text(
          subject.meanings.join(", "),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
