import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:robanohashi/api/meaning_mnemonic.dart';
import 'package:robanohashi/common/mnemonic/untagged_mnemonic.dart';

import 'tagged_mnemonic.dart';

class MnemonicView extends StatelessWidget {
  const MnemonicView(
      {super.key,
      required this.mnemonic,
      required this.onOnUpvote,
      required this.onOnDonwvote,
      required this.onToggleFavorite,
      required this.onDelete,
      required this.onEdit});

  final MeaningMnemonicWithUserInfo mnemonic;
  final Function(MeaningMnemonicWithUserInfo) onOnUpvote;
  final Function(MeaningMnemonicWithUserInfo) onOnDonwvote;
  final Function(MeaningMnemonicWithUserInfo) onToggleFavorite;
  final Function(MeaningMnemonicWithUserInfo) onDelete;
  final Function(MeaningMnemonicWithUserInfo) onEdit;

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
    for (final token in mnemonic.subject.componentSubjects
        .map((e) => e.meanings.first)
        .toList()) {
      tokens[token] =
          mnemonic.subject.object == 'kanji' ? Token.radical : Token.kanji;
    }

    for (final meaning in mnemonic.subject.meanings) {
      tokens[meaning.meaning] =
          mnemonic.subject.object == 'kanji' ? Token.kanji : Token.vocabulary;
    }
    return tokens;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
                onPressed: () => onToggleFavorite(mnemonic),
                icon: Icon(
                  mnemonic.favorite ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                )),
            Row(children: [
              Transform.rotate(
                angle: pi / 2,
                child: IconButton(
                  iconSize: 30,
                  onPressed: () => onOnUpvote(mnemonic),
                  icon: Icon(
                    Icons.chevron_left,
                    color: mnemonic.upvoted ? Colors.orange : null,
                  ),
                ),
              ),
              Text(mnemonic.votingCount.toString()),
              Transform.rotate(
                  angle: -pi / 2,
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () => onOnDonwvote(mnemonic),
                    icon: const Icon(Icons.chevron_left),
                    color: mnemonic.downvoted ? Colors.orange : null,
                  ))
            ]),
            mnemonic.me
                ? IconButton(
                    onPressed: () => onEdit(mnemonic),
                    icon: const Icon(Icons.edit),
                    color: Colors.grey[600],
                  )
                : Container(),
            mnemonic.me
                ? IconButton(
                    onPressed: () => onDelete(mnemonic),
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(
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
                  ? TaggedMnemonic(mnemonic: mnemonic.text, tags: const {
                      Tag.kanji,
                      Tag.radical,
                      Tag.vocabulary,
                      Tag.ja,
                    })
                  : UntaggedMnemonic(
                      text: mnemonic.text, meanings: _getCompositionTokens()),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}
