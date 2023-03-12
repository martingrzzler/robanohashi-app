import 'package:firebase_auth/firebase_auth.dart';
import 'package:robanohashi/api/common.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';
import 'package:robanohashi/api/vocabulary.dart';

import 'kanji.dart';
import 'radical.dart';
import 'search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = 'https://api.robanohashi.org';

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

  static Future<List<dynamic>> fetchMeaningMnemonicsBySubject(
      int subjectId, User? user) async {
    final headers = user != null
        ? <String, String>{'Authorization': 'Bearer ${await user.getIdToken()}'}
        : <String, String>{};

    final response = await http.get(
        Uri.parse('$baseUrl/subject/$subjectId/meaning_mnemonics'),
        headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meaning mnemonics');
    }

    if (user == null) {
      return List<MeaningMnemonic>.from(jsonDecode(response.body)["items"]
          .map((e) => MeaningMnemonic.fromJson(e)));
    }

    return List<MeaningMnemonicWithUserInfo>.from(
        jsonDecode(response.body)["items"]
            .map((e) => MeaningMnemonicWithUserInfo.fromJson(e)));
  }

  static Future<List<MeaningMnemonicWithUserInfo>> fetchMeaningMnemonicsByUser(
      User user) async {
    final response = await http.get(
        Uri.parse('$baseUrl/user/meaning_mnemonics'),
        headers: <String, String>{
          'Authorization': 'Bearer ${await user.getIdToken()}'
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to load meaning mnemonics');
    }

    return List<MeaningMnemonicWithUserInfo>.from(
        jsonDecode(response.body)["items"]
            .map((e) => MeaningMnemonicWithUserInfo.fromJson(e)));
  }

  static Future<List<MeaningMnemonicWithUserInfo>>
      fetchMeaningMnemonicsFavorites(User user) async {
    final response = await http.get(
        Uri.parse('$baseUrl/meaning_mnemonics/favorites'),
        headers: <String, String>{
          'Authorization': 'Bearer ${await user.getIdToken()}'
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to load meaning mnemonics');
    }

    return List<MeaningMnemonicWithUserInfo>.from(
        jsonDecode(response.body)["items"]
            .map((e) => MeaningMnemonicWithUserInfo.fromJson(e)));
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

  static Future<Map<String, dynamic>> voteMeaningMnemonic(
      int vote, String mnemonicId, User user) async {
    final response =
        await http.post(Uri.parse('$baseUrl/meaning_mnemonic/vote'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${await user.getIdToken()}'
            },
            body: jsonEncode(<String, dynamic>{
              'vote': vote,
              'meaning_mnemonic_id': mnemonicId,
            }));

    if (response.statusCode != 200) {
      throw Exception('Failed to vote meaning mnemonic');
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> toggleMeaningMnemonicFavorite(
      String mnemonicId, User user) async {
    final response =
        await http.post(Uri.parse('$baseUrl/meaning_mnemonic/toggle_favorite'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${await user.getIdToken()}'
            },
            body: jsonEncode(<String, dynamic>{
              'id': mnemonicId,
            }));

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle meaning mnemonic favorite');
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateMeaningMnemonic(
      String mnemonicId, User user, String text) async {
    final response = await http.put(Uri.parse('$baseUrl/meaning_mnemonic'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${await user.getIdToken()}'
        },
        body: jsonEncode(<String, dynamic>{
          'id': mnemonicId,
          'text': text,
        }));

    if (response.statusCode != 200) {
      throw Exception('Failed to update meaning mnemonic');
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteMeaningMnemonic(
      String mnemonicId, User user) async {
    final response = await http.delete(Uri.parse('$baseUrl/meaning_mnemonic'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${await user.getIdToken()}'
        },
        body: jsonEncode(<String, dynamic>{
          'id': mnemonicId,
        }));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete meaning mnemonic');
    }

    return jsonDecode(response.body);
  }
}
