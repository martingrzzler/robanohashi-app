import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:robanohashi/radical/radical.dart';

import '../api/subject_preview.dart';
import '../common/colors.dart';
import '../common/subject_card.dart';

class RadicalComposition extends StatelessWidget {
  const RadicalComposition({
    super.key,
    required this.radicals,
  });

  final List<SubjectPreview> radicals;

  Widget _buildRadical(BuildContext context, SubjectPreview radical) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/radical',
                arguments: RadicalViewArgs(id: radical.id));
          },
          child: SubjectCard(
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
                        si: ScalableImage.fromSvgString(
                            radical.characterImage)),
                  ),
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
                ? _buildRadical(context, radicals[index ~/ 2])
                : Text('+',
                    style: TextStyle(fontSize: 25, color: Colors.grey[700]));
          }),
        ));
  }
}
