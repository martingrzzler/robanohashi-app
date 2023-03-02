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
