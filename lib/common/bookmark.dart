import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robanohashi/api/api.dart';

class SubjectBookmark extends StatefulWidget {
  const SubjectBookmark(
      {super.key, required this.subjectId, required this.object});

  final int subjectId;
  final String object;

  @override
  State<SubjectBookmark> createState() => _SubjectBookmarkState();
}

class _SubjectBookmarkState extends State<SubjectBookmark> {
  bool bookmarked = false;

  Icon getIcon() {
    if (bookmarked) {
      return const Icon(Icons.bookmark);
    } else {
      return const Icon(Icons.bookmark_border);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    onUserChanged();
  }

  void onUserChanged() {
    final user = context.watch<User?>();

    if (user == null) {
      setState(() {
        bookmarked = false;
      });
      return;
    }

    Api.getSubjectBookmarkedStatus(widget.subjectId, widget.object, user)
        .then((value) => {
              setState(() {
                bookmarked = value['bookmarked'];
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final user = context.read<User?>();

          if (user == null) {
            Navigator.pushNamed(context, '/login');
            return;
          }

          final res = await Api.toggleSubjectBookmarked(
              widget.subjectId, widget.object, user);

          if (res['status'] == 'added') {
            setState(() {
              bookmarked = true;
            });
          } else if (res['status'] == 'removed') {
            setState(() {
              bookmarked = false;
            });
          }
        },
        icon: getIcon());
  }
}
