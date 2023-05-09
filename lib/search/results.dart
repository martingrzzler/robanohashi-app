import 'package:flutter/material.dart';
import 'package:robanohashi/api/search.dart';
import 'package:robanohashi/common/subject_preview_card.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    super.key,
    required this.searchResults,
  });

  final Future<SearchResponse> searchResults;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error),
                SizedBox(width: 10),
                Text('Oops, something went wrong!'),
              ],
            ));
          }
          if (snapshot.hasData && snapshot.data!.totalCount == 0) {
            return const Center(
              child: Text('No results found'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.data.length,
            itemBuilder: (context, index) {
              var subject = snapshot.data!.data[index];

              return SubjectPreviewCard(subject: subject);
            },
          );
        });
  }
}
