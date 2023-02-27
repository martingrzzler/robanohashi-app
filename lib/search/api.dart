import 'dart:convert';
import 'package:http/http.dart' as http;

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

class SearchResponse {
  final int totalCount;
  final List<SubjectPreview> data;

  SearchResponse({
    required this.totalCount,
    required this.data,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
        totalCount: json['total_count'],
        data: List<SubjectPreview>.from(
            json['data'].map((x) => SubjectPreview.fromJson(x))));
  }
}

Future<SearchResponse> fetchSearchResults(String query) async {
  final response = await http
      .get(Uri.parse('http://192.168.2.123:5000/search?query=$query'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load search results');
  }

  return SearchResponse.fromJson(jsonDecode(response.body));
}
