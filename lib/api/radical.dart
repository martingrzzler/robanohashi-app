import 'package:robanohashi/api/common.dart';

import 'subject_preview.dart';

class Radical {
  final int id;
  final String object;
  final String slug;
  final String characters;
  final String characterImage;
  final List<SubjectPreview> amalgamationSubjects;
  final List<Meaning> meanings;
  final String meaningMnemonic;

  Radical({
    required this.id,
    required this.object,
    required this.slug,
    required this.characters,
    required this.characterImage,
    required this.amalgamationSubjects,
    required this.meanings,
    required this.meaningMnemonic,
  });

  factory Radical.fromJson(Map<String, dynamic> json) {
    return Radical(
      id: json['id'],
      object: json['object'],
      slug: json['slug'],
      characters: json['characters'],
      characterImage: json['character_image'],
      amalgamationSubjects: List<SubjectPreview>.from(
          json['amalgamation_subjects'].map((e) => SubjectPreview.fromJson(e))),
      meanings:
          List<Meaning>.from(json['meanings'].map((e) => Meaning.fromJson(e))),
      meaningMnemonic: json['meaning_mnemonic'],
    );
  }
}
