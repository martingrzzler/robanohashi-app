import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:robanohashi/api/common.dart';
import 'package:robanohashi/common/meaning_mnemonics/tagged_mnemonic.dart';
import 'package:robanohashi/common/meaning_mnemonics/untagged_mnemonic.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';

import 'form.dart';

class Mnemonics extends StatefulWidget {
  const Mnemonics({
    super.key,
    required this.subject,
  });

  final Subject subject;

  @override
  State<Mnemonics> createState() => _MnemonicsState();
}

class _MnemonicsState extends State<Mnemonics> {
  FormConfig _formConfig = FormConfig(editing: false);
  bool _showReadingMnemonic = false;
  late Future<List<MeaningMnemonic>> _mnemonics;

  @override
  void initState() {
    super.initState();

    _mnemonics = Api.fetchMeaningMnemonics(
      widget.subject.id,
      context.read<User?>(),
    );
  }

  String _getUsername(String mnemonicUserId, User? user) {
    if (user != null && mnemonicUserId == user.uid) {
      return 'You';
    } else if (mnemonicUserId == 'wanikani') {
      return 'WaniKani';
    } else if (mnemonicUserId == 'ai_generated') {
      return 'AI Generated';
    } else {
      return 'by User';
    }
  }

  Map<String, Token> _getCompositionTokens() {
    final tokens = <String, Token>{};
    for (final token in widget.subject.componentSubjects
        .map((e) => e.meanings.first)
        .toList()) {
      tokens[token] =
          widget.subject.object == 'kanji' ? Token.radical : Token.kanji;
    }

    for (final meaning in widget.subject.meanings) {
      tokens[meaning.meaning] =
          widget.subject.object == 'kanji' ? Token.kanji : Token.vocabulary;
    }
    return tokens;
  }

  void handleOnFormSubmit(String text) async {
    final mnemonic = _formConfig.mnemonic;

    setState(() {
      _formConfig = FormConfig(editing: false);
    });

    final user = context.read<User?>();

    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      if (mnemonic != null) {
        await Api.updateMeaningMnemonic(mnemonic.id, user, text);
      } else {
        await Api.createMeaningMnemonic(widget.subject, user, text);
      }
      setState(() {
        _mnemonics = Api.fetchMeaningMnemonics(widget.subject.id, user);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create mnemonic'),
        ),
      );
    }
  }

  void handleOnUpvote(MeaningMnemonic mnemonic) {
    return updateMnemonic(
        (user) async => await Api.voteMeaningMnemonic(1, mnemonic.id, user),
        'Failed to upvote mnemonic');
  }

  void handleOnDonwvote(MeaningMnemonic mnemonic) {
    return updateMnemonic(
        (user) async => await Api.voteMeaningMnemonic(-1, mnemonic.id, user),
        'Failed to downvote mnemonic');
  }

  void handleToggleFavorite(MeaningMnemonic mnemonic) {
    return updateMnemonic(
        (user) async =>
            await Api.toggleMeaningMnemonicFavorite(mnemonic.id, user),
        'Failed to toggle favorite');
  }

  void handleOnDelete(MeaningMnemonic mnemonic) {
    return updateMnemonic(
        (user) async => await Api.deleteMeaningMnemonic(mnemonic.id, user),
        'Failed to delete mnemonic');
  }

  void updateMnemonic(Function(User) onUpdate, String failureMessage) async {
    final user = context.read<User?>();

    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      await onUpdate(user);
      setState(() {
        _mnemonics = Api.fetchMeaningMnemonics(widget.subject.id, user);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    return FutureBuilder(
      future: _mnemonics,
      builder: (context, snapshot) {
        if (_formConfig.editing) {
          return MnemonicForm(
            onClose: () {
              setState(() {
                _formConfig = FormConfig(editing: false);
              });
            },
            onSubmit: handleOnFormSubmit,
            defaultText: _formConfig.mnemonic?.text,
          );
        }

        if (_showReadingMnemonic) {
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () => setState(() {
                          _showReadingMnemonic = false;
                        }),
                    icon: const Icon(Icons.close)),
              ),
              TaggedMnemonic(
                mnemonic: widget.subject.readingMnemonic,
                tags: const {Tag.ja, Tag.kanji, Tag.reading},
              ),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
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

        final data = snapshot.data as List<MeaningMnemonic>;

        return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (context.read<User?>() == null) {
                          Navigator.pushNamed(context, '/login');
                          return;
                        }

                        setState(() {
                          _formConfig = FormConfig(editing: true);
                        });
                      },
                      label: const Text('Add a mnemonic'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.record_voice_over_rounded),
                      onPressed: () {
                        setState(() {
                          _showReadingMnemonic = !_showReadingMnemonic;
                        });
                      },
                      label: const Text('Reading'),
                    ),
                  ],
                );
              }

              final mnemonic = data[index - 1];

              return Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () => handleToggleFavorite(mnemonic),
                          icon: Icon(
                            mnemonic.favorite! ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                          )),
                      Row(children: [
                        Transform.rotate(
                          angle: pi / 2,
                          child: IconButton(
                            iconSize: 30,
                            onPressed: () => handleOnUpvote(mnemonic),
                            icon: Icon(
                              Icons.chevron_left,
                              color: mnemonic.upvoted! ? Colors.orange : null,
                            ),
                          ),
                        ),
                        Text(mnemonic.votingCount.toString()),
                        Transform.rotate(
                            angle: -pi / 2,
                            child: IconButton(
                              iconSize: 30,
                              onPressed: () => handleOnDonwvote(mnemonic),
                              icon: const Icon(Icons.chevron_left),
                              color: mnemonic.downvoted! ? Colors.orange : null,
                            ))
                      ]),
                      mnemonic.me!
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _formConfig = FormConfig(
                                      editing: true, mnemonic: mnemonic);
                                });
                              },
                              icon: const Icon(Icons.edit),
                              color: Colors.grey[600],
                            )
                          : Container(),
                      mnemonic.me!
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('Are you sure?'),
                                          content: const Text(
                                              'The mnemonic will be deleted permanently.'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel')),
                                            OutlinedButton(
                                              onPressed: () {
                                                handleOnDelete(mnemonic);
                                                Navigator.pop(context);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: Colors.red[200]!,
                                                      width: 2)),
                                              child: Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors.red[200])),
                                            )
                                          ],
                                        ));
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red[200],
                            )
                          : Container(),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              _getUsername(mnemonic.userId, user),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              timeago.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      mnemonic.updatedAt * 1000)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: mnemonic.userId == 'wanikani'
                            ? TaggedMnemonic(
                                mnemonic: mnemonic.text,
                                tags: const {
                                    Tag.kanji,
                                    Tag.radical,
                                    Tag.vocabulary,
                                    Tag.ja,
                                  })
                            : UntaggedMnemonic(
                                text: mnemonic.text,
                                meanings: _getCompositionTokens()),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              );
            });
      },
    );
  }
}
