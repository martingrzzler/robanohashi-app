import 'package:robanohashi/api/subject_preview.dart';

class Meaning {
  final String meaning;
  final bool primary;

  Meaning({
    required this.meaning,
    required this.primary,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      meaning: json['meaning'],
      primary: json['primary'],
    );
  }
}

abstract class Subject {
  int get id;
  String get object;
  List<SubjectPreview> get componentSubjects;
  List<Meaning> get meanings;
}
