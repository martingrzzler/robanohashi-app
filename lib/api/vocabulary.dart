import 'package:robanohashi/api/common.dart';
import 'package:robanohashi/api/subject_preview.dart';

class Vocabulary implements Subject {
  @override
  final int id;
  @override
  final String object;
  final String slug;
  final String characters;
  @override
  final List<Meaning> meanings;
  final String readingMnemonic;
  final List<VocabularyReading> readings;
  @override
  final List<SubjectPreview> componentSubjects;
  final List<ContextSentence> contextSentences;

  Vocabulary(
      {required this.id,
      required this.object,
      required this.slug,
      required this.contextSentences,
      required this.characters,
      required this.meanings,
      required this.readings,
      required this.componentSubjects,
      required this.readingMnemonic});

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
        id: json['id'],
        object: json['object'],
        slug: json['slug'],
        characters: json['characters'],
        componentSubjects: List<SubjectPreview>.from(
            json['component_subjects'].map((e) => SubjectPreview.fromJson(e))),
        readings: List<VocabularyReading>.from(json['readings']
            .map((e) => VocabularyReading.fromJson(e))
            .toList()),
        meanings: List<Meaning>.from(
            json['meanings'].map((e) => Meaning.fromJson(e))),
        contextSentences: List<ContextSentence>.from(
            json['context_sentences'].map((e) => ContextSentence.fromJson(e))),
        readingMnemonic: json['reading_mnemonic']);
  }
}

class ContextSentence {
  final String en;
  final String ja;
  final String hiragana;

  ContextSentence({
    required this.en,
    required this.ja,
    required this.hiragana,
  });

  factory ContextSentence.fromJson(Map<String, dynamic> json) {
    return ContextSentence(
        en: json['en'], ja: json['ja'], hiragana: json['hiragana']);
  }
}

class VocabularyReading {
  final String reading;
  final String romaji;
  final bool primary;

  VocabularyReading({
    required this.reading,
    required this.romaji,
    required this.primary,
  });

  factory VocabularyReading.fromJson(Map<String, dynamic> json) {
    return VocabularyReading(
        reading: json['reading'],
        romaji: json['romaji'],
        primary: json['primary']);
  }
}
