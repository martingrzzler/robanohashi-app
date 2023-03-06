import 'package:firebase_auth/firebase_auth.dart';
import 'package:robanohashi/api/common.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';
import 'package:robanohashi/api/subject_preview.dart';
import 'package:robanohashi/api/vocabulary.dart';

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

  static Future<Vocabulary> fetchVocabulary(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/vocabulary/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load vocabulary');
    }

    return Vocabulary.fromJson(jsonDecode(response.body));
  }

  static Future<List<MeaningMnemonic>> fetchMeaningMnemonics(
      int subjectId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/subject/$subjectId/meaning_mnemonics'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load meaning mnemonics');
    }

    return List<MeaningMnemonic>.from(jsonDecode(response.body)["data"]
        .map((e) => MeaningMnemonic.fromJson(e)));
  }

  static Future<Map<String, dynamic>> createMeaningMnemonic(
      Subject subject, User user, String mnemonic) async {
    final response = await http.post(
      Uri.parse('$baseUrl/meaning_mnemonic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await user.getIdToken()}'
      },
      body: jsonEncode(<String, dynamic>{
        'object': subject.object,
        'subject_id': subject.id,
        'text': mnemonic,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create meaning mnemonic');
    }

    return jsonDecode(response.body);
  }
}
