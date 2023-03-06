import 'common.dart';
import 'subject_preview.dart';

class Kanji implements Subject {
  @override
  final int id;
  @override
  final String object;
  final String characters;
  final String slug;
  final String readingMnemonic;
  final List<KanjiReading> readings;
  final List<Meaning> meanings;
  final List<SubjectPreview> amalgamationSubjects;
  final List<SubjectPreview> componentSubjects;
  final List<SubjectPreview> visualSimilarSubjects;

  Kanji(
      {required this.id,
      required this.object,
      required this.characters,
      required this.slug,
      required this.readingMnemonic,
      required this.meanings,
      required this.componentSubjects,
      required this.amalgamationSubjects,
      required this.visualSimilarSubjects,
      required this.readings});

  factory Kanji.fromJson(Map<String, dynamic> json) {
    return Kanji(
        id: json['id'],
        object: json['object'],
        characters: json['characters'],
        slug: json['slug'],
        readingMnemonic: json['reading_mnemonic'],
        visualSimilarSubjects: List<SubjectPreview>.from(
            json['visually_similar_subjects']
                .map((e) => SubjectPreview.fromJson(e))),
        componentSubjects: List<SubjectPreview>.from(
            json['component_subjects'].map((e) => SubjectPreview.fromJson(e))),
        amalgamationSubjects: List<SubjectPreview>.from(
            json['amalgamation_subjects']
                .map((e) => SubjectPreview.fromJson(e))),
        meanings: List<Meaning>.from(
            json['meanings'].map((e) => Meaning.fromJson(e))),
        readings: List<KanjiReading>.from(
            json['readings'].map((e) => KanjiReading.fromJson(e)).toList()));
  }
}

class KanjiReading {
  final String reading;
  final String type;
  final bool primary;

  KanjiReading({
    required this.reading,
    required this.type,
    required this.primary,
  });

  factory KanjiReading.fromJson(Map<String, dynamic> json) {
    return KanjiReading(
      reading: json['reading'],
      type: json['type'],
      primary: json['primary'],
    );
  }
}
