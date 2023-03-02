import 'kanji.dart';
import 'radical.dart';
import 'search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'http://192.168.2.138:5000';

  static Future<SearchResponse> fetchSearchResults(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load search results');
    }

    return SearchResponse.fromJson(jsonDecode(response.body));
  }

  static Future<Kanji> fetchKanji(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/kanji/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load kanji');
    }

    return Kanji.fromJson(jsonDecode(response.body));
  }

  static Future<Radical> fetchRadical(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/radical/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load radical');
    }

    return Radical.fromJson(jsonDecode(response.body));
  }
}
