import 'package:http/http.dart' as http;
import 'package:robanohashi/search/api.dart';
import 'dart:convert';

class Kanji {
  final int id;
  final String object;
  final String characters;
  final String slug;
  final String readingMnemonic;
  final List<KanjiReading> readings;
  final List<KanjiMeaning> meanings;
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
        meanings: List<KanjiMeaning>.from(
            json['meanings'].map((e) => KanjiMeaning.fromJson(e))),
        readings: List<KanjiReading>.from(
            json['readings'].map((e) => KanjiReading.fromJson(e)).toList()));
  }
}

class KanjiMeaning {
  final String meaning;
  final bool primary;

  KanjiMeaning({
    required this.meaning,
    required this.primary,
  });

  factory KanjiMeaning.fromJson(Map<String, dynamic> json) {
    return KanjiMeaning(
      meaning: json['meaning'],
      primary: json['primary'],
    );
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

Future<Kanji> fetchKanji(int id) async {
  final response =
      await http.get(Uri.parse('http://192.168.2.138:5000/kanji/$id'));

  if (response.statusCode != 200) {
    print('CODE: ${response.statusCode}');
    throw Exception('Failed to load kanji');
  }

  return Kanji.fromJson(jsonDecode(response.body));
}
