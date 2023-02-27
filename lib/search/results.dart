import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';

import 'api.dart';

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
              var subjects = snapshot.data!.data[index];

              return SearchTile(subject: subjects);
            },
          );
        });
  }
}

class SearchTile extends StatelessWidget {
  const SearchTile({
    super.key,
    required this.subject,
  });

  final SubjectPreview subject;

  _getBackgroundColor() {
    switch (subject.object) {
      case "kanji":
        return Colors.pink;
      case "radical":
        return Colors.blue;
      case "vocabulary":
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: const Icon(Icons.chevron_right),
      leading: Container(
        decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: subject.characters == ""
              ? SizedBox(
                  width: 25,
                  height: 25,
                  child: ScalableImageWidget(
                    si: ScalableImage.fromSvgString(
                      subject.characterImage,
                    ),
                  ),
                )
              : Text(subject.characters,
                  style: const TextStyle(fontSize: 25, color: Colors.white)),
        ),
      ),
      title: Text(subject.readings?.join(", ") ?? "",
          overflow: TextOverflow.ellipsis),
      subtitle: Text(
        subject.meanings.join(", "),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
