import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/service/bookmarks.dart';

class SubjectBookmark extends StatefulWidget {
  const SubjectBookmark(
      {super.key, required this.subjectId, required this.object});

  final int subjectId;
  final String object;

  @override
  State<SubjectBookmark> createState() => _SubjectBookmarkState();
}

class _SubjectBookmarkState extends State<SubjectBookmark> {
  late Future<Map<String, dynamic>> _bookmarkStatus;

  Icon getIcon(bool bookmarked) {
    if (bookmarked) {
      return const Icon(Icons.bookmark);
    } else {
      return const Icon(Icons.bookmark_border);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.watch<User?>();

    onUserChanged(user);
  }

  void onUserChanged(User? user) {
    if (user == null) {
      setState(() {
        _bookmarkStatus = Future.value({'bookmarked': false});
      });
      return;
    }

    setState(() {
      _bookmarkStatus =
          Api.getSubjectBookmarkedStatus(widget.subjectId, widget.object, user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bookmarkStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          // same size as icon
          return IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.bookmark_outline,
                color: Colors.white,
              ));
        }
        return IconButton(
            onPressed: () async {
              final user = context.read<User?>();
              final updateMethod = context
                  .read<BookmarkedSubjectsService>()
                  .fetchBookmarkedSubjects;

              if (user == null) {
                Navigator.pushNamed(context, '/login');
                return;
              }

              final res = await Api.toggleSubjectBookmarked(
                  widget.subjectId, widget.object, user);

              updateMethod(user);

              if (res['status'] == 'added') {
                setState(() {
                  _bookmarkStatus = Future.value({'bookmarked': true});
                });
              } else if (res['status'] == 'removed') {
                setState(() {
                  _bookmarkStatus = Future.value({'bookmarked': false});
                });
              }
            },
            icon: getIcon(snapshot.data!['bookmarked']));
      },
    );
  }
}
