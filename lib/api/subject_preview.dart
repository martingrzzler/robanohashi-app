class SubjectPreview {
  final int id;
  final String object;
  final String slug;
  final String characters;
  final String characterImage;
  final List<String> meanings;
  final List<String>? readings;

  SubjectPreview({
    required this.id,
    required this.object,
    required this.slug,
    required this.characters,
    required this.characterImage,
    required this.meanings,
    this.readings,
  });

  factory SubjectPreview.fromJson(Map<String, dynamic> json) {
    return SubjectPreview(
        id: json['id'],
        object: json['object'],
        slug: json['slug'],
        characters: json['characters'],
        characterImage: json['character_image'],
        meanings: json['meanings'].cast<String>(),
        readings:
            // ignore: prefer_null_aware_operators
            json['readings'] != null ? json['readings'].cast<String>() : null);
  }
}
