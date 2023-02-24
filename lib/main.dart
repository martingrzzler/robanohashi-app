import 'dart:ffi';

import 'package:flutter/material.dart';
import 'kanji.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Roba no hashi",
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Kanji(),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

  late Future<SearchResponse> searchResults;

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    print("buildResults $query");
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return const Center(
        child: Text('Results here'),
      );
    }

    searchResults = fetchSearchResults(query);

    return FutureBuilder(
        future: searchResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.totalCount == 0) {
              return const Center(
                child: Text('No results'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                var result = snapshot.data!.data[index];
                return ListTile(
                  title: result.characters != ""
                      ? Text(result.characters)
                      : SvgPicture.string(result.characterImage),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return const CircularProgressIndicator();
        });
  }
}

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
      .get(Uri.parse('http://martingrzzler:5000/search?query=$query'));

  if (response.statusCode == 200) {
    return SearchResponse.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to load search results');
}
