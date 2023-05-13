import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/subject_preview.dart';
import 'package:robanohashi/common/colors.dart';
import 'package:robanohashi/common/future_wrapper.dart';
import 'package:robanohashi/common/subject_card.dart';
import 'package:robanohashi/pages/kanji/kanji.dart';
import 'package:robanohashi/pages/radical/radical.dart';
import 'package:robanohashi/pages/vocabulary/vocabulary.dart';
import 'package:robanohashi/service/bookmarks.dart';
import 'package:provider/provider.dart';

class Flashcards extends StatefulWidget {
  const Flashcards({super.key});

  @override
  State<Flashcards> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<Flashcards> {
  int _curretIndex = 0;
  bool _flipCard = false;

  _navigate(BuildContext context, SubjectPreview subject) {
    switch (subject.object) {
      case 'radical':
        Navigator.pushNamed(context, '/radical',
            arguments: RadicalViewArgs(id: subject.id));
        break;
      case 'kanji':
        Navigator.pushNamed(context, '/kanji',
            arguments: KanjiViewArgs(id: subject.id));
        break;
      case 'vocabulary':
        Navigator.pushNamed(context, '/vocabulary',
            arguments: VocabularyViewArgs(id: subject.id));
        break;
    }
  }

  _next(List<SubjectPreview> subjects) {
    if (_curretIndex >= subjects.length - 1) {
      Navigator.pushNamed(context, '/user');
      return;
    }
    setState(() {
      _flipCard = false;
      _curretIndex++;
    });
  }

  _handleRemove(SubjectPreview currentSubject) async {
    final user = context.read<User>();

    try {
      await Api.toggleSubjectBookmarked(
          currentSubject.id, currentSubject.object, user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Oops... something went wrong!'),
      ));

      return;
    }

    if (!mounted) {
      return;
    }

    context.read<BookmarkedSubjectsService>().fetchBookmarkedSubjects(user);
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkedSubjectsService>().subjects;

    return FutureWrapper(
        future: bookmarks,
        onData: (context, data) {
          if (data.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You are done!'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/user');
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ));
          }

          final currentSubject = _curretIndex >= data.length
              ? data[data.length - 1]
              : data[_curretIndex];

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _flipCard
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _navigate(context, currentSubject);
                                },
                                child: Subject(subject: currentSubject)),
                            const SizedBox(height: 15),
                            Text(
                              currentSubject.meanings.join(", "),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      : Center(
                          child: Subject(subject: currentSubject),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _flipCard
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                  await _handleRemove(currentSubject);

                                  if (_curretIndex >= data.length - 1 &&
                                      mounted) {
                                    Navigator.pushNamed(context, '/user');
                                    return;
                                  }

                                  setState(() {
                                    _flipCard = false;
                                  });
                                },
                                child: const Text('Remove')),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () => _next(data),
                                child: const Text('Keep')),
                          )
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _flipCard = true;
                            });
                          },
                          child: const Text('Show Answer'),
                        )),
              )
            ],
          );
        });
  }
}

class Subject extends StatelessWidget {
  const Subject({
    super.key,
    required this.subject,
  });

  final SubjectPreview subject;

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      color: getSubjectBackgroundColor(subject.object),
      child: subject.characters != ""
          ? Text(
              subject.characters,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50.0,
              ),
            )
          : SizedBox(
              width: 50,
              height: 50,
              child: ScalableImageWidget(
                  si: ScalableImage.fromSvgString(subject.characterImage)),
            ),
    );
  }
}
