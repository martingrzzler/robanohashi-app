import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:robanohashi/pages/kanji/kanji.dart';
import 'package:robanohashi/pages/radical/radical.dart';

import '../api/subject_preview.dart';
import 'colors.dart';
import 'subject_card.dart';

enum ComponentType { radical, kanji }

class Composition extends StatelessWidget {
  const Composition({
    super.key,
    required this.components,
    required this.object,
  });

  final List<SubjectPreview> components;
  final ComponentType object;

  Widget _buildComponent(BuildContext context, SubjectPreview component) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context,
                  object == ComponentType.kanji ? '/kanji' : '/radical',
                  arguments: object == ComponentType.kanji
                      ? KanjiViewArgs(id: component.id)
                      : RadicalViewArgs(id: component.id));
            },
            child: SubjectCard(
              color: getSubjectBackgroundColor(
                  object == ComponentType.kanji ? 'kanji' : 'radical'),
              child: component.characters != ""
                  ? Text(
                      component.characters,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    )
                  : SizedBox(
                      width: 30,
                      height: 30,
                      child: ScalableImageWidget(
                          si: ScalableImage.fromSvgString(
                              component.characterImage)),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          component.meanings.first,
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
              List.generate(components.length + components.length - 1, (index) {
            return (index % 2 == 0)
                ? _buildComponent(context, components[index ~/ 2])
                : Text('+',
                    style: TextStyle(fontSize: 25, color: Colors.grey[700]));
          }),
        ));
  }
}
