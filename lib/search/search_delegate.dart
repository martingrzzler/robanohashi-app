import 'package:flutter/material.dart';

import 'api.dart';
import 'results.dart';

class DictionarySearchDelegate extends SearchDelegate {
  late Future<SearchResponse> searchResults;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 2) {
      return const Center(
        child: Text('Results here'),
      );
    }

    searchResults = fetchSearchResults(query);

    return SearchResults(searchResults: searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return const Center(
        child: Text('Results here'),
      );
    }

    searchResults = fetchSearchResults(query);

    return SearchResults(searchResults: searchResults);
  }
}
